Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab3FHXkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 19:40:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34862 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3FHXke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 19:40:34 -0400
Message-ID: <51B3C0EB.2070302@infradead.org>
Date: Sat, 08 Jun 2013 16:40:27 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Markos Chandras <markos.chandras@imgtec.com>
CC: linux-kernel@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH] drivers: Select dependencies for the VIRTUALIZATION symbol
References: <1370604188-19806-1-git-send-email-markos.chandras@imgtec.com>
In-Reply-To: <1370604188-19806-1-git-send-email-markos.chandras@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/13 04:23, Markos Chandras wrote:
> The VIRTUALIZATION symbol depends on HAVE_KVM but CONFIG_REMOTEPROC
> and CONFIG_RPMSG do not select HAVE_KVM leading to the following
> warning and build problems later on:
> 
> warning: (REMOTEPROC && RPMSG) selects VIRTUALIZATION which has unmet
> direct dependencies (HAVE_KVM)
> warning: (REMOTEPROC && RPMSG) selects VIRTUALIZATION which has unmet
> direct dependencies (HAVE_KVM)
> 
> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>

This seems odd.  Usually architectures declare that they HAVE_xyz
and then drivers etc. can use that symbol to do (or not do) something.

See Documentation/kbuild/kconfig-language.txt and search for /HAVE_/.

> ---
>  drivers/remoteproc/Kconfig | 1 +
>  drivers/rpmsg/Kconfig      | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
> index d4d377c..79648ca 100644
> --- a/drivers/remoteproc/Kconfig
> +++ b/drivers/remoteproc/Kconfig
> @@ -6,6 +6,7 @@ config REMOTEPROC
>  	depends on HAS_DMA
>  	select CRC32
>  	select FW_LOADER
> +	select HAVE_KVM
>  	select VIRTIO
>  	select VIRTUALIZATION
>  
> diff --git a/drivers/rpmsg/Kconfig b/drivers/rpmsg/Kconfig
> index 69a2193..3f0bd0f 100644
> --- a/drivers/rpmsg/Kconfig
> +++ b/drivers/rpmsg/Kconfig
> @@ -3,6 +3,7 @@ menu "Rpmsg drivers"
>  # RPMSG always gets selected by whoever wants it
>  config RPMSG
>  	tristate
> +	select HAVE_KVM
>  	select VIRTIO
>  	select VIRTUALIZATION
>  
> 


-- 
~Randy
