Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3HAKV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:21:59 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:50382 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3HAKV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:21:56 -0400
MIME-Version: 1.0
In-Reply-To: <003501ce8d16$542dd5d0$fc898170$@samsung.com>
References: <003b01ce89f3$2be4db80$83ae9280$@samsung.com>
	<20130726200107.7598.82010@quantum>
	<001901ce8aa8$d1d6fef0$7584fcd0$@samsung.com>
	<20130730064655.22022.62937@quantum>
	<003501ce8d16$542dd5d0$fc898170$@samsung.com>
Date: Thu, 1 Aug 2013 15:51:54 +0530
Message-ID: <CAPdUM4NjLtSCgHQhkcwso+_=5VYEFTY-Octww6G74UJX9ManHw@mail.gmail.com>
Subject: Re: RE: [PATCH v8 05/12] clk: exynos5250: add gate clock descriptions
 of System MMU
From: Rahul Sharma <r.sh.open@gmail.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Keyyoung Park <keyyoung.park@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Prathyush <prathyush.k@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu, Rahul Sharma <rahul.sharma@samsung.com>,
        sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cho,

On Tue, Jul 30, 2013 at 4:47 PM, Cho KyongHo <pullip.cho@samsung.com> wrote:
>> -----Original Message-----
>> From: Mike Turquette [mailto:mturquette@linaro.org]
>> Sent: Tuesday, July 30, 2013 3:47 PM
>> To: Cho KyongHo; 'Linux ARM Kernel'; 'Linux IOMMU'; 'Linux Kernel'; 'Linux Samsung SOC'
>> Cc: 'Kukjin Kim'; 'Hyunwoong Kim'; 'Prathyush'; 'Grant Grundler'; 'Joerg Roedel'; 'Keyyoung Park';
>> 'Subash Patel'; 'Sachin Kamat'; 'Thomas Abraham'; 'Antonios Motakis'; kvmarm@lists.cs.columbia.edu;
>> 'Rahul Sharma'
>> Subject: Re: RE: [PATCH v8 05/12] clk: exynos5250: add gate clock descriptions of System MMU
>>
>> Quoting Cho KyongHo (2013-07-27 02:08:11)
>> > > -----Original Message-----
>> > > From: Mike Turquette [mailto:mturquette@linaro.org]
>> > > Sent: Saturday, July 27, 2013 5:01 AM
>> > >
>> > > Quoting Cho KyongHo (2013-07-26 04:27:54)
>> > > > This adds gate clocks of all System MMUs and their master IPs
>> > > > that are not apeared in clk-exynos5250.c
>> > > >
>> > > > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
>> > >
>> > > Change looks good to me. Are you OK if I take it into the clk tree or do
>> > > you want to keep this series together?
>> >
>> > I would like you to pick this to your tree and let me know which branch
>> > contains this patch.
>> > Then I will remove this from my patch series.
>>
>> camif_top corresponds to 345 in your patch, but this conflicts the g2d
>> clock introduced in patch "clk: exynos5250: Add G2D gate clock" in the
>> clk tree. I've pushed out the latest clk-next branch with this change:
>>
>> git://git.linaro.org/people/mturquette/linux.git clk-next
>>
>> Can you rebase your change on top of this and resolve the clock id
>> mapping?
>>
> Oh,
> I will rebase this patch on your git in the next patch version.
>
> Thank you.
>
>> Thanks,
>> Mike
>>
>> >
>> > Thank you,
>> > Cho KyongHo.
>> > >
>> > > Regards,
>> > > Mike
>> > >
>> > > > ---
>> > > >  .../devicetree/bindings/clock/exynos5250-clock.txt |   28 +++++++++-
>> > > >  drivers/clk/samsung/clk-exynos5250.c               |   57 ++++++++++++++++---
>> > > >  2 files changed, 75 insertions(+), 10 deletions(-)
>> > > >
>> > > > diff --git a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
>> > > > b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
>> > > > index 781a627..df49694 100644
>> > > > --- a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
>> > > > +++ b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
>> > > > @@ -154,7 +154,33 @@ clock which they consume.
>> > > >    dsim0                        341
>> > > >    dp                   342
>> > > >    mixer                        343
>> > > > -  hdmi                 345
>> > > > +  hdmi                 344
>> > > > +  camif_top            345
>> > > > +  smmu_fimc_lite0      346
>> > > > +  smmu_fimc_lite1      347
>> > > > +  smmu_fimc_lite2      348
>> > > > +  smmu_tv              349
>> > > > +  smmu_fimd1           350
>> > > > +  smmu_2d              351
>> > > > +  fimc_isp             352
>> > > > +  fimc_drc             353
>> > > > +  fimc_fd              354
>> > > > +  fimc_scc             355
>> > > > +  fimc_scp             356
>> > > > +  fimc_mcuctl          357
>> > > > +  fimc_odc             358
>> > > > +  fimc_dis             359
>> > > > +  fimc_3dnr            360
>> > > > +  smmu_fimc_isp                361
>> > > > +  smmu_fimc_drc                362
>> > > > +  smmu_fimc_fd         363
>> > > > +  smmu_fimc_scc                364
>> > > > +  smmu_fimc_scp                365
>> > > > +  smmu_fimc_mcuctl     366
>> > > > +  smmu_fimc_odc                367
>> > > > +  smmu_fimc_dis0       368
>> > > > +  smmu_fimc_dis1       369
>> > > > +  smmu_fimc_3dnr       370
>> > > >
>> > > >  Example 1: An example of a clock controller node is listed below.
>> > > >
>> > > > diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
>> > > > index 22d7699..e242bde 100644
>> > > > --- a/drivers/clk/samsung/clk-exynos5250.c
>> > > > +++ b/drivers/clk/samsung/clk-exynos5250.c
>> > > > @@ -53,12 +53,15 @@
>> > > >  #define DIV_PERIC3             0x10564
>> > > >  #define DIV_PERIC4             0x10568
>> > > >  #define DIV_PERIC5             0x1056c
>> > > > +#define GATE_IP_ISP0           0x0C800
>> > > > +#define GATE_IP_ISP1           0x0C800
>> > > >  #define GATE_IP_GSCL           0x10920
>> > > >  #define GATE_IP_MFC            0x1092c
>> > > >  #define GATE_IP_GEN            0x10934
>> > > >  #define GATE_IP_FSYS           0x10944
>> > > >  #define GATE_IP_PERIC          0x10950
>> > > >  #define GATE_IP_PERIS          0x10960
>> > > > +#define GATE_IP_ACP            0x18800
>> > > >  #define SRC_CDREX              0x20200
>> > > >  #define PLL_DIV2_SEL           0x20a24
>> > > >  #define GATE_IP_DISP1          0x10928
>> > > > @@ -100,6 +103,14 @@ enum exynos5250_clks {
>> > > >         tzpc2, tzpc3, tzpc4, tzpc5, tzpc6, tzpc7, tzpc8, tzpc9, hdmi_cec, mct,
>> > > >         wdt, rtc, tmu, fimd1, mie1, dsim0, dp, mixer, hdmi,
>> > > >
>> > > > +       camif_top, smmu_fimc_lite0, smmu_fimc_lite1, smmu_fimc_lite2,
>> > > > +       smmu_tv, smmu_fimd1, smmu_2d,
>> > > > +       fimc_isp, fimc_drc, fimc_fd, fimc_scc, fimc_scp, fimc_mcuctl, fimc_odc,
>> > > > +       fimc_dis, fimc_3dnr,
>> > > > +       smmu_fimc_isp, smmu_fimc_drc, smmu_fimc_fd, smmu_fimc_scc,
>> > > > +       smmu_fimc_scp, smmu_fimc_mcuctl, smmu_fimc_odc, smmu_fimc_dis0,
>> > > > +       smmu_fimc_dis1, smmu_fimc_3dnr,
>> > > > +
>> > > >         nr_clks,
>> > > >  };
>> > > >
>> > > > @@ -320,19 +331,26 @@ struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
>> > > >         GATE(gscl3, "gscl3", "aclk266", GATE_IP_GSCL, 3, 0, 0),
>> > > >         GATE(gscl_wa, "gscl_wa", "div_gscl_wa", GATE_IP_GSCL, 5, 0, 0),
>> > > >         GATE(gscl_wb, "gscl_wb", "div_gscl_wb", GATE_IP_GSCL, 6, 0, 0),
>> > > > -       GATE(smmu_gscl0, "smmu_gscl0", "aclk266", GATE_IP_GSCL, 7, 0, 0),
>> > > > -       GATE(smmu_gscl1, "smmu_gscl1", "aclk266", GATE_IP_GSCL, 8, 0, 0),
>> > > > -       GATE(smmu_gscl2, "smmu_gscl2", "aclk266", GATE_IP_GSCL, 9, 0, 0),
>> > > > -       GATE(smmu_gscl3, "smmu_gscl3", "aclk266", GATE_IP_GSCL, 10, 0, 0),
>> > > > +       GATE(smmu_gscl0, "smmu_gscl0", "none", GATE_IP_GSCL, 7, 0, 0),
>> > > > +       GATE(smmu_gscl1, "smmu_gscl1", "none", GATE_IP_GSCL, 8, 0, 0),
>> > > > +       GATE(smmu_gscl2, "smmu_gscl2", "none", GATE_IP_GSCL, 9, 0, 0),
>> > > > +       GATE(smmu_gscl3, "smmu_gscl3", "none", GATE_IP_GSCL, 10, 0, 0),
>> > > > +       GATE(camif_top, "camif_top", "aclk266", GATE_IP_GSCL, 4, 0, 0),
>> > > > +       GATE(smmu_fimc_lite0, "smmu_fimc_lite0", "none",
>> > > > +                                               GATE_IP_GSCL, 12, 0, 0),
>> > > > +       GATE(smmu_fimc_lite1, "smmu_fimc_lite1", "none",
>> > > > +                                               GATE_IP_GSCL, 13, 0, 0),
>> > > > +       GATE(smmu_fimc_lite2, "smmu_fimc_lite2", "none",
>> > > > +                                               GATE_IP_GSCL, 14, 0, 0),
>> > > >         GATE(mfc, "mfc", "aclk333", GATE_IP_MFC, 0, 0, 0),
>> > > > -       GATE(smmu_mfcl, "smmu_mfcl", "aclk333", GATE_IP_MFC, 1, 0, 0),
>> > > > -       GATE(smmu_mfcr, "smmu_mfcr", "aclk333", GATE_IP_MFC, 2, 0, 0),
>> > > > +       GATE(smmu_mfcr, "smmu_mfcr", "none", GATE_IP_MFC, 1, 0, 0),
>> > > > +       GATE(smmu_mfcl, "smmu_mfcl", "none", GATE_IP_MFC, 2, 0, 0),
>> > > >         GATE(rotator, "rotator", "aclk266", GATE_IP_GEN, 1, 0, 0),
>> > > >         GATE(jpeg, "jpeg", "aclk166", GATE_IP_GEN, 2, 0, 0),
>> > > >         GATE(mdma1, "mdma1", "aclk266", GATE_IP_GEN, 4, 0, 0),
>> > > > -       GATE(smmu_rotator, "smmu_rotator", "aclk266", GATE_IP_GEN, 6, 0, 0),
>> > > > -       GATE(smmu_jpeg, "smmu_jpeg", "aclk166", GATE_IP_GEN, 7, 0, 0),
>> > > > -       GATE(smmu_mdma1, "smmu_mdma1", "aclk266", GATE_IP_GEN, 9, 0, 0),
>> > > > +       GATE(smmu_rotator, "smmu_rotator", "none", GATE_IP_GEN, 6, 0, 0),
>> > > > +       GATE(smmu_jpeg, "smmu_jpeg", "none", GATE_IP_GEN, 7, 0, 0),
>> > > > +       GATE(smmu_mdma1, "smmu_mdma1", "none", GATE_IP_GEN, 9, 0, 0),
>> > > >         GATE(pdma0, "pdma0", "aclk200", GATE_IP_FSYS, 1, 0, 0),
>> > > >         GATE(pdma1, "pdma1", "aclk200", GATE_IP_FSYS, 2, 0, 0),
>> > > >         GATE(sata, "sata", "aclk200", GATE_IP_FSYS, 6, 0, 0),
>> > > > @@ -462,6 +480,27 @@ struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
>> > > >         GATE(dp, "dp", "aclk200", GATE_IP_DISP1, 4, 0, 0),
>> > > >         GATE(mixer, "mixer", "aclk200", GATE_IP_DISP1, 5, 0, 0),
>> > > >         GATE(hdmi, "hdmi", "aclk200", GATE_IP_DISP1, 6, 0, 0),
>> > > > +       GATE(smmu_tv, "smmu_tv", "none", GATE_IP_DISP1, 2, 0, 0),

It is 9th bit in GATE_IP_DISP1 for smmu_tv clock. All clocks without
parents, are added to the list of orphan clocks. We should add correct
parents to them.

regards,
Rahul Sharma.

>> > > > +       GATE(smmu_fimd1, "smmu_fimd1", "none", GATE_IP_DISP1, 8, 0, 0),
>> > > > +
>> > > > +       GATE(smmu_fimc_isp, "smmu_fimc_isp", "none", GATE_IP_ISP0, 8, 0, 0),
>> > > > +       GATE(smmu_fimc_drc, "smmu_fimc_drc", "none", GATE_IP_ISP0, 9, 0, 0),
>> > > > +       GATE(smmu_fimc_fd, "smmu_fimc_fd", "none", GATE_IP_ISP0, 10, 0, 0),
>> > > > +       GATE(smmu_fimc_scc, "smmu_fimc_scc", "none",
>> > > > +                                                       GATE_IP_ISP0, 11, 0, 0),
>> > > > +       GATE(smmu_fimc_scp, "smmu_fimc_scp", "none",
>> > > > +                                                       GATE_IP_ISP0, 12, 0, 0),
>> > > > +       GATE(smmu_fimc_mcuctl, "smmu_fimc_mcuctl", "none",
>> > > > +                                                       GATE_IP_ISP0, 13, 0, 0),
>> > > > +       GATE(smmu_fimc_odc, "smmu_fimc_odc", "none", GATE_IP_ISP1, 4, 0, 0),
>> > > > +       GATE(smmu_fimc_dis0, "smmu_fimc_dis0", "none",
>> > > > +                                                       GATE_IP_ISP1, 5, 0, 0),
>> > > > +       GATE(smmu_fimc_dis1, "smmu_fimc_dis1", "none",
>> > > > +                                                       GATE_IP_ISP1, 6, 0, 0),
>> > > > +       GATE(smmu_fimc_3dnr, "smmu_fimc_3dnr", "none",
>> > > > +                                                       GATE_IP_ISP1, 7, 0, 0),
>> > > > +
>> > > > +       GATE(smmu_2d, "smmu_2d", "none", GATE_IP_ACP, 7, 0, 0),
>> > > >  };
>> > > >
>> > > >  static __initdata struct of_device_id ext_clk_match[] = {
>> > > > --
>> > > > 1.7.2.5
>> > > >
>> > > >
>> > > >
>> > > > _______________________________________________
>> > > > linux-arm-kernel mailing list
>> > > > linux-arm-kernel@lists.infradead.org
>> > > > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
