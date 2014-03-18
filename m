Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaCRKig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:38:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23402 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbaCRKid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:38:33 -0400
X-AuditID: cbfee68e-b7f566d000002344-ff-532822199282
Date: Tue, 18 Mar 2014 19:38:17 +0900
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
Subject: Re: [PATCH v11 10/27] iommu/exynos: use managed device helper functions
Message-id: <20140318193817.3448387b75e109e814b9c025@samsung.com>
In-reply-to: <53230404.6070601@samsung.com>
References: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
 <53230404.6070601@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zI11JJY1gg/ezLC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mq42DiXteALb8WRVcvZGxg/c3UxcnJICJhIzLvwlgXC
	FpO4cG89WxcjF4eQwDJGiVnTX7F3MXKAFZ3fmAkRX8QocbK1EaxBSGAyk8Sc85ogNouAqsS7
	nzPYQWw2AS2J1XOPM4LYIgIqEpdPTWcEaWYWaGSVeHR/GViRsECAxIuTDWCDeAUcJRb23wWz
	OQW0JVY/e8sIsSBJ4uj1e+wQ11lIXGjqYIeoF5T4MfkeWD0z0LLN25pYIWx5ic1r3jKDLJMQ
	WMoh8XDyAjaI6wQkvk0+xALxjazEpgPMEDMlJQ6uuMEygVFsFpKxs5CMnYVk7AJG5lWMoqkF
	yQXFSelFRnrFibnFpXnpesn5uZsYIbHet4Px5gHrQ4zJQCsnMkuJJucDU0VeSbyhsZmRhamJ
	qbGRuaUZacJK4ryLHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamAM7Pud8Sz8rmDY/yce
	chZvzKWdz2iL1mucvPd89jz93sZYmzUWyY32UhXeCt6+Ce37pjhKymnM5+lYfWf27F+u3R4X
	pR+y8JYe27PiU9nyX+fTt1durPP6a5nP+jl95esnn+7+Z9C5EMz5W3/zTOUJt9V/LuH+8He9
	zLdTxby3l63ct8KUKTNFiaU4I9FQi7moOBEApH0PwQsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jAV1JJY1gg6nnjS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcbFxLmvBF96K
	I6uWszcwfubqYuTgkBAwkTi/MbOLkRPIFJO4cG89WxcjF4eQwCJGiZOtjSwgCSGByUwSc85r
	gtgsAqoS737OYAex2QS0JFbPPc4IYosIqEhcPjWdEaSZWaCRVeLR/WVgRcICARIvTjaADeIV
	cJRY2H8XzOYU0JZY/ewtI8SCJImj1++xQ1xhIXGhqYMdol5Q4sfke2D1zEDLNm9rYoWw5SU2
	r3nLPIFRYBaSsllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIziRPJPewbiq
	weIQowAHoxIP7ws29WAh1sSy4srcQ4wSHMxKIrwnRDSChXhTEiurUovy44tKc1KLDzEmA4Nj
	IrOUaHI+MMnllcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAMj
	74RHE3n9GW+YTd5/4epdheqIZzJS8j8f2qeejHNjt35fpcd5QaNLWS/L5qtcq9bJst1cH7j/
	JIYc+vHxiHCh/Ym4r+W7Ztk7nj6zqYDJIV9A5PsxLp7LDcqrYtp3OW9TDBScUpChWady1/X2
	dh8zAdt5dZk95yrexJp2dL46c0568/2dqz8psRRnJBpqMRcVJwIANcJ5qGgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 14:28:36 +0100, Tomasz Figa wrote:
> Hi KyongHo,
> 
> On 14.03.2014 06:05, Cho KyongHo wrote:
> > This patch uses managed device helper functions in the probe().
> >
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >   drivers/iommu/exynos-iommu.c |   64 +++++++++++++++++-------------------------
> >   1 file changed, 26 insertions(+), 38 deletions(-)
> >
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index 36e6b73..33b424d 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -499,51 +499,48 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
> >
> >   static int exynos_sysmmu_probe(struct platform_device *pdev)
> >   {
> > -	int ret;
> > +	int irq, ret;
> >   	struct device *dev = &pdev->dev;
> >   	struct sysmmu_drvdata *data;
> >   	struct resource *res;
> >
> > -	data = kzalloc(sizeof(*data), GFP_KERNEL);
> > -	if (!data) {
> > -		dev_dbg(dev, "Not enough memory\n");
> > -		ret = -ENOMEM;
> > -		goto err_alloc;
> > -	}
> > +	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
> > +	if (!data)
> > +		return -ENOMEM;
> >
> >   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >   	if (!res) {
> > -		dev_dbg(dev, "Unable to find IOMEM region\n");
> > -		ret = -ENOENT;
> > -		goto err_init;
> > +		dev_err(dev, "Unable to find IOMEM region\n");
> > +		return -ENOENT;
> >   	}
> 
> No need to check for error and print message, because 
> devm_ioremap_resource() already checks the passed resource and handles 
> error cases.
> 

Yes but devm_ioremap_resource() just tells that the given 'res' is not
correct. I think the message in the driver is more informative.

Thanks.

KyongHo
