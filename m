Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaGaRhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:37:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8862 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaGaRhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:37:12 -0400
X-AuditID: cbfee61a-f79e46d00000134f-d0-53da7ec6a805
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: amit daniel kachhap <amit.daniel@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/9] thermal: exynos: various cleanups
Date: Thu, 31 Jul 2014 19:37:08 +0200
Message-id: <5064578.QsHz5kKYq8@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140729125848.GA18746@developer>
References: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
 <CADGdYn6EN-evo2KCjFfQ2h8gLoop=xTJZO3fnNxBxM9067tjxg@mail.gmail.com>
 <20140729125848.GA18746@developer>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jQd1jdbeCDbpPC1s0XA2xWLP/J5PF
	/CvXWC3ONr1ht7i8aw6bxefeI4wWM87vY7I4c/oSq8WTh31sFutnvGZx4PLYOesuu8fiPS+Z
	PLZcbWfx6NuyitHj+I3tTB6fN8kFsEVx2aSk5mSWpRbp2yVwZWyedp+lYKlyxZu/1xkbGK9L
	dzFyckgImEi83vSfEcIWk7hwbz1bFyMXh5DAdEaJfW82MUI4LUwS//8/AqtiE7CSmNi+CswW
	EdCSOHFpOxNIEbPAfmaJyY/ngSWEBWwlju44xA5iswioSmx/Op+1i5GDg1dAU+JxrylIWFTA
	U2LH9pVsIDangL7Ei/13WSGWbWGUWDtpDhNIgldAUOLH5HssIDazgLzEvv1TWSFsLYn1O48z
	TWAUmIWkbBaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI6HZ1I7GFc2WBxi
	FOBgVOLhnRF+K1iINbGsuDL3EKMEB7OSCK9LOVCINyWxsiq1KD++qDQntfgQozQHi5I474FW
	60AhgfTEktTs1NSC1CKYLBMHp1QDo8Qj61VMtlYCGa1NVW+djn5aofGW49u0vM2JzPqLfr2S
	dDt2a+ma9QqyFbejbW2cr3revPmZ8bmtdZFTzMOwMH6xr20HeztWlnwrnV3HyXig8vX01k+F
	6Wc+P1mer8SavS9dVjg0qunXqsIzRfMcRXYEcQX1z0o25J3B4F8318pf7OuJ5bM6lViKMxIN
	tZiLihMB7MUiH4MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, July 29, 2014 08:58:48 AM Eduardo Valentin wrote:
> On Mon, Jul 28, 2014 at 08:30:53PM +0530, amit daniel kachhap wrote:
> > Hi Eduardo,
> 
> Hello Amit,
> 
> > 
> > Please reject this entire series as this is not re-based recently.
> > Actually two point trimming which this series seeks to remove is used
> > by exynos3250 and is in Rui's tree
> > (https://git.kernel.org/cgit/linux/kernel/git/rzhang/linux.git/commit/?h=next&id=1fe56dc16a3dab400206443f70ae158c8f595c42).
> > 
> 
> Yeah, that was my original concern when I first looked this series.
> However, as I saw a couple of your acks I thought you would be in sync
> with Bartlomiej. 
> 
> I agree with Bartlomiej that we need to keep the kernel code in very
> good shape, but if we are removing features for the sake of reducing
> LOCs and we end up dropping support to known chips, I definitely won't
> agree. 

There is no intention to drop support for known chips.  Two months after
initial posting of my patchset support for the new Exynos3250 SoC was
posted and it happens to use the two point trimming calibration code (that
was introduced back in September 2011 but never used previously).  If we
had removed it earlier it would have to be readded partially but we are
talking about less than 100 lines of rather straightforward code (also
the calibration code in question is not perfect anyway and would profit
from some cleaning but I left it as it is for now).

> Can you guys please reach a common agreement on these cleanups?
> 
> Bartlomiej, best thing to do is to sync your work on top of Rui's tree.

Done, I posted v3 of patchset today:

  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35013.html

I hope that it is acceptable for Amit now (Amit, please take a look at
patches when you find some time, thanks!).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> For now I am dropping this series from my -next branch. :-(
> 
> > Thanks,
> > Amit D
> > 
> > 
> > On Mon, Jul 28, 2014 at 8:07 PM, Eduardo Valentin <edubezval@gmail.com> wrote:
> > > On Tue, Jun 17, 2014 at 07:27:16PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > >> Hi,
> > >>
> > >> This patch series contains various cleanups for EXYNOS thermal
> > >> driver.  Overall it decreases driver's LOC by 12%.  It is based
> > >> on next-20140617 kernel.  It should not cause any functionality
> > >> changes.
> > >>
> > >> Changes since v1:
> > >> - synced patches against next-20140617
> > >> - merged patch "thermal: exynos: remove unused defines" into
> > >>   "thermal: exynos: remove unused struct exynos_tmu_registers
> > >>   entries" one (per request from Eduardo)
> > >> - improved patch descriptions for patches #1-5
> > >> - fixed documentation for pdata->gain and pdata->reference_voltage
> > >> - added Reviewed-by from Amit to patches #6, #7 and #10
> > >> - added missing Acked-by from Kyungmin Park
> > >
> > > Pulled the series.
> > >
> > > Thanks.
> > >
> > >>
> > >> Best regards,
> > >> --
> > >> Bartlomiej Zolnierkiewicz
> > >> Samsung R&D Institute Poland
> > >> Samsung Electronics
> > >>
> > >>
> > >> Bartlomiej Zolnierkiewicz (9):
> > >>   thermal: exynos: remove unused struct exynos_tmu_registers entries
> > >>   thermal: exynos: remove dead code for HW_MODE calibration
> > >>   thermal: exynos: remove dead code for TYPE_TWO_POINT_TRIMMING
> > >>     calibration
> > >>   thermal: exynos: remove redundant pdata checks from
> > >>     exynos_tmu_initialize()
> > >>   thermal: exynos: remove redundant threshold_code checks from
> > >>     exynos_tmu_initialize()
> > >>   thermal: exynos: simplify temp_to_code() and code_to_temp()
> > >>   thermal: exynos: cache non_hw_trigger_levels in pdata
> > >>   thermal: exynos: remove redundant pdata checks from
> > >>     exynos_tmu_control()
> > >>   thermal: exynos: remove identical values from exynos*_tmu_registers
> > >>     structures
> > >>
> > >>  drivers/thermal/samsung/exynos_thermal_common.h |   1 -
> > >>  drivers/thermal/samsung/exynos_tmu.c            | 181 ++++--------------------
> > >>  drivers/thermal/samsung/exynos_tmu.h            |  90 +-----------
> > >>  drivers/thermal/samsung/exynos_tmu_data.c       |  64 +--------
> > >>  drivers/thermal/samsung/exynos_tmu_data.h       |  33 +----
> > >>  5 files changed, 41 insertions(+), 328 deletions(-)
> > >>
> > >> --
> > >> 1.8.2.3

