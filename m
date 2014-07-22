Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbaGVVUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:20:47 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:48855 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754861AbaGVVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:20:46 -0400
Date: Tue, 22 Jul 2014 22:20:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Bastian Hecht <hechtb@gmail.com>, linux-i2c@vger.kernel.org,
        "Menon, Nishanth" <nm@ti.com>, Linux-SH <linux-sh@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/5] i2c: Don't start transfers when suspended
Message-ID: <20140722212036.GL21766@n2100.arm.linux.org.uk>
References: <1405608520-5644-1-git-send-email-hechtb@gmail.com> <53CEB196.9060903@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CEB196.9060903@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 09:46:46PM +0300, Grygorii Strashko wrote:
>  I'm not sure, this optimization is safe  (
> Because, in many cases the access to PMIC IC needs to be allowed till late
> stages of suspending (at least till suspend_noirq stage or even later).
> For example, on some OMAP SoC Voltage management code need to use services
> provided by PMIC IC, which is connected to I2C.

This is definitely not safe.  I worked on a PXA platform a while back
where the only way to tell the thing to "sleep" was to send an I2C
message to a microcontroller asking it to remove power.

Plus, as you say, you may also have PMICs that you need to talk to
in order to shut power off to various peripherals (and maybe even
the CPU itself) during the suspend process.

I2C is one of those cases where devices attached to the I2C bus are
themselves responsible for doing their own suspend shutdown at the
appropriate time; it's not the responsibility of the I2C core to
know this kind of system/driver dependent detail.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
