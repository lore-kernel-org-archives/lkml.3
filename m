Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaH1UmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:42:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaH1UmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:42:15 -0400
Message-ID: <53FF9425.6010302@infradead.org>
Date: Thu, 28 Aug 2014 13:42:13 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>, linux-doc@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Peter Foley <pefoley2@pefoley.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] Documentation/video4linux: don't build without CONFIG_VIDEO_V4L2
References: <1409258060-21897-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1409258060-21897-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/14 13:34, Andrey Vagin wrote:
> Otherwise we get warnings:
> WARNING: "vb2_ops_wait_finish" [Documentation//video4linux/v4l2-pci-skeleton.ko] undefined!
> WARNING: "vb2_ops_wait_prepare" [Documentation//video4linux/v4l2-pci-skeleton.ko] undefined!
> ...
> WARNING: "video_unregister_device" [Documentation//video4linux/v4l2-pci-skeleton.ko] undefined!
> 
> Fixes: 8db5ab4b50fb ("Documentation: add makefiles for more targets")
> 
> Cc: Peter Foley <pefoley2@pefoley.com>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  Documentation/video4linux/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/video4linux/Makefile b/Documentation/video4linux/Makefile
> index d58101e..f19f38e 100644
> --- a/Documentation/video4linux/Makefile
> +++ b/Documentation/video4linux/Makefile
> @@ -1 +1,3 @@
> +ifneq ($(CONFIG_VIDEO_V4L2),)
>  obj-m := v4l2-pci-skeleton.o
> +endif
> 

The Kconfig file for this module says:

config VIDEO_PCI_SKELETON
	tristate "Skeleton PCI V4L2 driver"
	depends on PCI && BUILD_DOCSRC
	depends on VIDEO_V4L2 && VIDEOBUF2_CORE && VIDEOBUF2_MEMOPS

so it should already be limited to VIDEO_V4L2 being enabled.

What kernel or linux-next version did you see a problem with?

Please send the failing .config file so that I can check it.

Thanks.

-- 
~Randy
