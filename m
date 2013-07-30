Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab3G3Ixr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:53:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:54636 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab3G3Ixp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:53:45 -0400
Message-ID: <51F77F15.7090306@linutronix.de>
Date: Tue, 30 Jul 2013 10:53:41 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: linux-usb@vger.kernel.org, balbi@ti.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH v2 2/4] phy: phy-amxxxx-usb: Add PHY driver for amxxxx
 platform
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com> <1374237277-17769-3-git-send-email-george.cherian@ti.com> <20130729151754.GB827@linutronix.de> <51F74CEC.8040407@ti.com>
In-Reply-To: <51F74CEC.8040407@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 07:19 AM, George Cherian wrote:
>> So from what I see now, it is most likely the easiest thing to just add
>> that wakeup to the phy driver I posted. Do you agree?
> 
> The whole idea of writing a seperate phy driver was to use the generic
> phy framework
> and most of the amxxxx devices have the same phy (eg am335x, am437x).
> Now since the register is shared in am335x for phy_wkup (Not in the case
> of am437x)
> how are you planning to  map it. I feel if omap_control_usb can delegate
> the writes
> to phy_wkup, phy_on and phy_off, it makes the life simpler.

that omap-control driver looks a little strange. It has a compatible
field saying ti,omap-control-usb and then it requires additionally a
ti,type property which should have been avoided.

But back to the initial problem. I don't really like the idea of
touching in the control-module registers but others do it as well.
So the idea of a control driver doesn't sound that bad.
- an am335x-reset device
- a phy driver with a reference to that reset device.
- non-standard phy calls for power & wak eup on/off.

Let me think about it.

> 
> Thoughts???

I think I buy it but give me a bit…

> 

Sebastian
