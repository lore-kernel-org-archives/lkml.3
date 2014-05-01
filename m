Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaEAOJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:09:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18051 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaEAOI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:08:59 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-68-536255793dcb
Date: Thu, 01 May 2014 23:08:56 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, prathyush.k@samsung.com, grundler@chromium.org,
        joro@8bytes.org, supash.ramaswamy@linaro.org, tomasz.figa@gmail.com,
        joshi@samsung.com, sachin.kamat@linaro.org, s.nawrocki@samsung.com,
        Varun.Sethi@freescale.com, a.motakis@virtualopensystems.com,
        t.figa@samsung.com, rahul.sharma@samsung.com
Subject: Re: [PATCH v12 15/31] iommu/exynos: handle 'mmu-masters' property of
 DT and improve handling sysmmu
Message-id: <20140501230856.3712721d928212c2fff11c43@samsung.com>
In-reply-to: <13595839.WFkdpM5auQ@wuerfel>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
 <1398584283-22846-16-git-send-email-shaik.ameer@samsung.com>
 <13595839.WFkdpM5auQ@wuerfel>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t8zI93K0KRgg8cXVC3u3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2iymL
	DrNaHH7Tzmpx8k8vo8WRh7vZLVqu9zJZrJ/xmsVi1a4/jBYzb61hcRDxeHJwHpPH71+TGD1m
	N1xk8fh3uJ/JY+esu+wed67tYfPYvKTeY/KN5YwefVtWMXp83iTnceXoGaYA7igum5TUnMyy
	1CJ9uwSujH9nN7EUrOaveN7Xy97AeIG7i5GTQ0LARGLH2yYmCFtM4sK99WwgtpDAMkaJqa/c
	YGr6Gi6xdjFyAcUXMUo0H7vACFE0mUni0wkvEJtFQFViyouNLCA2m4CWxOq5x8FqRAQUJaa+
	eMYM0swsMJ9FYu7322BFwgJ5Eud/TwPbxivgKLHy329mEJsTqPnRhMksENuAruh7voAR4gwL
	iQtNHewQDYISPybfAxvEDNSweVsTK4QtL7F5zVuwbRICNzgk9hxqY4Y4T0Di2+RDQA0cQAlZ
	iU0HmCFmSkocXHGDZQKj2CwkY2chGTsLydgFjMyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3
	MUJSxsQdjPcPWB9iTAZaOZFZSjQ5H5hy8kriDY3NjCxMTUyNjcwtzUgTVhLnTX+UFCQkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qB0bt54pZ724t4WqtqeZ95zLkWfub8zzNvJbhvKCw9cU8p
	NnXx0bRljNXzhPYyX9UU3jJPc/HLQFn7Kw/054TU38/m9AiYWXp314asTWfUExyzrvqs4DNc
	WGb2V3ihYZj7OdZ8R6VjrpkOP5v2bJ1QlcU/U2eSkaLC467veWVeC+Tfdxxh0t9jp8RSnJFo
	qMVcVJwIABkBFbYvAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsVy+t9jAd2K0KRggzMzTC3u3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2iymL
	DrNaHH7Tzmpx8k8vo8WRh7vZLVqu9zJZrJ/xmsVi1a4/jBYzb61hcRDxeHJwHpPH71+TGD1m
	N1xk8fh3uJ/JY+esu+wed67tYfPYvKTeY/KN5YwefVtWMXp83iTnceXoGaYA7qgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoCeVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBn/zm5iKVjNX/G8r5e9gfECdxcjJ4eEgIlE
	X8MlVghbTOLCvfVsXYxcHEICixglmo9dYARJCAlMZpL4dMILxGYRUJWY8mIjC4jNJqAlsXru
	cbAaEQFFiakvnjGDNDMLzGeRmPv9NliRsECexPnf09hAbF4BR4mV/34zg9icQM2PJkxmgdi2
	jFGi7/kCRogzLCQuNHWwQzQISvyYfA9sEDNQw+ZtTawQtrzE5jVvmScwCsxCUjYLSdksJGUL
	GJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSnpGdSOxhXNlgcYhTgYFTi4Z3AlhgsxJpY
	VlyZe4hRgoNZSYR3nlpSsBBvSmJlVWpRfnxRaU5q8SHGZGB4TGSWEk3OB6bLvJJ4Q2MTMyNL
	IzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgXHn7yMqLDS5lWkvXdEneaDML
	iJo1Y8YyV9sEV00VGeeuZxw3FPc3BOz+p+6oPrc8KjHbO6lMQPCCdouL0zIB6YkH38RwSK2v
	2BhYGC76fvEkVfNMFc9i7ZjON2fua2x8FFE9yeXORZMvm1bt8jK5HRPS9+v0v75DbhufidhK
	ndzUz1k6JcRJiaU4I9FQi7moOBEAIq2/Eo0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2014 20:17:48 +0200, Arnd Bergmann wrote:
> On Sunday 27 April 2014 13:07:47 Shaik Ameer Basha wrote:
> > @@ -542,14 +592,41 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> >  		}
> >  	}
> >  
> > +	/* Relation between master and System MMU is 1:1. */
> > +	node = of_parse_phandle(dev->of_node, "mmu-masters", 0);
> > +	if (node) {
> > +		struct platform_device *master = of_find_device_by_node(node);
> > +
> > +		if (!master) {
> > +			dev_err(dev, "%s: mmu-master '%s' not found\n",
> > +				__func__, node->name);
> > +			return -EINVAL;
> > +		}
> > +
> > +		if (master->dev.archdata.iommu != NULL) {
> > +			dev_err(dev, "%s: '%s' is master of other MMU\n",
> > +				__func__, node->name);
> > +			return -EINVAL;
> > +		}
> > +
> > +		/*
> > +		 * archdata.iommu will be initialized with exynos_iommu_client
> > +		 * in sysmmu_hook_driver_register().
> > +		 */
> > +		master->dev.archdata.iommu = dev;
> > +	}
> 
> I think parsing of generic properties like this shouldn't be done
> by the individual driver. It belongs into core iommu code and should
> be done when the devices are probed.
> 
> > +
> > +static struct notifier_block sysmmu_notifier = {
> > +	.notifier_call = &sysmmu_hook_driver_register,
> > +};
> > +
> > +static int __init exynos_iommu_prepare(void)
> > +{
> > +	static bool registered = false;
> > +	int ret;
> > +
> > +	if (registered)
> > +		return 0;
> > +
> > +	ret = bus_register_notifier(&platform_bus_type, &sysmmu_notifier);
> > +	if (!ret)
> > +		registered = true;
> > +	else
> > +		pr_err("Failed to register sysmmu_notifier\n");
> > +
> > +	return ret;
> > +}
> 
> This also means we should not have notifiers. Put it into core code to
> make sure all IOMMUs are handled the same way.
> 

Ok.

Thank you for addressing that.
I am also very interested in the discussion about it in the different thread.

KyongHo
