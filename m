Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaDWBP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:15:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64908 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaDWBP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:15:26 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-5c-5357142cb307
Date: Wed, 23 Apr 2014 10:15:24 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Shaik Ameer Basha <shaik.samsung@gmail.com>
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
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 20/27] iommu/exynos: allow having multiple System MMUs
 for a master H/W
Message-id: <20140423101524.4145e9f88300293e0cea92c4@samsung.com>
In-reply-to: <CAOD6ATobD8HCJWXeRgoXYaBBuKxy_TPj_AuWOfdPhJRF=Gxz5w@mail.gmail.com>
References: <20140314141050.c8bedcb66532d277c496796d@samsung.com>
 <CAOD6ATobD8HCJWXeRgoXYaBBuKxy_TPj_AuWOfdPhJRF=Gxz5w@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zvq6OSHiwwYtpNhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6PFup2T2C3Wz3jNYjHz1hoWBwGPJwfnMXnMbrjI4vHvcD+Tx85Zd9k97lzbw+axeUm9x+Qb
	yxk9+rasYvT4vEnO48rRM0wBXFFcNimpOZllqUX6dglcGfvnxBfM0a642f2csYHxuGQXIyeH
	hICJRPvaK0wQtpjEhXvr2boYuTiEBJYxSvzp38rYxcgBVrRmOgdEfBGjxKrjC5khnMlMEjPm
	XWAB6WYRUJV49rWBEcRmE9CSWD33OJgtIqAvceJ+N9gGZoHFrBIfHsuD2MICiRIPP00Ci/MK
	OEpsbT7CDGJzCgRLHFy6iBFiQQejxLT2LcwQ51lIXGjqYIdoEJT4MfkeC8RQLYnN25pYIWx5
	ic1r3oJdJyGwlkNi3ql/bBDXCUh8m3yIBeIdWYlNB6BmSkocXHGDZQKj2CwkY2chGTsLydgF
	jMyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MULif+IOxvsHrA8xJgOtnMgsJZqcD0wfeSXx
	hsZmRhamJqbGRuaWZqQJK4nzpj9KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA6FRjoX2Y
	/c3j4ss5UsmHLLKvNySF7TupEjmZtWdSzum2PRWiQhYazW+WbbS6nfqGTyj9QO6bQxM+K/j4
	rH2u/JOr8En6lMn9hxsC1npdnvS/aONOKQe5VUaB02LOtc2KP7/8F+fdqcG5Gwy0zL5Mnsa1
	aLcAk4W98oPyhcvY83niFh9cmVLbrMRSnJFoqMVcVJwIACIrOCwVAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jAV0dkfBgg76dphZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6PFup2T2C3Wz3jNYjHz1hoWBwGPJwfnMXnMbrjI4vHvcD+Tx85Zd9k97lzbw+axeUm9x+Qb
	yxk9+rasYvT4vEnO48rRM0wBXFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbm
	Sgp5ibmptkouPgG6bpk5QL8oKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnr
	GDP2z4kvmKNdcbP7OWMD43HJLkYODgkBE4k10zm6GDmBTDGJC/fWs3UxcnEICSxilFh1fCEz
	hDOZSWLGvAssIFUsAqoSz742MILYbAJaEqvnHgezRQT0JU7c72YCsZkFFrNKfHgsD2ILCyRK
	PPw0CSzOK+AosbX5CDOIzSkQLHFw6SJGiAUdjBLT2rcwQ5xhIXGhqYMdokFQ4sfkeywQQ7Uk
	Nm9rYoWw5SU2r3nLPIFRYBaSsllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cT
	Izi5PJPewbiqweIQowAHoxIPr8TysGAh1sSy4srcQ4wSHMxKIrwzPwKFeFMSK6tSi/Lji0pz
	UosPMSYDg2Mis5Rocj4w8eWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUI
	ZgsTB6dUA6MrU45b/Gq2kOTAH0nPT37Yz/7UxGKhhqDq6c8fzUI2M390LSpMXx5TUxr8oyf6
	t+67BSlenL2CzRLVJ3o2eQmE3zo/7+ryV2LC/32eKRa0X1I9bGSxWEzgnoRgN6P5h5vtdaYF
	j8zuSVdlMP97unCR9LKynSwtLNLH6+IW1mavUM7Xf8VUo8RSnJFoqMVcVJwIALae5fpyAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 18:53:51 +0530, Shaik Ameer Basha wrote:
> Hi KyongHo Cho,
> 
> 
> 
> On Fri, Mar 14, 2014 at 10:40 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > Some master device descriptor like fimc-is which is an abstraction
> > of very complex H/W may have multiple System MMUs. For those devices,
> > the design of the link between System MMU and its master H/W is needed
> > to be reconsidered.
> >
> > A link structure, sysmmu_list_data is introduced that provides a link
> > to master H/W and that has a pointer to the device descriptor of a
> > System MMU. Given a device descriptor of a master H/W, it is possible
> > to traverse all System MMUs that must be controlled along with the
> > master H/W.
> >
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  drivers/iommu/exynos-iommu.c |  534 ++++++++++++++++++++++++++----------------
> >  1 file changed, 333 insertions(+), 201 deletions(-)
> >
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index 84ba29a..7489343 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -128,6 +128,10 @@
> >  #define __master_clk_disable(data)     __clk_gate_ctrl(data, clk_master, dis)
> >
> 
> [snip]
> 
> > +static int __init __sysmmu_init_master(struct device *dev)
> > +{
> > +       int ret;
> > +       int i = 0;
> > +       struct device_node *node;
> > +
> > +       while ((node = of_parse_phandle(dev->of_node, "mmu-masters", i++))) {
> >                 struct platform_device *master = of_find_device_by_node(node);
> > +               struct exynos_iommu_owner *owner;
> > +               struct sysmmu_list_data *list_data;
> >
> >                 if (!master) {
> >                         dev_err(dev, "%s: mmu-master '%s' not found\n",
> >                                 __func__, node->name);
> > -                       return -EINVAL;
> > +                       ret = -EINVAL;
> > +                       goto err;
> >                 }
> >
> > -               if (master->dev.archdata.iommu != NULL) {
> > -                       dev_err(dev, "%s: '%s' is master of other MMU\n",
> > -                               __func__, node->name);
> > -                       return -EINVAL;
> > +               owner = master->dev.archdata.iommu;
> > +               if (!owner) {
> > +                       owner = devm_kzalloc(dev, sizeof(*owner), GFP_KERNEL);
> > +                       if (!owner) {
> > +                               dev_err(dev,
> > +                               "%s: Failed to allocate owner structure\n",
> > +                               __func__);
> > +                               ret = -ENOMEM;
> > +                               goto err;
> > +                       }
> > +
> > +                       INIT_LIST_HEAD(&owner->mmu_list);
> > +                       INIT_LIST_HEAD(&owner->client);
> > +                       owner->dev = &master->dev;
> > +                       spin_lock_init(&owner->lock);
> > +
> > +                       master->dev.archdata.iommu = owner;
> >                 }
> >
> > +               list_data = devm_kzalloc(dev, sizeof(*list_data), GFP_KERNEL);
> > +               if (!list_data) {
> > +                       dev_err(dev,
> > +                               "%s: Failed to allocate sysmmu_list_data\n",
> > +                               __func__);
> > +                       ret = -ENOMEM;
> > +                       goto err;
> > +               }
> > +
> > +               INIT_LIST_HEAD(&list_data->entry);
> > +               list_data->sysmmu = dev;
> > +
> >                 /*
> > -                * archdata.iommu will be initialized with exynos_iommu_client
> > -                * in sysmmu_hook_driver_register().
> > +                * System MMUs are attached in the order of the presence
> > +                * in device tree
> >                  */
> > -               master->dev.archdata.iommu = dev;
> > +               list_add_tail(&list_data->entry, &owner->mmu_list);
> >         }
> >
> > -       data->sysmmu = dev;
> > -       rwlock_init(&data->lock);
> > +       return 0;
> > +err:
> > +       while ((node = of_parse_phandle(dev->of_node, "mmu-masters", i++))) {
> 
> Don't we need to reinitialize variable 'i' here before using?
> i = 0;
> 

Oh. You are right.

Thanks.

> 
> 
> 
> > +               struct platform_device *master = of_find_device_by_node(node);
> > +               struct exynos_iommu_owner *owner;
> > +               struct sysmmu_list_data *list_data;
> >
> > -       platform_set_drvdata(pdev, data);
> > +               if (!master)
> > +                       continue;
> >
> > -       pm_runtime_enable(dev);
> > -       data->runtime_active = !pm_runtime_enabled(dev);
> > +               owner = master->dev.archdata.iommu;
> > +               if (!owner)
> > +                       continue;
> >
> > -       dev_dbg(dev, "Probed and initialized\n");
> > -       return 0;
> > +               for_each_sysmmu_list(owner->dev, list_data) {
> > +                       if (list_data->sysmmu == dev) {
> > +                               list_del(&list_data->entry);
> > +                               kfree(list_data);
> > +                               break;
> > +                       }
> > +               }
> > +       }
> > +
> > +       return ret;
> >  }
> >
> 
> [snip]
