Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790Ab3HHLkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 07:40:20 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9277 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934065Ab3HHLkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 07:40:18 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-57-520383a031f9
From: Tomasz Figa <t.figa@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Cho KyongHo <pullip.cho@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 05/16] clk: exynos: add gate clock descriptions of
 System MMU
Date: Thu, 08 Aug 2013 13:40:13 +0200
Message-id: <1673985.XNpTEeH9vo@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-reply-to: <52037E4E.5050706@samsung.com>
References: <002901ce941b$0130db50$039291f0$@samsung.com>
 <52037E4E.5050706@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e/4Zd0FzcxBBk9XCljcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+Tg4DHk4PzmDxmN1xk8bhzbQ+bx/lNa5g9Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgDOKyyYlNSezLLVI3y6BK2P32iuMBQ/4K45cm8nWwHicp4uRk0NCwETi
	26dZrBC2mMSFe+vZuhi5OIQEljJK3Hm1iRnC6WKS+Ph+GwtIFZuAmsTnhkdsILaIgL7EklUX
	wWxmgQWsEku3mYPYwgJhEicOdQLFOThYBFQllh1zBQnzCmhKLJt8mh3E5hdQl3i37SkTSImo
	gJvEhI/5IGFOAW2J7aungE0UEoiSWN+/lQWiVVDix+R7LBCb5CX27Z/KCmFrSazfeZxpAqPg
	LCRls5CUzUJStoCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSOR93cG49JjVIUYBDkYl
	Ht6OAKYgIdbEsuLK3EOMEhzMSiK8L7KYg4R4UxIrq1KL8uOLSnNSiw8xMnFwSjUwFt2K+Bfm
	K+pZuC+Kc8uk6IsOT6dxX//Y/3rf2ydzTlU8sWsIYP7zmVno9xO32yJxdtON9gvs5l2QV5iZ
	wlDBYromk9FKPSmyIPvEC2nFuJxZD/UE+4Osd793u1oRxH2uTKKzUoo5K2vGDpYdBXZ2z9zD
	7vKdKrZm7VeYnuswSYObI0I5/5YSS3FGoqEWc1FxIgBXYoXwmgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 of August 2013 13:17:34 Sylwester Nawrocki wrote:
> On 08/08/2013 11:38 AM, Cho KyongHo wrote:
> > This adds gate clocks of all System MMUs and their master IPs
> > that are not apeared in clk-exynos5250.c
> > Also fixes GATE_IP_ACP to 0x18800 and changed GATE_DA to GATE
> > for System MMU clocks in clk-exynos4.c
> > 
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> > 
> >  .../devicetree/bindings/clock/exynos5250-clock.txt |   26 +++++++++
> >  drivers/clk/samsung/clk-exynos4.c                  |   27 +++------
> >  drivers/clk/samsung/clk-exynos5250.c               |   57
> >  ++++++++++++++++---- 3 files changed, 82 insertions(+), 28
> >  deletions(-)
> 
> [...]
> 
> > @@ -349,19 +358,26 @@ static struct samsung_gate_clock
> > exynos5250_gate_clks[] __initdata = {> 
> >  	GATE(gscl3, "gscl3", "aclk266", GATE_IP_GSCL, 3, 0, 0),
> >  	GATE(gscl_wa, "gscl_wa", "div_gscl_wa", GATE_IP_GSCL, 5, 0, 0),
> >  	GATE(gscl_wb, "gscl_wb", "div_gscl_wb", GATE_IP_GSCL, 6, 0, 0),
> > 
> > -	GATE(smmu_gscl0, "smmu_gscl0", "aclk266", GATE_IP_GSCL, 7, 0, 0),
> > -	GATE(smmu_gscl1, "smmu_gscl1", "aclk266", GATE_IP_GSCL, 8, 0, 0),
> > -	GATE(smmu_gscl2, "smmu_gscl2", "aclk266", GATE_IP_GSCL, 9, 0, 0),
> > -	GATE(smmu_gscl3, "smmu_gscl3", "aclk266", GATE_IP_GSCL, 10, 0, 0),
> > +	GATE(smmu_gscl0, "smmu_gscl0", "none", GATE_IP_GSCL, 7, 0, 0),
> > +	GATE(smmu_gscl1, "smmu_gscl1", "none", GATE_IP_GSCL, 8, 0, 0),
> > +	GATE(smmu_gscl2, "smmu_gscl2", "none", GATE_IP_GSCL, 9, 0, 0),
> > +	GATE(smmu_gscl3, "smmu_gscl3", "none", GATE_IP_GSCL, 10, 0, 0),
> 
> Why are the smmu clocks' parent clocks removed ? Shouldn't both the
> gscaler gate clock and the gscaler smmu clock be still same, as it is in
> case of exynos4 ?

I agree with Sylwester.

In fact, it is not a valid clock setup. A valid clock must be either root 
clock (indicated by appropriate clock flag and specified frequency) or have 
a valid parent.

Best regards,
Tomasz

