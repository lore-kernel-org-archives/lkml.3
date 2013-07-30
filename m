Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab3G3FTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 01:19:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54435 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab3G3FTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 01:19:53 -0400
Message-ID: <51F74CEC.8040407@ti.com>
Date: Tue, 30 Jul 2013 10:49:40 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <kishon@ti.com>
Subject: Re: [PATCH v2 2/4] phy: phy-amxxxx-usb: Add PHY driver for amxxxx
 platform
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com> <1374237277-17769-3-git-send-email-george.cherian@ti.com> <20130729151754.GB827@linutronix.de>
In-Reply-To: <20130729151754.GB827@linutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/2013 8:47 PM, Sebastian Andrzej Siewior wrote:
> * George Cherian | 2013-07-19 18:04:35 [+0530]:
>
>> Adds phy driver support for am33xx platform, the host/device
>> peripheral controller shall get this phy object to control the phy
>> operations.
> If you rebase this on-top of the two instances patches I've sent earlier
> then you can bury patch 3 and 4, right?

Yes True. I posted it for completeness.


>
> I don't like very much the way you obtain the phy id:
>> +		of_property_read_u32(np, "id", &phy->id);
> with the .dts changes I made you should able to use
>      of_alias_get_id()
> instead.
>
> Let me look what you have additionaly:
> - usbotg_fck
>    Is this really required? I have the phy as a child of the "main"
>    device which has a hwmod property which is associated with this clock.
>    So pm enable/ disable should also enable this clock if possible,
>    right?
>
> - device wakeup via omap_control_am335x_phy_wkup()
>    Now. that is one thing that the simple phy driver is missing. If you
>    call a magic function for this to happen than I don't have to worry
>    about the missing memory space for this function.
>
> So from what I see now, it is most likely the easiest thing to just add
> that wakeup to the phy driver I posted. Do you agree?

The whole idea of writing a seperate phy driver was to use the generic phy framework
and most of the amxxxx devices have the same phy (eg am335x, am437x).
Now since the register is shared in am335x for phy_wkup (Not in the case of am437x)
how are you planning to  map it. I feel if omap_control_usb can delegate the writes
to phy_wkup, phy_on and phy_off, it makes the life simpler.

Thoughts???

> If so we need to figure out where the memory for the wakeup register is
> comming from. We need also to ensure that both phys can not write at the
> same time. A look would be nice.
>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
> Sebastian


-- 
-George

