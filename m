Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbaCRLDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:03:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30028 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbaCRLDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:03:32 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-8f-532828021869
Date: Tue, 18 Mar 2014 20:03:29 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 15/27] iommu/exynos: use convenient macro to handle
 gate clocks
Message-id: <20140318200329.cc1dca7541b4b1916e5d9d48@samsung.com>
In-reply-to: <CAK9yfHx_=Os1G46nNO1HDA3tigkRNeHKN1KGCvuN=w7dRTkfjg@mail.gmail.com>
References: <20140314140951.3d443a3096e80297c9fecef0@samsung.com>
 <5323078E.4060903@samsung.com>
 <CAK9yfHx_=Os1G46nNO1HDA3tigkRNeHKN1KGCvuN=w7dRTkfjg@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t8zY10mDY1ggwnzBCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mq4vXInc8EigYpPm7ewNTBu4Oli5OSQEDCRWHd7KSuE
	LSZx4d56ti5GLg4hgWWMEjNfX2DsYuQAK/pzXBQiPp1RYvO188wQzmQmiRfXf7CBFLEIqEqc
	W+kDMohNQEti9dzjjCC2CJD9sns5E0g9s8BvFonb+/+wgCSEBSIl9nZ3MIPYvAKOEu+3z2QH
	sTkFgiXm9j9jh1iwklFi/p7VLBDnWUhcaOpgh2gQlPgx+R5YnBlow+ZtTawQtrzE5jVvwa6T
	EFjKIbHt9TSwM1gEBCS+TT7EAvGOrMSmA8wQMyUlDq64wTKBUWwWkrGzkIydhWTsAkbmVYyi
	qQXJBcVJ6UWmesWJucWleel6yfm5mxgh0T5xB+P9A9aHGJOBVk5klhJNzgcmi7ySeENjMyML
	UxNTYyNzSzPShJXEedMfJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYLxw77H2D6+lR5ff
	+X2C3b74+5tpKqI6JW1Mi5kLtsyednlikl2R7myxSWUvSncn/ur4fXhP6Z89CkteBTfl/m4x
	W2e9S+jTl+Nmu2yM38xr1rj5J3PZhdC7C/d8uefz2CFlnUf9h/mL5z+TY74t6PdVMda8rjKI
	X3dthWte3NqlD45ZfXmVa+SvxFKckWioxVxUnAgAdOwDfgwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jQV0mDY1gg6fvuCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcXvlTuaCRQIV
	nzZvYWtg3MDTxcjBISFgIvHnuGgXIyeQKSZx4d56ti5GLg4hgemMEpuvnWeGcCYzSby4/oMN
	pIFFQFXi3EofkAY2AS2J1XOPM4LYIkD2y+7lTCD1zAK/WSRu7//DApIQFoiU2NvdwQxi8wo4
	SrzfPpMdxOYUCJaY2/+MHWLBSkaJ+XtWs0CcYSFxoamDHaJBUOLH5HtgcWagDZu3NbFC2PIS
	m9e8ZZ7AKDALSdksJGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcSp5J72Bc
	1WBxiFGAg1GJh/cFm3qwEGtiWXFl7iFGCQ5mJRHepWoawUK8KYmVValF+fFFpTmpxYcYk4HB
	MZFZSjQ5H5jm8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB
	ccFZNtntS4X/NjhFNiY/a2bnNTBQm3g9OOHml2cvNyhuW7FyqfIVjSKBdQ+7+NSqavosatJk
	bLe//XFrCTN7/Rn+a9Okn8e8U1v3xqlus4SVv6GR18q/ii/krqWaqfGY7Ff5W/A4KGt7kf1V
	O62mBVlikWsYj/8x/vV1k2fY041BHeJl/b0dSizFGYmGWsxFxYkAS5hfn2kDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 22:27:59 +0530, Sachin Kamat wrote:
>  Hi KyongHo,
> 
> On 14 March 2014 19:13, Tomasz Figa <t.figa@samsung.com> wrote:
> > Hi KyongHo,
> >
> >
> > On 14.03.2014 06:09, Cho KyongHo wrote:
> >>
> >> exynos-iommu driver must care about master H/W's gate clock as well as
> >> System MMU's gate clock. To enhance readability of the source code,
> >> macros to gate/ungate those clocks are defined.
> >>
> >> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> >> ---
> >>   drivers/iommu/exynos-iommu.c |   34 ++++++++++++++++++++++------------
> >>   1 file changed, 22 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> >> index 71e77f1..cef62d0 100644
> >> --- a/drivers/iommu/exynos-iommu.c
> >> +++ b/drivers/iommu/exynos-iommu.c
> >> @@ -101,6 +101,16 @@
> >>   #define REG_PB1_SADDR         0x054
> >>   #define REG_PB1_EADDR         0x058
> >>
> >> +#define __clk_gate_ctrl(data, clk, en) do {            \
> >> +               if (data->clk)                          \
> >> +                       clk_##en##able(data->clk);      \
> >> +       } while (0)
> >> +
> >> +#define __sysmmu_clk_enable(data)      __clk_gate_ctrl(data, clk, en)
> >> +#define __sysmmu_clk_disable(data)     __clk_gate_ctrl(data, clk, dis)
> >> +#define __master_clk_enable(data)      __clk_gate_ctrl(data, clk_master,
> >> en)
> >> +#define __master_clk_disable(data)     __clk_gate_ctrl(data, clk_master,
> >> dis)
> >> +
> >
> >
> > I'd say that such macros only obfuscate code, without any gains, as you can
> > see in diffstat - this patch adds more lines than it removes.
> >
> > Please drop this change.
> 
>  I agree with Tomasz here.
> 

Are you concerning about using macros or more insertions than deletions?

The deletions in this patch are only clk_enable() and clk_disable()
but they must be
"if (!IS_ERR(clk)) clk_enable(clk)" and "if (!IS_ERR(clk)) clk_disable(clk)".

I think use of macro is fancier in that case.

Thank you.

KyongHo.
