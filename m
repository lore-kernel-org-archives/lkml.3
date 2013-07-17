Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab3GQNkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:40:46 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:20502 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab3GQNkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:40:43 -0400
X-IronPort-AV: E=Sophos;i="4.89,684,1367971200"; 
   d="scan'208";a="35705011"
Date: Wed, 17 Jul 2013 14:40:31 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Julien Grall <julien.grall@linaro.org>
CC: <stefano.stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <ian.campbell@citrix.com>, <patches@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xen.org>
Subject: Re: [PATCH] xen/arm: enable PV control for ARM
In-Reply-To: <1373898219-15713-1-git-send-email-julien.grall@linaro.org>
Message-ID: <alpine.DEB.2.02.1307171435000.8258@kaball.uk.xensource.com>
References: <1373898219-15713-1-git-send-email-julien.grall@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013, Julien Grall wrote:
> Enable power management from the toolstack for ARM guest.
> 
> Signed-off-by: Julien Grall <julien.grall@linaro.org>

Considering that now we support both ARM and ARM64, could you please
add an ifneq ($(CONFIG_ARM64),y) too around cpu_hotplug.o, since you are
at it?


>  drivers/xen/Makefile |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 2bf461a..a5f12bd 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -1,9 +1,8 @@
>  ifneq ($(CONFIG_ARM),y)
> -obj-y	+= manage.o
>  obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
>  endif
>  obj-$(CONFIG_X86)			+= fallback.o
> -obj-y	+= grant-table.o features.o events.o balloon.o time.o
> +obj-y	+= grant-table.o features.o events.o balloon.o time.o manage.o
>  obj-y	+= xenbus/
>  
>  nostackp := $(call cc-option, -fno-stack-protector)
> -- 
> 1.7.10.4
> 
