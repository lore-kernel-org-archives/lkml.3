Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaLERTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:19:00 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:52409 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaLERS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:18:58 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RFC 1/2] i2c: omap: fix buffer overruns during RX/TX data processing
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141204180946.GG2817@atomide.com>
Date: Fri, 5 Dec 2014 20:18:53 +0300
Cc: Kevin Hilman <khilman@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <46D905A0-2E71-4490-84BD-4D2467E13899@gmail.com>
References: <1417294803-14729-1-git-send-email-al.kochet@gmail.com> <1417294803-14729-2-git-send-email-al.kochet@gmail.com> <20141201195841.GD2817@atomide.com> <B3F4FEFF-2333-473D-8A35-7D4EF1C44D90@gmail.com> <20141204180946.GG2817@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tony!

> The issue I'm seeing on 2430sdp is some earlier regression that
> has started happening over the past year or so. 

I don't have 2430sdp. And I couldn't  find 2430sdp schematics.
Looks, like this is NDA stuff.

> Of course the issue I'm seeing could be caused by hung twl4030
> PMIC too.

This could be switching twl4030 into inappropriate for 2430sdp mode.

For example, SMARTREFLEX_ENABLE bit is dangerous, because
it switch twl-pads from VMODE to i2c.
And when you set SMARTREFLEX_ENABLE, twl automatically drop
VDD1 and VDD2 to 1.2V (if VDD1_SR_CONTROL was not initialized through
BYPASS register early in the boot loader).

What mode is used in the 2430sdp? VMODE or Smartreflex?

And, that is my assumption, may be it wrong again.

I'd added trace in the twl_i2c_read_u8/twl_i2c_write_u8 functions to
easy find concrete line of code, what cause problem (by register address).

Hang happens on access to 0x004b address group.
That could be: BACKUP_REG, INT, PM_MASTER, PM_RECEIVER, RTC or
SECURED_REG. It hard to tell which one cause hang without trace.

Hope this helps.

Regards,
Alexander.

