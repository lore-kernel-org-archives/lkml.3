Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaCNKsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:48:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34516 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbaCNKsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:48:08 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-2c-5322de65c86b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 0/8] devfreq: exynos4: Support dt and use common ppmu
 driver
Date: Fri, 14 Mar 2014 11:47:50 +0100
Message-id: <2149456.oUDFM14jk3@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <532273FB.6040303@samsung.com>
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
 <2117336.08cyWySR1X@amdc1032> <532273FB.6040303@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xgG7qPaVgg+lHrS2uf3nOajH/yDlW
	i3OvVjJanG16w26xsG0Ji8XlXXPYLD73HmG0mHF+H5PF0usXmSxuN65gs3jz4yyTxYTpa1ks
	Hq94y27x6mAbiwOfx5p5axg9Vi7/wuaxeM9LJo++LasYPY7f2M7k8XmTnMfGuaEB7FFcNimp
	OZllqUX6dglcGXt3PGMseKpQcXv2IpYGxheSXYycHBICJhKHvn5jhbDFJC7cW8/WxcjFISSw
	iFHi9POfUE4Lk8S+n+9YQKrYBKwkJravYgSxRQQ0JGb+vcIIUsQscItJ4uy3KWBFwgIhErcO
	HWEDsVkEVCV+rJzADGLzCmhK3Px+iB3EFhXwlNixfSVYDaeAtkTf7nZWqG2MEg9Wb4ZqEJT4
	Mfke2FBmAXmJffunskLYOhL7W6exTWAUmIWkbBaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswt
	Ls1L10vOz93ECI6hZ9I7GFc1WBxiFOBgVOLhnXFUMViINbGsuDL3EKMEB7OSCO+qq0rBQrwp
	iZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhiXXtxyo/XjluO8
	mvv+Ppd/rxcs8LV0kse/OBnVYo2UUykfbyw8Ee19Jb1W827tx9x/eyNVZ5yeo+j1vvVy5JS7
	kaHMrzaUL6r95ehwrOf/XOV5LxTV5h9sC1oR+ef4hDmxE11LdsnZ8itzPWPYcmjWj02Hl+jl
	SrxOKwh/MfH8YdaasNhD1bwhSizFGYmGWsxFxYkAZKXmzZ0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 14, 2014 12:14:03 PM Chanwoo Choi wrote:
> Hi,
> 
> On 03/14/2014 01:43 AM, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > On Thursday, March 13, 2014 05:17:21 PM Chanwoo Choi wrote:
> >> This patchset support devicetree and use common ppmu driver instead of
> >> individual code of exynos4_bus.c to remove duplicate code. Also this patchset
> >> get the resources for busfreq from dt data by using DT helper function.
> >> - PPMU register address
> >> - PPMU clock
> >> - Regulator for INT/MIF block
> >>
> >> This patchset use SET_SYSTEM_SLEEP_PM_OPS macro intead of legacy method.
> >> To remove power-leakage in suspend state, before entering suspend state,
> >> disable ppmu clocks.
> >>
> >> Changes from v1:
> >> - Add exynos4_bus.txt documentation for devicetree guide
> >> - Fix probe failure if CONFIG_PM_OPP is disabled
> >> - Fix typo and resource leak(regulator/clock/memory) when happening probe failure
> >> - Add additionally comment for PPMU usage instead of previous PPC
> >> - Split separate patch to remove ambiguous of patch
> >>
> >> Chanwoo Choi (8):
> >>   devfreq: exynos4: Support devicetree to get device id of Exynos4 SoC
> >>   devfreq: exynos4: Use common ppmu driver and get ppmu address from dt data
> >>   devfreq: exynos4: Add ppmu's clock control and code clean about regulator control
> >>   devfreq: exynos4: Fix bug of resource leak and code clean on probe()
> >>   devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
> >>   devfreq: exynos4: Fix power-leakage of clock on suspend state
> >>   devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix probe fail
> >>   devfreq: exynos4: Add busfreq driver for exynos4210/exynos4x12
> >>
> >>  .../devicetree/bindings/devfreq/exynos4_bus.txt    |  49 +++
> >>  drivers/devfreq/Kconfig                            |   1 +
> >>  drivers/devfreq/exynos/Makefile                    |   2 +-
> >>  drivers/devfreq/exynos/exynos4_bus.c               | 415 ++++++++++++++-------
> >>  4 files changed, 341 insertions(+), 126 deletions(-)
> >>  create mode 100644 Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
> > 
> > Thanks for updating this patchset.  There are still some minor issues
> > left though:
> > 
> > - patch #4 should be at beginning of the patch series
> > 
> > - moving of devfreq_unregister_opp_notifier(dev, data->devfreq) from
> >   exynos4_bus_exit() to exynos4_busfreq_remove() should be in patch #4
> >   (which should really be at the beggining of patch series) not #3
> > 
> > - handling of iounmap(data->ppmu[i].hw_base) should be added to
> >   exynos4_bus_exit() in patch #2 not #3
> > 
> > - patch #8 summary and description should mention fact that it adds DT
> >   binding documentation (not the driver itself) and the patch itself
> >   can be slighlty polished
> 
> OK, I'll re-order the sequence of patchset and modify minior issues about your comment.
> Also, I'll modify the patch description for patch8.
> 
> > 
> > One important note about this patchset not mentioned in the cover
> > letter is that it is improving currently unused driver (because of
> > DT-only mach-exynos conversion the only user was removed in June 2013
> > and from the reading the code I suspect that even that user hadn't
> > worked previously).  As such this patch series should not cause any
> > regressions.
> 
> I don't understand correct your meaning.I explained DT support on upper
> patchset description by using DT helper function and I added PPMU descritpion.
> Also, Each patch include detailed description of patch content.

Everything is okay, I just noted that since there are no users of this
driver currently (the only user was NURI and it was removed by DT
conversion of mach-exynos) it should be okay to merge the patch series
quickly once reviewed and acked by the respective maintainers.

> What is more needed?

Users of the driver? ;)

Your patchset adds DT support and fixes to the driver but it doesn't
add actual users of the driver to arch/arm/boot/dts/ files.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

