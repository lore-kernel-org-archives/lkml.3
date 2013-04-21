Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3DUMMD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 08:12:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33948 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3DUMMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 08:12:01 -0400
MIME-Version: 1.0
In-Reply-To: <1365587227-26137-1-git-send-email-ming.lei@canonical.com>
References: <1365587227-26137-1-git-send-email-ming.lei@canonical.com>
Date: Sun, 21 Apr 2013 20:11:58 +0800
Message-ID: <CACVXFVMuUn=0LLWxJO62gp6uugNej-kwC0k_LMGWozGRxcx6Vg@mail.gmail.com>
Subject: Re: [PATCH] of: export of_get_next_parent
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 10, 2013 at 5:47 PM, Ming Lei <ming.lei@canonical.com> wrote:
> The function is called by at least three drivers now:
>
>         pinctrl
>         mfd/vexpress
>         v4l2-core
>
> The 3rd one can be built as module, so export the function to
> avoid build failure.
>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/of/base.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index c6443de..a2a0ddc 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -382,6 +382,7 @@ struct device_node *of_get_next_parent(struct device_node *node)
>         raw_spin_unlock_irqrestore(&devtree_lock, flags);
>         return parent;
>  }
> +EXPORT_SYMBOL(of_get_next_parent);

Gentle ping.

Without the patch, the below build failure is produced every time on -next tree:

  Building modules, stage 2.
  MODPOST 72 modules
ERROR: "of_get_next_parent" [drivers/media/v4l2-core/videodev.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
install kernel and modules


Thanks,
--
Ming Lei
