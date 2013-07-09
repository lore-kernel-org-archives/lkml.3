Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab3GIFkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 01:40:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44784 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3GIFkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 01:40:18 -0400
Message-ID: <51DBA23A.8000505@ti.com>
Date: Tue, 9 Jul 2013 11:10:10 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <kishon@ti.com>
Subject: Re: [PATCH 0/5] Add phy support for AM335X platform using Generic
 PHy framework
References: <1373280201-31785-1-git-send-email-george.cherian@ti.com> <51DB16A1.6010006@linutronix.de>
In-Reply-To: <51DB16A1.6010006@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/2013 1:14 AM, Sebastian Andrzej Siewior wrote:
> On 07/08/2013 12:43 PM, George Cherian wrote:
>> This patch series adds phy support for AM335X platform.
>> This patch series is based on Generic PHY framework [1].
>>
>>
>> This series has
>> 	- adds dual musb instances support for am335x platform (just for testing)
>> 	- adds phy-amxxxx-usb driver used in AMxxxx platforms
>> 	- adds dt  bindings for the phys
>> 	- removes usb-phy and replaced with generic phy apis in glue layer
> No, I don't like this all. You did the one thing I tried to avoid while
> posting my quick-and-dirty phy driver recently: You duplicated a lot of
> code which can be served by the nop driver and added only power
> on/power off callbacks.
I wanted to add phy wakeup control also, but currently phy_ops  dont 
have an op for wkup_ctrl
Kishon, Can we add one?
> In numbers:
>>   7 files changed, 316 insertions(+), 70 deletions(-)
> vs
>     2 files changed, 117 insertions, 12 deletions
>
> I assumed you had also the OTG callbacks (set host/device mode) and
> wake up but I don't see it there.
> Adding a power regulator would do the same job, wouldn't it? If the phy
> driver remains just doing power on/off I suggest simply adding a power
> regulator. If it will do more I would move the am35xx specific bits
> into a separate file and glue it to the nop driver.
>
> What else? The abstraction in device tree is wrong. It remains wrong if
> add stuff on top to it.
Yes definitely , I liked the way you split the device node. Probably I 
should base on your dt patch and add
phy nodes.
> We need two nodes each one with a glue layer and a musb child node. The
> instances crap in kernel has to vanish.
Same as above  I just did it for quick testing (mentioned in the commit 
log).
> Also that means your phy nodes
> are wrong. This is not musb with two ports but two musb instances each
> with one port.
yes true.
> Sebastian

