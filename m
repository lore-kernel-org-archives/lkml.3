Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308AbaCSI7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:59:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50441 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191AbaCSI7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:59:31 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-55-53295c70117d
Date: Wed, 19 Mar 2014 17:59:27 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
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
Subject: Re: [PATCH v11 10/27] iommu/exynos: use managed device helper functions
Message-id: <20140319175927.a3feadcacbffe80eca1d3421@samsung.com>
In-reply-to: <532862ED.8040809@samsung.com>
References: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
 <CAK9yfHw7zYaX9EYFE+m3Mh-u8Uiyubx-cS0EwPmfW+0weLiBKw@mail.gmail.com>
 <20140318200915.7dd833ce0fddbbd6ecd8dac9@samsung.com>
 <532862ED.8040809@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zQ92CGM1gg3/fNC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4MpYNGMrW8FEjorfc5exNjB2snUxcnBICJhILFhV1sXI
	CWSKSVy4tx4ozMUhJLCMUeLJ9242iISJxOQDa1khEosYJfrajjNDOJOZJJrmbmEBqWIRUJU4
	9nwKM4jNJqAlsXrucUYQW0RAReLyqemMIA3MAo2sEr9nnGEHSQgLBEi8ONkA1swr4CjxYPU8
	MJtTQFui+eZ/dogNDxklJjxayQRxh4XEhaYOdogGQYkfk++BNTADbdu8rYkVwpaX2LzmLdh5
	EgILOSSm3J/OCnGegMS3yYdYIJ6Wldh0gBlipqTEwRU3WCYwis1CMnYWkrGzkIxdwMi8ilE0
	tSC5oDgpvchQrzgxt7g0L10vOT93EyMk3nt3MN4+YH2IMRlo5URmKdHkfGC6yCuJNzQ2M7Iw
	NTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxo4Vvfla0hnhn/e+
	/my3+8u6pZxpC5flv/Ob1zV9Rhv/RcZJ3RPncB9YM8fj9LbOncvy1u26/sHRSWlB99uXYf/3
	/XDRPvI8+UKFlK61+4yCLyHZ537L3NCe8cP03A7HaTOVW69P/tBbG39r3kspVX+FYGmvtBSt
	ssML7paYPWtMj0g5/KIoqUKJpTgj0VCLuag4EQCZ7VNvDQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsVy+t9jAd2CGM1gg21rVSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsWjGVraCiRwV
	v+cuY21g7GTrYuTkkBAwkZh8YC0rhC0mceHeeqA4F4eQwCJGib6248wQzmQmiaa5W1hAqlgE
	VCWOPZ/CDGKzCWhJrJ57nBHEFhFQkbh8ajojSAOzQCOrxO8ZZ9hBEsICARIvTjaANfMKOEo8
	WD0PzOYU0JZovvmfHWLDQ0aJCY9WMkHcYSFxoamDHaJBUOLH5HtgDcxA2zZva2KFsOUlNq95
	yzyBUWAWkrJZSMpmISlbwMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4nTyT2sG4ssHi
	EKMAB6MSD++BKI1gIdbEsuLK3EOMEhzMSiK8wneBQrwpiZVVqUX58UWlOanFhxiTgeExkVlK
	NDkfmOrySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoFRKnmV
	emh54ZbsQ253fsTviTMQ8nn74aeyzHs9EY4j33iCFm2/+pureurK7p7qxtZr8f3NXf8nzjvx
	78iHqNkHP7/MKZl0Zu6rTT+2BPQd3j/BmnOutPj1INPzvdduZmrJh/cEfsiszbpfI9V4+LNn
	W7qq1GNtA/3TqpUSp75WFm9q+sL6lUVViaU4I9FQi7moOBEAezyxxWsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 16:14:53 +0100, Tomasz Figa wrote:
> On 18.03.2014 12:09, Cho KyongHo wrote:
> > On Fri, 14 Mar 2014 20:52:43 +0530, Sachin Kamat wrote:
> >> Hi KyongHo,
> >>
> >> On 14 March 2014 10:35, Cho KyongHo <pullip.cho@samsung.com> wrote:
> >>> This patch uses managed device helper functions in the probe().
> >>>
> >>> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> >>> ---
> >> [snip]
> >>
> >>> +       data->clk = devm_clk_get(dev, "sysmmu");
> >>> +       if (IS_ERR(data->clk)) {
> >>> +               dev_info(dev, "No gate clock found!\n");
> >>> +               data->clk = NULL;
> >>> +       }
> >>
> >> Why aren't you returning from here upon error?
> >
> > It is for the case of a System MMU which does not need clock gating.
> >
> 
> Are there really such cases?
> 

Yes.
Especially in the case of initial stage of new SoC development.

I have experianced some software workaround for H/W restriction
needs prevention of clock gating for some devices.

Regards,

KyongHo
