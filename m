Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaETJJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:09:33 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64043 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaETJJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:09:31 -0400
MIME-Version: 1.0
In-Reply-To: <537B11C4.2010406@canonical.com>
References: <20140520171351.736fb238@canb.auug.org.au> <537B11C4.2010406@canonical.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 20 May 2014 14:39:10 +0530
Message-ID: <CAO_48GEhZGoY6A9MxuG5u=Nq2OqZ=D-W-npmH=33uMEw2=+vxw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the dma-buf tree
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thierry Reding <treding@nvidia.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 May 2014 13:56, Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:
> Hey,
>
> op 20-05-14 09:13, Stephen Rothwell schreef:
>
>> Hi Sumit,
>>
>> After merging the dma-buf tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> drivers/gpu/drm/tegra/gem.c: In function 'tegra_gem_prime_export':
>> drivers/gpu/drm/tegra/gem.c:423:15: error: macro "dma_buf_export" requires
>> 5 arguments, but only 4 given
>> drivers/gpu/drm/tegra/gem.c:422:9: error: 'dma_buf_export' undeclared
>> (first use in this function)
>>
>> Caused by commit 8dfb1f0f8103 ("dma-buf: use reservation objects").
>> Grep is your friend ...
>>
>> I have use the dma-buf tree from next-20140519 for today.
>
>
> sumits can you amend the commit?
Hey Maarten,
Yes, I'll amend it and push.
> ---
>
> diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
> index bcf9895cef9f..1e9de41a14ea 100644
> --- a/drivers/gpu/drm/tegra/gem.c
> +++ b/drivers/gpu/drm/tegra/gem.c
> @@ -419,7 +419,7 @@ struct dma_buf *tegra_gem_prime_export(struct drm_device
> *drm,
>                                        int flags)
>  {
>         return dma_buf_export(gem, &tegra_gem_prime_dmabuf_ops, gem->size,
> -                             flags);
> +                             flags, NULL);
>  }
>   struct drm_gem_object *tegra_gem_prime_import(struct drm_device *drm,
>



-- 
Thanks and regards,

Sumit Semwal
Graphics Engineer - Graphics working group
Linaro.org │ Open source software for ARM SoCs
