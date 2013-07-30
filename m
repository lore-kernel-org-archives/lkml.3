Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab3G3OZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:25:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50296 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881Ab3G3OZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:25:07 -0400
Message-ID: <51F7CCB7.4040305@ti.com>
Date: Tue, 30 Jul 2013 19:54:55 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <kishon@ti.com>
Subject: Re: [PATCH v2 2/4] phy: phy-amxxxx-usb: Add PHY driver for amxxxx
 platform
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com> <1374237277-17769-3-git-send-email-george.cherian@ti.com> <20130729151754.GB827@linutronix.de> <51F74CEC.8040407@ti.com> <51F77F15.7090306@linutronix.de>
In-Reply-To: <51F77F15.7090306@linutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/2013 2:23 PM, Sebastian Andrzej Siewior wrote:
> On 07/30/2013 07:19 AM, George Cherian wrote:
>>> So from what I see now, it is most likely the easiest thing to just add
>>> that wakeup to the phy driver I posted. Do you agree?
>> The whole idea of writing a seperate phy driver was to use the generic
>> phy framework
>> and most of the amxxxx devices have the same phy (eg am335x, am437x).
>> Now since the register is shared in am335x for phy_wkup (Not in the case
>> of am437x)
>> how are you planning to  map it. I feel if omap_control_usb can delegate
>> the writes
>> to phy_wkup, phy_on and phy_off, it makes the life simpler.
> that omap-control driver looks a little strange. It has a compatible
> field saying ti,omap-control-usb and then it requires additionally a
> ti,type property which should have been avoided.

ti,type property is to differentiate between usb2 and usb3 phy for a 
single soc.
for eg: OMAP5 has both usb2 and usb3 phy


-- 
-George

