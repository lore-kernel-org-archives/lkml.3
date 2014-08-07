Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbaHGRSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 13:18:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47496 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264AbaHGRSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 13:18:48 -0400
X-AuditID: cbfee61a-f79e46d00000134f-6c-53e3b4f61688
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v5 0/5] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with
 secure firmware enabled
Date: Thu, 07 Aug 2014 19:18:43 +0200
Message-id: <25593716.2VrAenu32Y@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <53E0E13E.3@linaro.org>
References: <1407245666-20016-1-git-send-email-b.zolnierkie@samsung.com>
 <53E0E13E.3@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=UTF-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t9jQd1vWx4HG5xs5beY91nWonfBVTaL
	s01v2C3eH3rGbLHp8TVWi8u75rBZfO49wmgx4/w+Joszpy+xWpz808tosX7GaxaLjV89HHg8
	7lzbw+axeUm9x+1/j5k9tlxtZ/Ho27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujIkL5rIVfNCo
	WNf2gr2BsV2xi5GTQ0LARGJ1SysrhC0mceHeerYuRi4OIYHpjBIr3+5ihnBamCR+7VnDCFLF
	JmAlMbF9FZgtIqAn0fi+jQnEZhaYySxx/5cIiC0skCHx6N8FFhCbRUBVYvum72A1vAJaEgvW
	XAOLiwp4SuzYvpINxOYUUJE4fqkBLC4kkCRx/8cCZoh6QYkfk++xQMyXl9i3fyorhK0uMWne
	IuYJjAKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB0fFMagfjygaL
	Q4wCHIxKPLwC3Y+DhVgTy4orcw8xSnAwK4nw6oKEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5o
	tQ4UEkhPLEnNTk0tSC2CyTJxcEo1MO7O023qjvsoYND1ru/z+itFXEohIqW6/lUbzRccb18q
	Mt/gfT5b5v45bnPO7nh8Usua892TyE+OzszvZ7I8K/k0dXm5Q4W/j+i2sBcbZpU8rXqZrqD0
	RUz46ryOvgubub6Va6XJvwxqnWWfL++qOflEleYS6blLd9y6FqP1ypw//btt5Km5vUosxRmJ
	hlrMRcWJAHu43U2KAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday, August 05, 2014 03:50:54 PM Daniel Lezcano wrote:
> On 08/05/2014 03:34 PM, Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> >
> > This patch series adds support for AFTR idle mode on boards with
> > secure firmware enabled and allows EXYNOS cpuidle driver usage on
> > Exynos4x12 SoCs.
> >
> > It has been tested on Trats2 board (using Exynos4412 SoC with secure
> > firmware enabled) on which AFTR mode reduces power consumption by ~12%
> > when EXYNOS cpuidle driver is enabled (in both cases the default
> > exynos_defconfig config is used and CPU1-3 are offlined).
> 
> Hi Bartlomiej,

Hi Daniel,

> I tested your patchset on an odroid-u2. When the cpuidle driver is 
> enabled and the cpu1-3 are offlined, the kernel hangs.
> 
> If I disable the AFTR state on cpuidle, and offline the 1-3, it works as 
> expected. So there is something wrong with the AFTR on the odroid board.

Thanks for testing.  I reproduced the problem on ODROID-U3 board.  I also
tested Exynos4412 based Origen board and it also has problem with AFTR mode.
We did some debugging but nothing specific has came up yet (we suspect that
the issue may be caused by incompatibilities of bootloader firmware of
ODROID-U2/U3 and Origen4412 boards).  We will keep investigating this but
in the meantime I would like to have this patchset acked/merged if possible
(with Exynos4412 support limited to Trats2 target currently [*]) as:

- it contains mostly fundamental changes for all secure firmware enabled
  boards (which would be needed also on ODROID/Origen4412 boards if we get
  AFTR mode working on them)

- it adds working AFTR mode support for Exynos4412 Trats2 target

- it prepares support for Exynos4212 and Exynos3250 targets which are
  working fine with AFTR mode in our internal kernels and which are not
  yet upstreamed

[*] In the future it should be possible to enable AFTR mode support per
    board using DT (basing on patches from Lorenzo), for now it should be
    fine to check for Trats2 target directly while registering cpuidle
    platform device.  I will post v6 soon.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> > Depends on:
> > - next-20140804 branch of linux-next kernel tree
> > - [PATCH v5][next-20140804] ARM: EXYNOS: Fix suspend/resume sequences
> >    (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35262.html)
> > - [PATCH v2 0/2] Firmware-assisted suspend/resume of Exynos SoCs
> >    (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34282.html)
> >
> > Changes since v4:
> > - rebased on top of next-20140804 +
> >    [PATCH v5][next-20140804] ARM: EXYNOS: Fix suspend/resume sequences
> >    (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35262.html)
> >    [PATCH v2 0/2] Firmware-assisted suspend/resume of Exynos SoCs
> >    (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34282.html)
> > - call exynos_save_cp15() only on A9 type core (this is needed for the future
> >    Exynos3250 SoC support)
> >
> > Changes since v3:
> > - rebased on top of next-20140804 +
> >    [PATCH v4][next-20140804] ARM: EXYNOS: Fix suspend/resume sequences
> >    (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35192.html)
> >    [PATCH v2 0/2] Firmware-assisted suspend/resume of Exynos SoCs
> >    (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34282.html)
> > - (re-)added patch fixing S5P_CENTRAL_SEQ_OPTION register setup
> >
> > Changes since v2:
> > - rebased on top of next-20140708 +
> >    [PATCH 5/6] ARM: EXYNOS: Fix suspend/resume sequencies
> >    (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32809.html)
> >    [with rejects fixed]
> >    [PATCH 6/6] ARM: EXYNOS: Register cpuidle device only on Exynos4210 and 5250
> >    (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32808.html)
> >    [PATCH 0/2] Firmware-assisted suspend/resume of Exynos SoCs
> >    (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32991.html)
> >    [with rejects fixed in patch #2]
> > - addressed review comments from Tomasz Figa and Daniel Lezcano
> >
> > Changes since v1:
> > - synced against next-20140602
> > - added missing Acked-by-s
> >
> > Best regards,
> > --
> > Bartlomiej Zolnierkiewicz
> > Samsung R&D Institute Poland
> > Samsung Electronics
> >
> >
> > Bartlomiej Zolnierkiewicz (5):
> >    ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by static inlines
> >    ARM: EXYNOS: add AFTR mode support to firmware do_idle method
> >    ARM: EXYNOS: cpuidle: add secure firmware support to AFTR mode code
> >    ARM: EXYNOS: PM: fix register setup for AFTR mode code
> >    ARM: EXYNOS: cpuidle: allow driver usage on Exynos4x12 SoCs
> >
> >   arch/arm/include/asm/firmware.h |  2 +-
> >   arch/arm/mach-exynos/common.h   |  5 ++++
> >   arch/arm/mach-exynos/exynos.c   |  4 ++-
> >   arch/arm/mach-exynos/firmware.c | 34 ++++++++++++++++-------
> >   arch/arm/mach-exynos/pm.c       | 60 ++++++++++++++++++++++++-----------------
> >   5 files changed, 70 insertions(+), 35 deletions(-)

