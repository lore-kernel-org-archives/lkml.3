Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaCZEVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 00:21:46 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:63963 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaCZEVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 00:21:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140324225802.GG17218@mithrandir>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
	<1395650554-31925-9-git-send-email-acourbot@nvidia.com>
	<20140324225802.GG17218@mithrandir>
Date: Wed, 26 Mar 2014 14:21:43 +1000
Message-ID: <CACAvsv5yEbMWZnxgyhmY1r3Kp9PU8vXg2BcT4ZMJe7Ti9cHBUw@mail.gmail.com>
Subject: Re: [PATCH 08/12] drm/nouveau/graph: enable when using external firmware
From: Ben Skeggs <skeggsb@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 8:58 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Mar 24, 2014 at 05:42:30PM +0900, Alexandre Courbot wrote:
> [...]
>> diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
>> index 6ef8bf181b2d..f997a18f5760 100644
>> --- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
>> +++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
>> @@ -1133,10 +1133,14 @@ nvc0_graph_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
>>       struct nvc0_graph_oclass *oclass = (void *)bclass;
>>       struct nouveau_device *device = nv_device(parent);
>>       struct nvc0_graph_priv *priv;
>> +     bool use_fw;
>
> Perhaps "ext_fw" or "use_ext_fw" would be more accurate.
>
>>       int ret, i;
>>
>> +     use_fw = nouveau_boolopt(device->cfgopt, "NvGrUseFW", false);
>> +
>>       ret = nouveau_graph_create(parent, engine, bclass,
>> -                                (oclass->fecs.ucode != NULL), &priv);
>> +                                (oclass->fecs.ucode != NULL) || use_fw,
>> +                                &priv);
>
> Or perhaps a more intuitive way would be to name the variable "enable"
> and have something like:
>
>         if (!nouveau_boolopt(device->cfgopt, "NvGrUseFW", false))
>                 enable = oclass->fecs.ucode != NULL;
>         else
>                 enable = true;
>
>         ret = nouveau_graph_create(parent, engine, bclass, enable, &priv);
>         ...
Agreed, this looks a lot nicer.

>
> Thierry
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
