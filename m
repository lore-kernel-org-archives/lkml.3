Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab3G2PR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:17:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:47467 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3G2PR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:17:56 -0400
Date: Mon, 29 Jul 2013 17:17:54 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: George Cherian <george.cherian@ti.com>
Cc: linux-usb@vger.kernel.org, balbi@ti.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH v2 2/4] phy: phy-amxxxx-usb: Add PHY driver for amxxxx
 platform
Message-ID: <20130729151754.GB827@linutronix.de>
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
 <1374237277-17769-3-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1374237277-17769-3-git-send-email-george.cherian@ti.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* George Cherian | 2013-07-19 18:04:35 [+0530]:

>Adds phy driver support for am33xx platform, the host/device
>peripheral controller shall get this phy object to control the phy
>operations.

If you rebase this on-top of the two instances patches I've sent earlier
then you can bury patch 3 and 4, right?

I don't like very much the way you obtain the phy id:
>+		of_property_read_u32(np, "id", &phy->id);

with the .dts changes I made you should able to use
    of_alias_get_id()
instead.

Let me look what you have additionaly:
- usbotg_fck
  Is this really required? I have the phy as a child of the "main"
  device which has a hwmod property which is associated with this clock.
  So pm enable/ disable should also enable this clock if possible,
  right? 

- device wakeup via omap_control_am335x_phy_wkup()
  Now. that is one thing that the simple phy driver is missing. If you
  call a magic function for this to happen than I don't have to worry
  about the missing memory space for this function.

So from what I see now, it is most likely the easiest thing to just add
that wakeup to the phy driver I posted. Do you agree?
If so we need to figure out where the memory for the wakeup register is
comming from. We need also to ensure that both phys can not write at the
same time. A look would be nice.

>Signed-off-by: George Cherian <george.cherian@ti.com>

Sebastian
