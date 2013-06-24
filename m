Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3FXBVl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 21:21:41 -0400
Received: from ozlabs.org ([203.10.76.45]:37577 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3FXBVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 21:21:40 -0400
From: Michael Neuling <mikey@neuling.org>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, mahesh@linux.vnet.ibm.com
Subject: Re: [PATCH] powerpc/pseries: Enable PSTORE in pseries_defconfig
In-reply-to: <20130621083639.4039.27789.stgit@aruna-ThinkPad-T420>
References: <20130621083639.4039.27789.stgit@aruna-ThinkPad-T420>
Comments: In-reply-to Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
   message dated "Fri, 21 Jun 2013 14:06:47 +0530."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Mon, 24 Jun 2013 11:21:36 +1000
Message-ID: <7684.1372036896@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Enable PSTORE in pseries_defconfig

Please add a "why" to your changelogs eg. "Now we have pstore support for
nvram on pseries, enable it in the default config"

"Why" you are changing something is more important than "what", since
you can always determine "what" is being changed, by looking at the diff.
The "why" will be long forgotten.

> 
> Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
> ---
>  arch/powerpc/configs/pseries_defconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
> index c4dfbaf..9630a50 100644
> --- a/arch/powerpc/configs/pseries_defconfig
> +++ b/arch/powerpc/configs/pseries_defconfig
> @@ -347,3 +347,4 @@ CONFIG_VIRTUALIZATION=y
>  CONFIG_KVM_BOOK3S_64=m
>  CONFIG_KVM_BOOK3S_64_HV=y
>  CONFIG_VHOST_NET=m
> +CONFIG_PSTORE=y

This should really be added in the right location on the config, not
just at the end.   ie.

@@ -296,6 +293,7 @@
 CONFIG_SQUASHFS_XATTR=y
 CONFIG_SQUASHFS_LZO=y
 CONFIG_SQUASHFS_XZ=y
+CONFIG_PSTORE=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y

