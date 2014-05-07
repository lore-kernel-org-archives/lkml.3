Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaEGPWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:22:00 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62527 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaEGPV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:21:29 -0400
MIME-Version: 1.0
In-Reply-To: <536983D0.8090307@gmail.com>
References: <536982E3.10303@gmail.com> <536983D0.8090307@gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 7 May 2014 16:21:09 +0100
X-Google-Sender-Auth: GqUcCWqOTslz4kzVffCXUhzoouY
Message-ID: <CACxGe6tdOytQT5D0ykptya1gaPeMeeJ0a0K4ZvUE9RmRmGMD0g@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] devicetree: provide hook to allow setting
 devicetree device name
To: Frank Rowand <frowand.list@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 1:52 AM, Frank Rowand <frowand.list@gmail.com> wrote:
> From: Frank Rowand <frank.rowand@sonymobile.com>
>
> Optionally push devicetree device naming into a function called dynamically by
> of_device_alloc().
>
> TODO:
>    Change made to of_device_alloc() could also be made to
>    of_amba_device_create()
>
> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
> ---
>  drivers/of/platform.c |    2 ++
>  include/linux/of.h    |    2 ++
>  3 files changed, 43 insertions(+)
>
> Index: b/drivers/of/platform.c
> ===================================================================
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -179,6 +179,8 @@ struct platform_device *of_device_alloc(
>
>         if (bus_id)
>                 dev_set_name(&dev->dev, "%s", bus_id);
> +       else if (np->parent->of_device_make_bus_id)
> +               np->parent->of_device_make_bus_id(&dev->dev);

This isn't dangerous in the way the first patch is, but I don't want
to expose control over the naming scheme outside of the core code. It
would be too easy to get wrong and mess up other drivers. The problem
that is being hit is clearly a bug in the core DT code. It should be
naming devices so that there isn't a conflict. I think Rob's suggested
patch is the best fix.

g.
