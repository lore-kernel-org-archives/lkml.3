Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547AbaICQKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:10:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52908 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbaICQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:10:03 -0400
X-AuditID: cbfee61a-f79e46d00000134f-91-54073d59a91b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Christoph Lameter <cl@linux.com>
Cc: Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org,
        Russell King <rmk+kernel@arm.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: Tree for Sep 1
Date: Wed, 03 Sep 2014 18:09:56 +0200
Message-id: <37101991.sqIYnPZ4ga@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <alpine.DEB.2.11.1409020958530.9608@gentwo.org>
References: <20140901230728.GM29327@sirena.org.uk>
 <alpine.DEB.2.11.1409020857110.9201@gentwo.org>
 <alpine.DEB.2.11.1409020958530.9608@gentwo.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=US-ASCII
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t9jQd1IW/YQg+t7dS2mPnzCZnH92xtG
	i7NNb9gtLu+aw2ZxcGEbo8WnZ//YLTZ/eMlm8Wv5UUYHDo+W5h42j02rOtk87lzbw+bx5Mp0
	Jo++LasYPT5vkgtgi+KySUnNySxLLdK3S+DK6DrQwFxwjKfiUfMx5gbGpVxdjJwcEgImEj0/
	z7BA2GISF+6tZ+ti5OIQEpjOKDFl6mUmCKeFSWLnrwtsIFVsAlYSE9tXMYLYIgIqEmuPvWAH
	KWIWeM8o0X70KhNIQlhAXeLwzDXsIDaLgKrEuuatYCt4BbQk/v28DhYXFfCU2LF9JdhQTgEb
	ieVH37FCbJvGKLFiSxdUg6DEj8n3wGxmAXmJffunskLYWhKbtzWxTmAUmIWkbBaSsllIyhYw
	Mq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7/Z1I7GFc2WBxiFOBgVOLhXRDAFiLEmlhW
	XJl7iFGCg1lJhHeNNHuIEG9KYmVValF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalF
	MFkmDk6pBsZWkX+NH3/9cny3UMGm/srjr1PtwtqypnVcnu9pJpokuiZj9eI/r3vSGoXEp/zm
	vuDGF6DEdCv59sXsNfvLN+8JkUkSmV45O75owqXcwmldj4KmKRmmT6/9orCWS3KncsG0FxeD
	bGYeCDNc2hx+kkfies7PT2FH2OZofPWqPnWq7XiVeuFPk14lluKMREMt5qLiRADk8evnewIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, September 02, 2014 10:00:07 AM Christoph Lameter wrote:
> On Tue, 2 Sep 2014, Christoph Lameter wrote:
> 
> > Oww.. This is double indirection deal there. A percpu offset pointing to
> > a pointer?
> >
> > Generally the following is true (definition from
> > include/asm-generic/percpu.h that is used for ARM for raw_cpu_read):
> >
> > #define raw_cpu_read_4(pcp)             (*raw_cpu_ptr(&(pcp)))
> 
> I think what the issue is that we dropped the fetch of the percpu offset
> in the patch. Instead we are using the address of the variable that
> contains the offset. Does this patch fix it?

Yes, it fixes the problem.  Thank you.

Tested-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> Subject: irqchip: Properly fetch the per cpu offset
> 
> The raw_cpu_read() conversion dropped the fetch of the offset
> from base->percpu_base in gic_get_percpu_base.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/drivers/irqchip/irq-gic.c
> ===================================================================
> --- linux.orig/drivers/irqchip/irq-gic.c
> +++ linux/drivers/irqchip/irq-gic.c
> @@ -102,7 +102,7 @@ static struct gic_chip_data gic_data[MAX
>  #ifdef CONFIG_GIC_NON_BANKED
>  static void __iomem *gic_get_percpu_base(union gic_base *base)
>  {
> -	return raw_cpu_read(base->percpu_base);
> +	return raw_cpu_read(*base->percpu_base);
>  }
> 
>  static void __iomem *gic_get_common_base(union gic_base *base)

