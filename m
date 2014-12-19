Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaLSOI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:08:57 -0500
Received: from avocado.raritan.com ([24.38.102.198]:39017 "EHLO
	Avocado.raritan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaLSOIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:08:53 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Dec 2014 09:08:53 EST
Message-ID: <54942FDC.8030404@raritan.com>
Date: Fri, 19 Dec 2014 15:02:04 +0100
From: Ronald Wahl <ronald.wahl@raritan.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>, Felipe Balbi <balbi@ti.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-usb@vger.kernel.org>, <stable@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RESEND PATCH] usb: gadget: at91_udc: move prepare clk into process
 context
References: <1416411447-31112-1-git-send-email-nicolas.ferre@atmel.com> <20141120195049.GF23217@saruman> <20141219135123.GA2620@charon>
In-Reply-To: <20141219135123.GA2620@charon>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.12.2014 14:51, Luis Henriques wrote:
> Hi Felipe,
>
> On Thu, Nov 20, 2014 at 01:50:49PM -0600, Felipe Balbi wrote:
>> On Wed, Nov 19, 2014 at 04:37:27PM +0100, Nicolas Ferre wrote:
>>> From: Ronald Wahl <ronald.wahl@raritan.com>
>>>
>>> Commit 7628083227b6bc4a7e33d7c381d7a4e558424b6b (usb: gadget: at91_udc:
>>> prepare clk before calling enable) added clock preparation in interrupt
>>> context. This is not allowed as it might sleep. Also setting the clock
>>> rate is unsafe to call from there for the same reason. Move clock
>>> preparation and setting clock rate into process context (at91udc_probe).
>>>
>>> Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
>>> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>>> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>> Cc: Felipe Balbi <balbi@ti.com>
>>> Cc: <stable@vger.kernel.org> # v3.17+
>>> ---
>>> Hi Felipe,
>>>
>>> I forgot to answer you on this patch. So I resend it now with the proper
>>> "stable" tag. You can also queue it during this -rc phase if you feel it is
>>> still possible.
>>
>> I think it's late for v3.18, so it'll go on v3.19 and get backported to
>> 3.17 and 3.18. Sorry :-s
>>
>
> Although this commit (b2ba27a5c56f "usb: gadget: at91_udc: move
> prepare clk into process context") is tagged for stable v3.17+, it
> seems like it could be applied to earlier kernels.
>
> 3.16, 3.13 and 3.12 seem to be affected by the same issue (and they
> all include commit 7628083227b6 "usb: gadget: at91_udc: prepare clk
> before calling enable").  Is there any reason for not applying it in
> these trees?

Not to forget 3.14 (LTS) which was the branch where I primarily found 
the issue...

- ron

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Ralf Ploenes
