Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbbATSej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:34:39 -0500
Received: from senator.holtmann.net ([87.106.208.187]:46341 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbbATSeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:34:37 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH] bluetooth: Add hci_h4p driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20150120173604.GA712@amd>
Date: Tue, 20 Jan 2015 10:34:30 -0800
Cc: =?utf-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7522CAC7-AFD9-470F-B4F8-3C39942DBC04@holtmann.org>
References: <20141223130219.GA5731@amd> <CB643345-4B50-4ED0-8C3E-296CD225754D@holtmann.org> <20150120173604.GA712@amd>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

>>> Add HCI driver for H4 with Nokia extensions. This device is used on
>>> Nokia N900 cell phone.
>>> 
>>> Older version of this driver lived in staging, before being reverted
>>> in a4102f90e87cfaa3fdbed6fdf469b23f0eeb4bfd .
>>> 
>>> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>>> Thanks-to: Sebastian Reichel <sre@debian.org>
>>> Thanks-to: Joe Perches <joe@perches.com>
>>> 
>>> ---
>>> 
>>> Please apply,
>>> 								Pavel
>>> 
>>> 
>>> Kconfig      |   10 
>>> Makefile     |    4 
>>> nokia_core.c | 1149 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>> nokia_fw.c   |   99 +++++
>>> nokia_h4p.h  |  214 ++++++++++
>>> nokia_uart.c |  171 ++++++++
>>> 7 files changed, 1667 insertions(+)
> 
> Speaking about formatting, could you properly format your emails, that
> is inserting newline after ~78 columns, to make them easier to reply
> to?

or you get an email client that can handle that part.

>> so when I run this through checkpatch --strict, then I get tons of warning that we have DOS style ^M line breaks. There are also trailing whitespace that need fixing. I can use cleanpatch to do this, but so can you.
>> 
> 
> Strange, where do you see DOS style line breaks? Checkpatch here does
> not warn about that, and they really should not be there.

If that would be the only pieces, then I would have fixed it already. That is not the big deal. The rest of checkpatch is what I am not going to fix for you.

>> Even after doing that there are still obvious plain coding style violation in the patch. For example:
>> 
>> ERROR: space prohibited before that ',' (ctx:WxW)
>> #610: FILE: drivers/bluetooth/nokia_core.c:517:
>> +			__h4p_set_auto_ctsrts(info, 0 , UART_EFR_RTS);
> 
> Yeah, I should have catched that one.
> 
>> CHECK: Alignment should match open parenthesis
>> #662: FILE: drivers/bluetooth/nokia_core.c:569:
>> +		h4p_outb(info, UART_OMAP_SCR,
>> +			     h4p_inb(info, UART_OMAP_SCR) |
>> 
>> CHECK: Blank lines aren't necessary before a close brace '}'
>> #692: FILE: drivers/bluetooth/nokia_core.c:599:
>> +
>> +}
>> 
>> These are only few. They are more and all these need fixing before I
>> even consider it.
> 
> Yeah, so first patch was too good for staging, and I "would be allowed
> to clean it up in tree", and now you run checkpatch --strict,
> complaining about very serious stuff such as "blank lines before }".

The network subsystem requires the --strict option.

Please stop complaining about staging. The patch went in, it was ignored for month and multiple kernel release and it got removed. Deal with it.

> 
> Yes, checkpatch produces a lot of junk, like warnings about
> mdelay(). I'm not sure how you'd want #662 above, formatted.
> 
> pavel@amd:/data/l/linux-n900$ scripts/checkpatch.pl --strict --file
> drivers/bluetooth/*.c | wc -l 3194
> pavel@amd:/data/l/linux-n900$
> 
> ...so I really can't know which checkpatch complains you consider
> serious and which are ok... And yes, I guess I should trim down those
> FSF notices.

The FSF notices are the ones I do not care about right now. Even the over 80 characters lines can be ignored if it just makes sense to go over.

The indentations ones need to be fixed.

> 
>> Also this worries me:
>> 
>> WARNING: DT compatible string "brcm,uart,bcm2048" appears un-documented -- check ./Documentation/devicetree/bindings/
>> #1222: FILE: drivers/bluetooth/nokia_core.c:1129:
>> +	{ .compatible = "brcm,uart,bcm2048" },
> 
> Yes, that wories me, too. It is one of reasons I wanted this to be
> merged to staging. Arguing about right bindings will take some time.

Then that needs to be figured out. It is not that I have mentioned DT for the first time. I said that right from the beginning.

> I can fix the checkpatch stuff that makes sense. That does not include
> uglyfying code just for checkpatch.  Can you then take the patch, as
> you promised, and let me argue the bindings, and the other stuff that
> needs to be fixed?
> 
> If not, can we agree that the driver in staging should be reverted, as
> Greg promised would be "easy", and I can clean it up there?

I am refusing to allow this into staging. Get this into shape for drivers/bluetooth/ or keep the driver external.

Regards

Marcel

