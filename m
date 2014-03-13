Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaCMQnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:43:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29983 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbaCMQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:43:39 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-d3-5321e039d62f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 0/8] devfreq: exynos4: Support dt and use common ppmu
 driver
Date: Thu, 13 Mar 2014 17:43:21 +0100
Message-id: <2117336.08cyWySR1X@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+xoK7lA8Vgg/YjIhYbZ6xntbj+5Tmr
	xfwj51gtzr1ayWhxtukNu8XCtiUsFpd3zWGz+Nx7hNFixvl9TBZLr19ksrjduILN4s2Ps0wW
	E6avZbF4vOItu8Wrg20sDvwea+atYfRYufwLm8fiPS+ZPPq2rGL0OH5jO5PH501yHhvnhgaw
	R3HZpKTmZJalFunbJXBlPP5+jKXgmHjFh8ZXzA2Mj4S6GDk5JARMJBpfTmWBsMUkLtxbz9bF
	yMUhJDCdUaKp9QSU08IkMf/WRTaQKjYBK4mJ7asYQWwRAQ2JmX+vMIIUMQt8YZKY8Pk3O0hC
	WCBE4tahI2ANLAKqEv+3t4Gt4BXQlOhpWsMKYosKeErs2L4SrIZTwE3i5t1pTCC2kICrxIXW
	KcwQ9YISPybfA+tlFpCX2Ld/KiuErSOxv3Ua2wRGgVlIymYhKZuFpGwBI/MqRtHUguSC4qT0
	XEO94sTc4tK8dL3k/NxNjOBYeia1g3Flg8UhRgEORiUeXofDisFCrIllxZW5hxglOJiVRHhl
	LgOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJxcEo1MO7R3x3+
	pCevbVP0XIv33elP36xhCo5asc85d4EWw4G06S/ebJa/U3ORP0c6Tv956724Bm8HqZmL06Lj
	ep3K1UyOsId/601/VrLIo9xccMaOS6d5Plp+Od243zs74sbzowy/vtnxlbFvSlNQl9F7O9Uo
	+NY9vtQHu0/28O7rmGlzVChj8tN5W5VYijMSDbWYi4oTAcJTPjahAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, March 13, 2014 05:17:21 PM Chanwoo Choi wrote:
> This patchset support devicetree and use common ppmu driver instead of
> individual code of exynos4_bus.c to remove duplicate code. Also this patchset
> get the resources for busfreq from dt data by using DT helper function.
> - PPMU register address
> - PPMU clock
> - Regulator for INT/MIF block
> 
> This patchset use SET_SYSTEM_SLEEP_PM_OPS macro intead of legacy method.
> To remove power-leakage in suspend state, before entering suspend state,
> disable ppmu clocks.
> 
> Changes from v1:
> - Add exynos4_bus.txt documentation for devicetree guide
> - Fix probe failure if CONFIG_PM_OPP is disabled
> - Fix typo and resource leak(regulator/clock/memory) when happening probe failure
> - Add additionally comment for PPMU usage instead of previous PPC
> - Split separate patch to remove ambiguous of patch
> 
> Chanwoo Choi (8):
>   devfreq: exynos4: Support devicetree to get device id of Exynos4 SoC
>   devfreq: exynos4: Use common ppmu driver and get ppmu address from dt data
>   devfreq: exynos4: Add ppmu's clock control and code clean about regulator control
>   devfreq: exynos4: Fix bug of resource leak and code clean on probe()
>   devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
>   devfreq: exynos4: Fix power-leakage of clock on suspend state
>   devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix probe fail
>   devfreq: exynos4: Add busfreq driver for exynos4210/exynos4x12
> 
>  .../devicetree/bindings/devfreq/exynos4_bus.txt    |  49 +++
>  drivers/devfreq/Kconfig                            |   1 +
>  drivers/devfreq/exynos/Makefile                    |   2 +-
>  drivers/devfreq/exynos/exynos4_bus.c               | 415 ++++++++++++++-------
>  4 files changed, 341 insertions(+), 126 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/devfreq/exynos4_bus.txt

Thanks for updating this patchset.  There are still some minor issues
left though:

- patch #4 should be at beginning of the patch series

- moving of devfreq_unregister_opp_notifier(dev, data->devfreq) from
  exynos4_bus_exit() to exynos4_busfreq_remove() should be in patch #4
  (which should really be at the beggining of patch series) not #3

- handling of iounmap(data->ppmu[i].hw_base) should be added to
  exynos4_bus_exit() in patch #2 not #3

- patch #8 summary and description should mention fact that it adds DT
  binding documentation (not the driver itself) and the patch itself
  can be slighlty polished

One important note about this patchset not mentioned in the cover
letter is that it is improving currently unused driver (because of
DT-only mach-exynos conversion the only user was removed in June 2013
and from the reading the code I suspect that even that user hadn't
worked previously).  As such this patch series should not cause any
regressions.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

