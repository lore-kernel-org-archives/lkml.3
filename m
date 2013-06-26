Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3FZU7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 16:59:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52205 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3FZU7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 16:59:31 -0400
Message-ID: <51CB5630.6060000@wwwdotorg.org>
Date: Wed, 26 Jun 2013 14:59:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC 4/6] drm: simpledrm: add fbdev fallback support
References: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com> <1372112849-670-5-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1372112849-670-5-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 04:27 PM, David Herrmann wrote:
> Create a simple fbdev device during SimpleDRM setup so legacy user-space
> and fbcon can use it.
> 
> fbdev deletion is quite buggy. A unregister_framebuffer() call followed by
> a printk() causes NULL-derefs in hide_cursor() and other places in the VT
> layer. Hence, we leak the fbdev device currently to make the VT layer
> happy. This needs to be fixed soon! Otherwise, we need a "depends !VT"
> line for SimpleDRM.

> diff --git a/drivers/gpu/drm/simpledrm/Makefile b/drivers/gpu/drm/simpledrm/Makefile

>  simpledrm-y := simpledrm_drv.o simpledrm_main.o simpledrm_mem.o
>  
> +ifdef CONFIG_DRM_SIMPLEDRM_FBDEV
> +	simpledrm-y += simpledrm_fbdev.o
> +endif

I think that's:

+ simpledrm-$(CONFIG_DRM_SIMPLEDRM_FBDEV) += simpledrm_fbdev.o

