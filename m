Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab3DYXvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 19:51:46 -0400
Received: from warmcat.com ([87.106.134.80]:47270 "EHLO warmcat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab3DYXvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 19:51:45 -0400
Message-ID: <5179C187.509@linaro.org>
Date: Fri, 26 Apr 2013 07:51:35 +0800
From: Andy Green <andy.green@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130403 Thunderbird/17.0.5
MIME-Version: 1.0
To: Suman Anna <s-anna@ti.com>
CC: Jassi Brar <jaswinder.singh@linaro.org>,
        Loic PALLARDY <loic.pallardy@st.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "Ohad Ben-Cohen (ohad@wizery.com)" <ohad@wizery.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv3 00/14] drivers: mailbox: framework creation
References: <1363145021-14339-1-git-send-email-s-anna@ti.com> <CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com> <37C860A02101E749A747FA2D3C1E3C504A5DF7@DLEE11.ent.ti.com> <CABb+yY1x4x_A+QtGG9ohsLPgs8c3nEVnd_ExJBGOOR8=6YLPFA@mail.gmail.com> <37C860A02101E749A747FA2D3C1E3C504A63B4@DLEE11.ent.ti.com> <CAJe_ZhehnniZd730jjiOLrHozq8TOJZgFYLqUe4KqgBiQEu8PA@mail.gmail.com> <51779304.4040003@st.com> <CAJe_ZhdZv5LW6kdwyPtJe69mfW6t=WQ4OJnG2H4sUhibattN2A@mail.gmail.com> <517867E1.7050301@ti.com> <CAJe_ZhfDZzq+DzA9XDF3PWFUmwcZnDy-mhE4hLNHmf+V4GhOxw@mail.gmail.com> <5179AE2F.3040403@ti.com>
In-Reply-To: <5179AE2F.3040403@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/13 06:29, the mail apparently from Suman Anna included:

Hi -

>>> 3. Shareable/exclusive nature of a mailbox. If it is shareable, then
>>> duplicating the behavior between clients is not worth it, and this
>>> should be absorbed into the respective controller driver.
>>>
>> I think the mailbox should be exclusively held by a client. That makes
>> many things simpler. Also remote firmwares won't be always robust
>> enough to handle commands from different subsystems intermixed. The
>> API only has to make sure the mailbox_get/put operations are very
>> thin.
>
> This might be the case for specific remotes where we expect only one
> client driver to be responsible for talking to it, but for generic
> offloading, you do not want to have this restriction. You do not want
> peer clients to go through a single main client, as the latencies or the
> infrastructure imposed by the main client may not be suitable for the
> other clients. The stricter usecase here would be the shareable mailbox,
> and if it is exclusive, as dictated by a controller or device property,
> then so be it and things would get simplified for that controller/device.

Knowing why Jassi mentioned this, the situation is a bit different than 
what you replied to.  There are in fact multiple client drivers that can 
asynchronously decide to initiate communication on the same mailbox. 
Some of the client need to perform multi-step sequencing and lock the 
mailbox for the duration.

Right now we can implement that by having a driver on top to mediate, 
Jassi is suggesting being able to do the client locking at your layer as 
a primitive will simplify things, not least get rid of the mediation 
driver.  Your layer has concept of completion and notifier already so it 
seems it wouldn't take much more.

-Andy

-- 
Andy Green | Fujitsu Landing Team Leader
Linaro.org │ Open source software for ARM SoCs | Follow Linaro
http://facebook.com/pages/Linaro/155974581091106  - 
http://twitter.com/#!/linaroorg - http://linaro.org/linaro-blog
