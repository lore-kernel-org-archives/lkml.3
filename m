Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab3H2SEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:04:06 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40965 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab3H2SEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:04:05 -0400
Date: Thu, 29 Aug 2013 10:57:15 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sahara <keun-o.park@windriver.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the pm tree
Message-ID: <20130829175715.GH18542@quad.lixom.net>
References: <20130829180425.4aa3d164f01cc65b215187fe@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130829180425.4aa3d164f01cc65b215187fe@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 06:04:25PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/cpuidle/Makefile between commits b98e01ad4ed9 ("cpuidle: Add
> Kconfig.arm and move calxeda, kirkwood and zynq") and d3f2950f2ade ("ARM:
> ux500: cpuidle: Move ux500 cpuidle driver to drivers/cpuidle") from the
> pm tree and commit 14d2c34cfa00 ("cpuidle: big.LITTLE: vexpress-TC2 CPU
> idle driver") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/cpuidle/Makefile
> index 0b9d200,3b6445c..0000000
> --- a/drivers/cpuidle/Makefile
> +++ b/drivers/cpuidle/Makefile
> @@@ -5,9 -5,7 +5,10 @@@
>   obj-y += cpuidle.o driver.o governor.o sysfs.o governors/
>   obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
>   
>  -obj-$(CONFIG_CPU_IDLE_CALXEDA) += cpuidle-calxeda.o
>  -obj-$(CONFIG_ARCH_KIRKWOOD) += cpuidle-kirkwood.o
>  -obj-$(CONFIG_CPU_IDLE_ZYNQ) += cpuidle-zynq.o
>  -obj-$(CONFIG_CPU_IDLE_BIG_LITTLE) += cpuidle-big_little.o
>  +##################################################################################
>  +# ARM SoC drivers
>  +obj-$(CONFIG_ARM_HIGHBANK_CPUIDLE)	+= cpuidle-calxeda.o
>  +obj-$(CONFIG_ARM_KIRKWOOD_CPUIDLE)	+= cpuidle-kirkwood.o
>  +obj-$(CONFIG_ARM_ZYNQ_CPUIDLE)		+= cpuidle-zynq.o
>  +obj-$(CONFIG_ARM_U8500_CPUIDLE)         += cpuidle-ux500.o
> ++obj-$(CONFIG_CPU_IDLE_BIG_LITTLE)       += cpuidle-big_little.o


Might want to sort u8500 before zynq, but otherwise looks fine.


-Olof

