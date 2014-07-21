Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbaGUNLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:11:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35662 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbaGUNLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:11:15 -0400
X-AuditID: cbfee61a-f79e46d00000134f-94-53cd1171961e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Daniel Drake <drake@endlessm.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tomasz Figa <t.figa@samsung.com>, thomas.ab@samsung.com
Subject: Re: [PATCH] ARM: dts: add CPU nodes for Exynos4 SoCs
Date: Mon, 21 Jul 2014 15:10:54 +0200
Message-id: <10657588.befqTi5XsZ@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <CAD8Lp46eB3cDqD+1YMnWOG-V8CG7fCG1s2KH7znL0OrHSazRcQ@mail.gmail.com>
References: <1863399.9O2S91ZvEO@amdc1032>
 <CAD8Lp46eB3cDqD+1YMnWOG-V8CG7fCG1s2KH7znL0OrHSazRcQ@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=UTF-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jQd1CwbPBBufvGlo8mv+Y2aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBZvfr9gt1h75C67xfoZr1ksOpYxOnB6rJm3htFj0fcsj81L6j36
	tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoEr49X8d6wFE3gqjh37wdzAeJ+zi5GTQ0LARGLDlZks
	ELaYxIV769m6GLk4hASmM0pM2fCAHSQhJNDCJHHsUCGIzSZgJTGxfRUjiC0ioCrxa3kzK0gD
	s8ABJonLCyeCJYQFbCWaL7azgtgsQEVLmieADeIV0JL4sngmM4gtKuApsWP7SjYQm1MgWGLO
	uR0sEMsKJD5MXMYGUS8o8WPyPbA4s4C8xL79U1khbHWJSfMWMU9gFJiFpGwWkrJZSMoWMDKv
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgO+mdSOxhXNlgcYhTgYFTi4fVgPBMsxJpYVlyZ
	e4hRgoNZSYS3lvFssBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZ
	Jg5OqQbGvAPmji7b5BdJ8Sv1mvmlXX+WKpTNwefdIhiS+Gq+P69DpkHKbv3PT7m3OcbrLbRy
	ibpyuuiriVrKq90nrB9W/Jjl/nya3vQNTremqz4Xdmfb066Ue+jTB7uOilN7J6y4zfP2o9LG
	bRO0dyRNK75inO+84tp66X3mp3bY++taJz5acOxp7ApvJZbijERDLeai4kQAzt7QD3YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, July 21, 2014 01:43:53 PM Daniel Drake wrote:
> On Fri, Jul 18, 2014 at 5:00 PM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> > Recent patch by Tomasz Figa ("irqchip: gic: Fix core ID calculation
> > when topology is read from DT") fixed GIC driver to filter cluster ID
> > from values returned by cpu_logical_map() for SoCs having registers
> > mapped without per-CPU banking making it is possible to add CPU nodes
> > for Exynos4 SoCs.  In case of Exynos SoCs these CPU nodes are also
> > required by future changes adding initialization of cpuidle states in
> > Exynos cpuidle driver through DT.
> 
> This conflicts with work in the thread "cpufreq: use generic cpufreq
> drivers for exynos platforms" which is already in its 7th iteration.
> Perhaps best to work directly with Thomas to help him finish that series?

Patch "[PATCH v7 4/6] ARM: dts: Exynos: add cpu nodes, opp and cpu clock
configuration data" from Thomas needs another revision anyway since it lacks
cluster ID in Exynos4210 CPU node.  It also mixes addition of CPU nodes
with cpufreq specific changes and IMHO addition of CPU nodes should be in
separate patch to ease bisection if any later problems turn up.  Therefore
I think that it would be the best if Thomas would rebase his work on top of
"irqchip: gic: Fix core ID calculation when topology is read from DT" patch
and this one.  Thomas, are you okay with this?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

