Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab3EGNhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:37:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13229 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab3EGNhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:37:04 -0400
X-AuditID: cbfee61a-b7fd56d0000022fd-dc-5189037e8deb
From: Tomasz Figa <t.figa@samsung.com>
To: amit daniel kachhap <amit.daniel@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH V2 01/20] thermal: exynos: Moving exynos thermal files into
 samsung directory
Date: Tue, 07 May 2013 15:36:50 +0200
Message-id: <16696787.3vbuFaRQiY@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.2 (Linux/3.8.3-gentoo-r1; KDE/4.10.2; x86_64; ; )
In-reply-to: <CADGdYn5YE6KPgrJYLjh+ctgfQDboajaLWXO6qXZHJtgxXseFtg@mail.gmail.com>
References: <1366972671-9227-1-git-send-email-amit.daniel@samsung.com>
 <1927845.etOFu5Zfbm@amdc1227>
 <CADGdYn5YE6KPgrJYLjh+ctgfQDboajaLWXO6qXZHJtgxXseFtg@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jQd065s5Ag6sXjSwaroZYrNn/k8mi
	d8FVNovLu+awWXzuPcJoMeP8PiaLJw/72BzYPRbvecnk0bdlFaPH8RvbmTw+b5ILYInisklJ
	zcksSy3St0vgyvhx/xh7wTSZio4v79gbGDeJdjFyckgImEh837ebDcIWk7hwbz2QzcUhJDCd
	UWLPhEYop4VJYv2xhewgVWwCahKfGx4BJTg4RAQMJWZ9FwepYRa4xCgx8+pZRpAaYYFkiR0P
	V4FNZRFQlbja9JIVxOYV0JK4s3YhWA2/gLrEu21PmUDmiAp4SNy7yQQS5hQIllh46ws7xN61
	jBKbj8+B6hWU+DH5HguIzSwgL7Fv/1RWCFtLYv3O40wTGAVnISmbhaRsFpKyBYzMqxhFUwuS
	C4qT0nMN9YoTc4tL89L1kvNzNzGCQ/6Z1A7GlQ0WhxgFOBiVeHgVTrUHCrEmlhVX5h5ilOBg
	VhLhnfalI1CINyWxsiq1KD++qDQntfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QD
	o9pzy8Jv9uvZ3eOC05mefivfa7lb/5fitCkT8+9tOL1uxnPGW09eOWXfPr/Thk+ruoVjp7Dw
	wQ9Pgv8vWLb11vs5FV87jpd23omvez13n0HTiZZNrX+FXKcrVrz9I/bxrvneW6+c3s//+OZw
	bH19UWnYzILwuqTcy/+fbJm3clq+TbuZSKi1v5ISS3FGoqEWc1FxIgAtKDj9dQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 of May 2013 18:48:46 amit daniel kachhap wrote:
> Hi Tomasz Figa,
> 
> On Tue, May 7, 2013 at 3:51 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> > On Monday 06 of May 2013 23:05:06 Zhang Rui wrote:
> >> On Fri, 2013-04-26 at 16:07 +0530, Amit Daniel Kachhap wrote:
> >> > This movement of files is done for easy maintenance and adding more
> >> > new sensor's support for exynos platform easily . This will also help
> >> > in
> >> > bifurcating exynos common, sensor driver and sensor data related parts.
> >> > 
> >> > Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> >> > Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> >> > ---
> >> > 
> >> >  drivers/thermal/Kconfig                        |   13 +++++--------
> >> >  drivers/thermal/Makefile                       |    2 +-
> >> >  drivers/thermal/samsung/Kconfig                |    9 +++++++++
> >> >  drivers/thermal/samsung/Makefile               |    4 ++++
> >> >  drivers/thermal/{ => samsung}/exynos_thermal.c |    0
> >> >  5 files changed, 19 insertions(+), 9 deletions(-)
> >> >  create mode 100644 drivers/thermal/samsung/Kconfig
> >> >  create mode 100644 drivers/thermal/samsung/Makefile
> >> >  rename drivers/thermal/{ => samsung}/exynos_thermal.c (100%)
> >> > 
> >> > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> >> > index 5e3c025..081ddc5 100644
> >> > --- a/drivers/thermal/Kconfig
> >> > +++ b/drivers/thermal/Kconfig
> >> > @@ -114,14 +114,6 @@ config KIRKWOOD_THERMAL
> >> > 
> >> >       Support for the Kirkwood thermal sensor driver into the Linux
> >> >       thermal
> >> >       framework. Only kirkwood 88F6282 and 88F6283 have this sensor.
> >> > 
> >> > -config EXYNOS_THERMAL
> >> > -   tristate "Temperature sensor on Samsung EXYNOS"
> >> > -   depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5)
> >> > -   depends on CPU_THERMAL
> >> > -   help
> >> > -     If you say yes here you get support for TMU (Thermal Management
> >> > -     Unit) on SAMSUNG EXYNOS series of SoC.
> >> > -
> >> > 
> >> >  config DOVE_THERMAL
> >> >  
> >> >     tristate "Temperature sensor on Marvell Dove SoCs"
> >> >     depends on ARCH_DOVE
> >> > 
> >> > @@ -169,4 +161,9 @@ config INTEL_POWERCLAMP
> >> > 
> >> >       enforce idle time which results in more package C-state
> >> >       residency. The
> >> >       user interface is exposed via generic thermal framework.
> >> > 
> >> > +menu "Exynos thermal drivers"
> >> 
> >> would it be more proper to use "Samsung thermal drivers" or "Samsung
> >> Exynos thermal drivers" instead?
> > 
> > +1
> > 
> > Still, I wonder if it really makes sense to create a separate directory
> > and
> > submenu for this.
> 
> Yes separate directory was needed as the current TMU drivers supports
> many exynos SOC's with some differences in the controller itself. This
> has made it unmanageable and unclean and configuration data need to be
> separated from driver. With all these re-structuring, tmu support for
> exynos5440 is added very cleanly. Also many changes in this patchset
> are for making the driver multi-stance which is needed for 5440.

I fully understand the need to restructure this driver. I'm just thinking if 
there is really a reason to have a separate directory with its own Makefile and 
Kconfig just for six source files, which could be placed in drivers/thermal/ 
directly as well. I guess it's just a matter of preference, though.

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Kernel and System Framework

