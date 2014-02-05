Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaBEHuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 02:50:16 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:52854 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbaBEHuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 02:50:14 -0500
Message-ID: <52F1ED33.9010109@vmware.com>
Date: Wed, 05 Feb 2014 08:50:11 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: vmwgfx: Fix unitialized stack read in vmw_setup_otable_base
References: <20140131022725.GB11601@redhat.com>
In-Reply-To: <20140131022725.GB11601@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 03:27 AM, Dave Jones wrote:
> One of the error paths in vmw_setup_otable_base causes us to return with
> 'ret' having never been set to anything causing us to return whatever was
> on the stack.
>
> Found with Coverity
>
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
>
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
> index 4910e7b81811..d4a5a19cb8c3 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
> @@ -134,6 +134,7 @@ static int vmw_setup_otable_base(struct vmw_private *dev_priv,
>  	cmd = vmw_fifo_reserve(dev_priv, sizeof(*cmd));
>  	if (unlikely(cmd == NULL)) {
>  		DRM_ERROR("Failed reserving FIFO space for OTable setup.\n");
> +		ret = -ENOMEM;
>  		goto out_no_fifo;
>  	}
>  

Thanks,
Will queue on vmwgfx-fixes for -rc2.

/Thomas
