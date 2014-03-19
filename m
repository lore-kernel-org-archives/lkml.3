Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbaCSAje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:39:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44982 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792AbaCSAjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:39:31 -0400
X-AuditID: cbfee68e-b7f566d000002344-16-5328e7424f56
Date: Wed, 19 Mar 2014 09:39:29 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 20/27] iommu/exynos: allow having multiple System MMUs
 for a master H/W
Message-id: <20140319093929.d3a7cea131c626cf978e0ff1@samsung.com>
In-reply-to: <532857A8.5060000@samsung.com>
References: <20140314141050.c8bedcb66532d277c496796d@samsung.com>
 <53232A53.4040708@samsung.com>
 <20140318220128.564740c88d06b86c9c5c10e3@samsung.com>
 <532857A8.5060000@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t8zA12n5xrBBnca+C3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mp4eecAU8FtiYop75ewNzDuEO5i5OSQEDCReLdxNiOE
	LSZx4d56ti5GLg4hgWWMEj+WL2CCKdr8aQsTRGI6o8SlX81QVZOZJN7dOsYGUsUioCrR9vEv
	C4jNJqAlsXrucbCxIgIqEpdPTWcEaWAWaGSVeHR/GTtIQlggUeLhp0lgK3gFHCWa+/vB4pwC
	2hKT3j6CWrebUWLa2UPsEHdYSFxo6mCHaBCU+DH5Htg2ZqBtm7c1sULY8hKb17xlBmmWEFjI
	IXHqwC0WiPMEJL5NPgRkcwAlZCU2HWCGmCkpcXDFDZYJjGKzkIydhWTsLCRjFzAyr2IUTS1I
	LihOSi8y0itOzC0uzUvXS87P3cQIifi+HYw3D1gfYkwGWjmRWUo0OR+YMPJK4g2NzYwsTE1M
	jY3MLc1IE1YS5130MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PEaZZ5u80SpVfuK0s+
	7RYbyft3lcazw0+2li4+yHj/fOkih7NzX6V4lf4I7pzRvnXC6e0HdlZtEZC+oNSsVWi7gP/u
	q/16/zfpR6x7edPp8/uEOWJWWnmS+z+uLDgqL/HhpcN1qSkCoQazY1fcmfOIq/t2c0/SgSeZ
	YQfiVOft52wIudvzXJVRiaU4I9FQi7moOBEAiIiyzw4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsVy+t9jQV2n5xrBBmcaOS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8fLOAaaC2xIV
	U94vYW9g3CHcxcjJISFgIrH50xYmCFtM4sK99WxdjFwcQgLTGSUu/WqGciYzSby7dYwNpIpF
	QFWi7eNfFhCbTUBLYvXc44wgtoiAisTlU9MZQRqYBRpZJR7dX8YOkhAWSJR4+GkS2ApeAUeJ
	5v5+sDingLbEpLePmCA27GaUmHb2EDvEHRYSF5o62CEaBCV+TL4Hto0ZaNvmbU2sELa8xOY1
	b5knMArMQlI2C0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp5Nn0jsYVzVY
	HGIU4GBU4uE9EKURLMSaWFZcmXuIUYKDWUmEV/guUIg3JbGyKrUoP76oNCe1+BBjMjA8JjJL
	iSbnA1NdXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwVqll
	ua84Eij5nfmPp+0Srz++6yTVGjz7Z/iLfYu6e+RltMSlNtNdR/9djm6XCyueLe6wI15lkRCb
	UBWTaZv1BXGrrnv5k79tXGcmaznrTrrt7BLPL84FF/8c6Da6OOd/GkfdUtfpZ0N2qEsHctn4
	v/aZma0RcTgs4R5Xqw7LBV71yd5/nc4qsRRnJBpqMRcVJwIA5su1/msDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 15:26:48 +0100, Tomasz Figa wrote:
> 
> 
> On 18.03.2014 14:01, Cho KyongHo wrote:
> > On Fri, 14 Mar 2014 17:12:03 +0100, Tomasz Figa wrote:
> >> Hi KyongHo,
> >>
> >> On 14.03.2014 06:10, Cho KyongHo wrote:
> >>> Some master device descriptor like fimc-is which is an abstraction
> >>> of very complex H/W may have multiple System MMUs. For those devices,
> >>> the design of the link between System MMU and its master H/W is needed
> >>> to be reconsidered.
> >>>
> >>> A link structure, sysmmu_list_data is introduced that provides a link
> >>> to master H/W and that has a pointer to the device descriptor of a
> >>> System MMU. Given a device descriptor of a master H/W, it is possible
> >>> to traverse all System MMUs that must be controlled along with the
> >>> master H/W.
> >>
> >> NAK.
> >>
> >> A device driver should handle particular hardware instances separately,
> >> without abstracting a virtual hardware instance consisting of multiple
> >> physical ones.
> >>
> >> If such abstraction is needed, it should be done above the exynos-iommu
> >> driver, e.g. by something like iommu-composite driver that would
> >> aggregate several IOMMUs. Keep in mind that such IOMMUs in a group could
> >> be different, e.g. different Exynos SysMMU versions or even completely
> >> different IPs handled by different drivers.
> >>
> >> Still, I don't think there is a real need for such abstraction. Instead,
> >> related drivers shall be fixed to properly handle multiple memory
> >> masters and their IOMMUs.
> >>
> >
> > G2D, Scalers and FIMD of Exynos5420 has 2 System MMUs while aother SoC like
> > Exynos5250 does not.
> >
> > I don't understand why you are negative to this approach.
> > This is the simplest than the others.
> >
> > Let me show you an example.
> > FIMC-IS driver just controls MCU in FIMC-IS subsystem and the firmware of
> > the MCU controls all other peripherals in the subsystem. Each peripherals
> > have their own System MMU. Moreover, the configuration of the peripherals
> > varies according to the SoCs.
> >
> > If System MMU driver accepts multiple masters, everything is done in DT.
> > But I worry that it is not easy if System MMU driver does not support
> > multiple masters.
> 
> I believe I have stated enough reasons why this kind of implementation 
> is bad. I'm not going to waste time repeating myself.
> 
> Your concerns presented above are valid, however they are not related to 
> what is wrong with this patch. I have given you two proper ways to 
> handle this, none should be forced upon particular IOMMU master drivers 
> - their authors should have the chance to select the method that works 
> best for them.
> 

I don't still understand why you think this patch is wrong.
I think this is the best way not to think for all the driver developers
about other things than their business logic.

This does not hurt anyone and I think this is good enough.

If you want to provide another layer between master device and system mmu
as you mentioned, you do that. This patch does not restrict it.

Regards,

KyongHo

