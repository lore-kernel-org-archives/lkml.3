Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbaIDUdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:33:12 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53645 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311AbaIDUdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:33:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Xia Kaixu <kaixu.xia@linaro.org>
Subject: Re: [PATCH] ARM: cns3xxx: fix allmodconfig panic in pci driver
Date: Thu, 4 Sep 2014 22:32:23 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Felix Fietkau <nbd@openwrt.org>, Imre Kaloz <kaloz@openwrt.org>,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org
References: <kaixu.xia@linaro.org> <1409750292-24105-1-git-send-email-kaixu.xia@linaro.org>
In-Reply-To: <1409750292-24105-1-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201409042232.23827.arnd@arndb.de>
X-Provags-ID: V02:K0:hLqDAORYpUuqWfG9UGwN26C9zrodiHTx8ob4VLbxf4l
 LcFuCcE9ZPubTWPdOdWVZK95sYI2MnFwNB8NNuMr4gMU9VxaiU
 zItmkPy2E+xrtCwIqWRq6awUw8q6ZkinbE5sMGR0EuN/Jbgpkq
 +kB7NOovJETyWSWQRoXJngxjLQAd82VLtzvGutEYJQmxSfOhia
 w4XFczcVrxDGldgAtk9sfKuLEujFPsX8jHaC2xv9FVE1hz3JfM
 +gL1Q78fr9SmotKCrGx95OXeRCWcpSi5PZit8YorW3rY7Nck5Q
 cvNpzg2HrG5rEUScgE7dE3X66m9XkEe9TvnSVbFq/stA4aJpFW
 CpW6JzIRAIb+IQF0phG0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2014, Xia Kaixu wrote:
> From: Xia Kaixu <kaixu.xia@linaro.org>
> 
> The kernel panic occurs when running an allmodconfig kernel on 
> OMAP4460. The inicall "cns3xxx_pcie_init" does not check which
> hardware it's running on and just tries to access to its specific 
> registers. Now call it from .init_late callback from the two
> machine descriptors.
> 
> Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Anton Vorontsov <anton@enomsg.org>
> Cc: Felix Fietkau <nbd@openwrt.org>
> Cc: Imre Kaloz <kaloz@openwrt.org>
> Cc: linaro-kernel@lists.linaro.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm/mach-cns3xxx/cns3420vb.c | 1 +
>  arch/arm/mach-cns3xxx/core.c      | 1 +
>  arch/arm/mach-cns3xxx/core.h      | 9 +++++++++
>  arch/arm/mach-cns3xxx/pcie.c      | 3 +--
>  4 files changed, 12 insertions(+), 2 deletions(-)

I've applied this to next/fixes-non-critical now. I'm fairly confident
that this helps more than it can hurt, but not confident enough
to put it into 3.17 or stable for now.

It would be nice to get some testing from someone with
hardware access. If necessary, I'll revert the change or
do a fixup on top.

	Arnd
