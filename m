Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250Ab3FTKRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:17:09 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22151 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935407Ab3FTKRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:17:06 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-2b-51c2d6a0593a
From: Tomasz Figa <t.figa@samsung.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Chander Kashyap <chander.kashyap@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jingoo Han <jg1.han@samsung.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Will Deacon <Will.Deacon@arm.com>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] ARM: EXYNOS: Fix incorrect usage of S5P_ARM_CORE1_*
 registers
Date: Thu, 20 Jun 2013 12:16:55 +0200
Message-id: <1550511.tLVEbtuIcN@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.3 (Linux/3.8.8-gentoo; KDE/4.10.3; x86_64; ; )
In-reply-to: <alpine.LFD.2.03.1306191110130.18597@syhkavp.arg>
References: <1371569191-2364-1-git-send-email-t.figa@samsung.com>
 <24503071.R7UT57fHdP@amdc1227>
 <alpine.LFD.2.03.1306191110130.18597@syhkavp.arg>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t/xq7oLrh0KNFjxisvi8ZrFTBZ/Jx1j
	t3i4/iaLxeWFl1gtljRzW/QuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi9uXeS3e/H7BbvHp
	2T92i1PXP7NZ/DjTzWKxYOMjRotVu/4wWrz8eILFQchjzbw1jB4tzT1sHr9/TWL0uNzXy+Sx
	c9Zddo871/aweWxeUu9x5UQTq0ffllWMHp83yQVwRXHZpKTmZJalFunbJXBl/JsxmbHglXjF
	ibWbGBsYTwp2MXJySAiYSCxdNJ8VwhaTuHBvPVsXIxeHkMBSRolDj+9AOV1MEhNP7WYBqWIT
	UJP43PCIDcQWEdCRODrzNTNIEbPAUjaJq/O6gBIcHMICIRIdveYgNSwCqhJvX51nArF5BTQl
	jrV1gm3jF1CXeLftKVhcVMBV4v3qw2DzOQXsJJo3/WCHWDyNUWLfjL2sEM2CEj8m3wMrYhaQ
	l9i3fyorhK0lsX7ncaYJjIKzkJTNQlI2C0nZAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5
	mxghsfllB+PiY1aHGAU4GJV4eDUvHwwUYk0sK67MPcQowcGsJMKbOudQoBBvSmJlVWpRfnxR
	aU5q8SFGJg5OqQbGyLn7/5TOYYu6IaaXEGeygbdG4COnhOH524K8Qgk26tdkf3VzZL73l1ys
	7a3VL3fZz8LyojizF8/LHMnUmRMs3y5muiVUz2BpkvujVH35pJ18X5f57lriFHSK8baL4nWR
	iMP6M946mH9uD9nRXffsw8f1br78r/ayRNeXa73xjF4o1rrf4LwSS3FGoqEWc1FxIgDtn1t+
	qwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 of June 2013 11:19:30 Nicolas Pitre wrote:
> On Wed, 19 Jun 2013, Tomasz Figa wrote:
> > On Wednesday 19 of June 2013 20:26:50 Chander Kashyap wrote:
> > > On 19 June 2013 19:58, Tomasz Figa <t.figa@samsung.com> wrote:
> > > > I mean, calculate register offset based on two parameters - cluster
> > > > ID
> > > > and>
> > > > 
> > > > CPU ID, like:
> > > >         ...
> > > >         
> > > >         u32 mpidr = cpu_logical_map(cpu);
> > > >         u32 phys_cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> > > >         
> > > >         if (soc_is_exynosXXXX()) {
> > > >         
> > > >                 u32 cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
> > > >                 
> > > >                 phys_cpu += EXYNOSXXXX_CPUS_PER_CLUSTER * cluster;
> > > >         
> > > >         }
> > > >         
> > > >         reg_base = S5P_ARM_CORE_CONFIGURATION(phys_cpu);
> > > >         __raw_writel(0, reg_base);
> > > 
> > > This does not seems to viable solution, as eg. clusterID for
> > > exynos4210 is 0x9 and exynos 4412 is 0xa.
> > 
> > We don't need to consider cluster ID for any SoC that has just one
> > cluster. That's why there is the if (soc_is_exynosXXXX()) clause,
> > where exynosXXXX is the SoC that we support and has more clusters.
> > 
> > > But if we wass the cpu nodes
> > > thru DT, the we can comfortably rely on the logical cpu number. Also
> > > EXYNOSXXXX_CPUS_PER_CLUSTER can vary from cluster to cluster.
> > 
> > There is nothing that prevents you from specifying the CPUs in DT in
> > different order. Moreover, even if you specify them in correct order,
> > there is nothing that prevents you from using any of the listed CPUs
> > as boot CPU, which will get the logical ID of 0.
> 
> Relying on the logical CPU number to index into hardware related
> register space is wrong, please don't do that.
> 
> If the MPIDR allocation isn't linear then this cannot be used either.
> 
> The best solution is probably to add this reg_base as a property of each
> CPU node in DT, and extract it at boot time to stash it into an array
> which can be indexed with the logical CPU number afterwards.

Currently we don't specify the cpu node in DT at all for Exynos 4210, 4212 
and 4412. It's sure that their device tree sources need to be modified to 
correct his, but since DT is considered an ABI, we should keep 
compatibility with old device tree blobs. 

This means that we can't strictly require this property to be present in 
device tree, because it will break existing boards with older device trees. 
So my suggestion is to user cluster ID and CPU ID to calculate the offset by 
default and add possibility to override it with a property in device tree 
if such need shows up.

What do you think?

Best regards,
Tomasz

> Nicolas
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-samsung-soc" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
