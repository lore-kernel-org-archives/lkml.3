Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaJ1Ob3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:31:29 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47286 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752087AbaJ1Ob2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:31:28 -0400
Date: Tue, 28 Oct 2014 14:31:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Xia Kaixu <kaixu.xia@linaro.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/5] ARM: allow errata and XIP options to be enabled
 without ARCH_MULTIPLATFORM_STRICT
Message-ID: <20141028143118.GH27405@n2100.arm.linux.org.uk>
References: <1414503095-25986-1-git-send-email-kaixu.xia@linaro.org>
 <1414503095-25986-5-git-send-email-kaixu.xia@linaro.org>
 <20141028140231.GE27405@n2100.arm.linux.org.uk>
 <6893071.4YhqEbdaBz@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6893071.4YhqEbdaBz@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 03:24:38PM +0100, Arnd Bergmann wrote:
> On Tuesday 28 October 2014 14:02:31 Russell King - ARM Linux wrote:
> > On Tue, Oct 28, 2014 at 09:31:34PM +0800, Xia Kaixu wrote:
> > > With the ARCH_MULTIPLATFORM_STRICT option, it becomes much easier to
> > > enable the ERRATA options when we know at configuration time that we
> > > don't care about the generic case. The previous configuration makes
> > > XIP_KERNEL option fundamentally non-MULTIPLATFORM, but it's still
> > > valid to select it when building for !ARCH_MULTIPLATFORM_STRICT and
> > > selecting only the one machine that you want to run on.
> > 
> > XIP_KERNEL isn't supported on anything past ARMv5 though.
> 
> I would really like to get some of the platforms that currently use
> XIP_KERNEL to use ARCH_MULTIPLATFORM in the long run. One of them
> is EFM32, which is ARMv7-M.

Right, and on ARMv7-M, the restrictions against XIP_KERNEL don't apply.
The restrictions on XIP_KERNEL only apply with MMU-full kernels, because
of the remapping needed - the kernel is executed from flash, which is
mapped separately, and that mapping needs to be setup in order to turn
the MMU on.

With ARMv7-M, there is no MMU to worry about, no other mappings are
required, so there is no special platform specific setup applicable.

So, I don't see any reason why XIP_KERNEL can't depend on
!ARCH_MULTIPLATFORM || CPU_V7M.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
