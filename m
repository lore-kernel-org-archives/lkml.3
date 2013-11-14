Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab3KNPGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:06:41 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45410 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab3KNPGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:06:35 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [RFC 0/4] Add basic support for ASV
Date: Thu, 14 Nov 2013 16:06:33 +0100
Message-ID: <1906951.EFsdgbeaob@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAKew6eUK9ZtoVgVu_b13Bn20iMNWzHnWjSHMjxD1Y+zDtvoCWw@mail.gmail.com>
References: <1378898048-25205-1-git-send-email-yadi.brar@samsung.com> <CAKew6eUK9ZtoVgVu_b13Bn20iMNWzHnWjSHMjxD1Y+zDtvoCWw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yadwinder,

On Monday 11 of November 2013 23:27:08 Yadwinder Singh Brar wrote:
> gentle ping for suggestions/reviews ..

Hmm, I must have somehow missed this series when you orignally sent it.
Can I ask you to resend it, as I don't have it in my e-mail client archive
any longer?

While at it, I would also ask you to add my private e-mail address 
(this one) and linux-pm mailing list to Cc list.

Thanks in advance.

Best regards,
Tomasz

> 
> 
> On Wed, Sep 11, 2013 at 8:14 PM, Yadwinder Singh Brar
> <yadi.brar@samsung.com> wrote:
> > This series is to add basic common infrastructure for ASV.
> >  Basically ASV is a technique used on samsung SoCs, which provides the
> > recommended supply voltage for dvfs of arm, mif etc. For a given operating
> > frequency, the voltage is recommended based on SoC's ASV group.
> > ASV group gets fussed on SoCs during process of mass production.
> >
> > This series includes:
> >  - basic common infrastructue for ASV. It provides common APIs for user drivers
> > like cpufreq & devfreq and and an interface for SoC specific drivers to
> > register ASV members(instances)
> >  - a common platform driver to register ASV members for exynos SoCs
> >  - an example providing minimal support (only for ARM ASV) for exynos5250 chips
> >
> > Its just basic skelton which I wanted to get it reviewed or discussed in
> > early stage, before going ahead on further development based on it.
> >  Presently example is based on static ASV table provided in SoC specific file,
> > which I expects to go into DT. But exactly how and where needs to be discussed,
> > may be in next revisions once we get through the basic skelton.
> >  Also the location of driver in kernel may also seem odd to someone and
> > many more things :).
> >
> > Looking for your valuable reviews and suggestions.
> >
> > Thanks
> >
> > Yadwinder Singh Brar (4):
> >   power: asv: Add common ASV support for samsung SoCs
> >   power: asv: Add a common asv driver for exynos SoCs.
> >   power: asv: Add support for exynos5250
> >   arm: exynos5: Register static platform device for ASV.
> >
> >  arch/arm/mach-exynos/mach-exynos5-dt.c   |    3 +
> >  drivers/power/Kconfig                    |    1 +
> >  drivers/power/Makefile                   |    1 +
> >  drivers/power/asv/Kconfig                |   24 ++++
> >  drivers/power/asv/Makefile               |    2 +
> >  drivers/power/asv/exynos-asv.c           |   81 ++++++++++++++
> >  drivers/power/asv/exynos-asv.h           |   22 ++++
> >  drivers/power/asv/exynos5250-asv.c       |  141 ++++++++++++++++++++++++
> >  drivers/power/asv/samsung-asv.c          |  175 ++++++++++++++++++++++++++++++
> >  include/linux/power/samsung-asv-driver.h |   61 +++++++++++
> >  include/linux/power/samsung-asv.h        |   37 +++++++
> >  11 files changed, 548 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/power/asv/Kconfig
> >  create mode 100644 drivers/power/asv/Makefile
> >  create mode 100644 drivers/power/asv/exynos-asv.c
> >  create mode 100644 drivers/power/asv/exynos-asv.h
> >  create mode 100644 drivers/power/asv/exynos5250-asv.c
> >  create mode 100644 drivers/power/asv/samsung-asv.c
> >  create mode 100644 include/linux/power/samsung-asv-driver.h
> >  create mode 100644 include/linux/power/samsung-asv.h
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

