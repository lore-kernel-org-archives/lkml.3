Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaGLLKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 07:10:17 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:36027 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752025AbaGLLKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 07:10:13 -0400
Date: Sat, 12 Jul 2014 12:10:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, patches@linaro.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 0/4] arm: Fix DEBUG_LL for multi-platform kernels
	(without PL01X)
Message-ID: <20140712111004.GI21766@n2100.arm.linux.org.uk>
References: <1401206421-29832-1-git-send-email-daniel.thompson@linaro.org> <1404127855-30459-1-git-send-email-daniel.thompson@linaro.org> <20140712101602.GH21766@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140712101602.GH21766@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 11:16:02AM +0100, Russell King - ARM Linux wrote:
> On Mon, Jun 30, 2014 at 12:30:51PM +0100, Daniel Thompson wrote:
> > This patchset removes some single-platform compatibility tricks related
> > to DEBUG_LL and, as a result, allows multi_v7_defconfig derived builds
> > to enable DEBUG_LL. Currently the user selected kbuild setting is
> > ignored and the PL01X's DEBUG_LL stub is silently selected instead. This
> > is a pain if your hardware doesn't have this cell, not least because it
> > takes a little time to figure out that kbuild built the wrong code.
> 
> I don't think this is quite right, because I'm now seeing randconfig
> finding build errors with this.  We can end up with this configuration:
> 
> CONFIG_DEBUG_LL=y
> CONFIG_DEBUG_LL_UART_NONE=y
> # CONFIG_DEBUG_ICEDCC is not set
> # CONFIG_DEBUG_SEMIHOSTING is not set
> # CONFIG_DEBUG_LL_UART_8250 is not set
> # CONFIG_DEBUG_LL_UART_PL01X is not set
> CONFIG_DEBUG_LL_INCLUDE="mach/debug-macro.S"
> # CONFIG_DEBUG_UART_8250 is not set
> 
> which results in:
> 
> arch/arm/kernel/debug.S:24:33: fatal error: mach/debug-macro.S: No such file or directory
> make[2]: *** [arch/arm/kernel/debug.o] Error 1
> arch/arm/kernel/head.S:27:33: fatal error: mach/debug-macro.S: No such file or directory
> make[2]: *** [arch/arm/kernel/head.o] Error 1
> 
> Full config file:
> http://www.arm.linux.org.uk/developer/build/file.php?lid=11023

Note that this also breaks building versatile as an oldconfig.  I'll drop
the patch series from my tree for the time being.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
