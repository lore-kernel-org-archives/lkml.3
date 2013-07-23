Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3GWLfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:35:46 -0400
Received: from smtp.citrix.com ([66.165.176.89]:48364 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254Ab3GWLfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:35:45 -0400
X-IronPort-AV: E=Sophos;i="4.89,727,1367971200"; 
   d="scan'208";a="38669144"
Date: Tue, 23 Jul 2013 12:35:40 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Julien Grall <julien.grall@linaro.org>
CC: <stefano.stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <ian.campbell@citrix.com>, <patches@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xen.org>, <mark.rutland@arm.com>,
        <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] xen/arm64: Don't compile cpu hotplug
In-Reply-To: <1374529258-12866-1-git-send-email-julien.grall@linaro.org>
Message-ID: <alpine.DEB.2.02.1307231235330.4893@kaball.uk.xensource.com>
References: <1374529258-12866-1-git-send-email-julien.grall@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Julien Grall wrote:
> On ARM64, when CONFIG_XEN=y, the compilation will fail because CPU hotplug is
> not yet supported with XEN. For now, disable it.
> 
> Signed-off-by: Julien Grall <julien.grall@linaro.org>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  drivers/xen/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 2bf461a..a609353 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -1,4 +1,4 @@
> -ifneq ($(CONFIG_ARM),y)
> +ifeq ($(filter y, $(CONFIG_ARM) $(CONFIG_ARM64)),)
>  obj-y	+= manage.o
>  obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
>  endif
> -- 
> 1.7.10.4
> 
