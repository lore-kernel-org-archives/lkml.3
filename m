Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935829Ab3DHTlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:41:52 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54410 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935796Ab3DHTlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:41:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'amit daniel kachhap'" <amit.daniel@samsung.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        cpufreq@vger.kernel.org,
        "'Inderpal Singh'" <inderpal.singh@linaro.org>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Subject: Re: [PATCH V5 0/4] cpufreq: exynos5440: support for cpufreq driver
Date: Mon, 08 Apr 2013 21:49:33 +0200
Message-ID: <1403255.89Vcuzrghk@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2d0501ce3450$fac4e9c0$f04ebd40$%kim@samsung.com>
References: <1364457923-8499-1-git-send-email-amit.daniel@samsung.com> <CADGdYn7ZRCSymU7k3Sn4mbS6B=dxy1N+vhQuyiFnhOQLLzrTbw@mail.gmail.com> <2d0501ce3450$fac4e9c0$f04ebd40$%kim@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 08, 2013 09:02:44 PM Kukjin Kim wrote:
> amit daniel kachhap wrote:
> > 
> > On Fri, Apr 5, 2013 at 6:08 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Thursday, March 28, 2013 01:35:18 PM Amit Daniel Kachhap wrote:
> > >> Submitting the V5 version of exynos5440 cpufreq driver. This patchset
> > addresses
> > >> all the coding and design concerns raised especially by Viresh.
> > >>
> > >> Changes in V5:
> > >> * Removed the unnecessary DT look up entry from mach-exynos5-dt.c.
> > >> * Fixed all coding and comments issue raised by Viresh.
> > >>
> > >> Changes in V4:
> > >> * Added dev_err logs instead of pr_err.
> > >> * Used the devm_ioremap_resource API.
> > >> * Implemented several coding guidelines and minor error comments from
> > Sylwester,
> > >>   Russell and Viresh.
> > >>
> > >> Changes in V3:
> > >> * Converted the driver to probe based as suggested by Viresh. This is
> > also
> > >>   beneficial for multiplatform kernel.
> > >> * Other coding guidelines related changes.
> > >> * Moved the DT node outside cpu0 node as the driver is now a platform
> > >>   driver.
> > >>
> > >> Changes in V2:
> > >> * Added OPP library support to parse DT parameters.
> > >> * Removed a hack to handle interrupts in bootup.
> > >> * Implemented other review comments from Viresh and Inder.
> > >>
> > >> All these patches are dependent on Thomas Abraham common clock patches.
> > >> (http://www.mail-archive.com/linux-samsung-
> > soc@vger.kernel.org/msg15860.html)
> > >> This whole patch series is based on 3.9-rc4.
> > >>
> > >> Amit Daniel Kachhap (4):
> > >>   cpufreq: exynos: Add cpufreq driver for exynos5440
> > >>   cpufreq: exynos: Remove error return even if no soc is found
> > >>   arm: exynos: Enable OPP library support for exynos5440
> > >>   arm: dts: Add cpufreq controller node for Exynos5440 SoC
> > >>
> > >>  .../bindings/cpufreq/cpufreq-exynos5440.txt        |   28 ++
> > >>  arch/arm/boot/dts/exynos5440.dtsi                  |   12 +
> > >>  arch/arm/mach-exynos/Kconfig                       |    2 +
> > >>  drivers/cpufreq/Kconfig.arm                        |    9 +
> > >>  drivers/cpufreq/Makefile                           |    1 +
> > >>  drivers/cpufreq/exynos-cpufreq.c                   |    2 +-
> > >>  drivers/cpufreq/exynos5440-cpufreq.c               |  474
> > ++++++++++++++++++++
> > >>  7 files changed, 527 insertions(+), 1 deletions(-)
> > >>  create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-
> > exynos5440.txt
> > >>  create mode 100644 drivers/cpufreq/exynos5440-cpufreq.c
> > >
> > > Is this for me or the Samsung tree?
> > >
> > > If it's for me, I need ACKs from the Samsung tree maintainers.  Also,
> > please
> > > address the Viresh's comments.
> > >
> > > Thanks,
> > > Rafael
> > >
> > Hi Rafael,
> > 
> > I submitted the V6 version with all comments from Viresh addressed.
> > 
> > Hi Kukjin Kim,
> > 
> > Any suggestion on how this patch should be merged. In my opinion it
> > should go via Rafael's tree as this patch uses some fixes present in
> > Rafael's tree like modified cpufreq_notify_transition API.
> > 
> Yes, I agree. The v6 series including resending 1/4 patch looks good to me.
> But the patch V6 4/4 would be sent to upstream via samsung tree to avoid
> useless merge conflicts and I think, it's possible.
> 
> So Rafael, please take 1/4 ~ 3/4 patches in your tree with my ack.
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> 
> If any problems, please let me know.

I will, thank you!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
