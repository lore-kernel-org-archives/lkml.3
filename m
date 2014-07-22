Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbaGVWGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:06:38 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:56732 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755555AbaGVWGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:06:36 -0400
Date: Tue, 22 Jul 2014 15:06:34 -0700 (PDT)
From: Jakob Bornecrantz <jakob@vmware.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <272182693.34271636.1406066794514.JavaMail.root@vmware.com>
In-Reply-To: <20140722164927.GA21479@redhat.com>
References: <20140722164927.GA21479@redhat.com>
Subject: Re: vmwgfx: remove identical branches
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.163.68]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - GC34 (Linux)/8.0.3_GA_5664)
Thread-Topic: vmwgfx: remove identical branches
Thread-Index: oAS8lXKGC9lNeanwqRjKcJtrKnbjXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> Commit 8b7de6aa8468: "vmwgfx: Rework fence event action" removed the
> tv_sec & tv_usec arguments to vmw_event_fence_action_create, which meant
> that both sides of the if/else are now exactly the same.
> 
> Remove the flag check, and just do it unconditionally.
> 
> Spotted with Coverity.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>

and thanks for the patch.

Cheers, Jakob.

> 
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
> b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
> index 436b013b4231..a078e6bbaf0a 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
> @@ -1124,16 +1124,10 @@ int vmw_fence_event_ioctl(struct drm_device *dev,
> void *data,
>  
>  	BUG_ON(fence == NULL);
>  
> -	if (arg->flags & DRM_VMW_FE_FLAG_REQ_TIME)
> -		ret = vmw_event_fence_action_create(file_priv, fence,
> -						    arg->flags,
> -						    arg->user_data,
> -						    true);
> -	else
> -		ret = vmw_event_fence_action_create(file_priv, fence,
> -						    arg->flags,
> -						    arg->user_data,
> -						    true);
> +	ret = vmw_event_fence_action_create(file_priv, fence,
> +					    arg->flags,
> +					    arg->user_data,
> +					    true);
>  
>  	if (unlikely(ret != 0)) {
>  		if (ret != -ERESTARTSYS)
> 
