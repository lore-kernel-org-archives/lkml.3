Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3GUOy2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 10:54:28 -0400
Received: from smtp.citrix.com ([66.165.176.89]:26110 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab3GUOy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 10:54:27 -0400
X-IronPort-AV: E=Sophos;i="4.89,713,1367971200"; 
   d="scan'208";a="38301975"
Date: Sun, 21 Jul 2013 15:54:24 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Julien Grall <julien.grall@linaro.org>
CC: <stefano.stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <ian.campbell@citrix.com>, <patches@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xen.org>
Subject: Re: [PATCH v2] xen/arm: enable PV control for ARM
In-Reply-To: <1374239399-2498-1-git-send-email-julien.grall@linaro.org>
Message-ID: <alpine.DEB.2.02.1307211535210.4893@kaball.uk.xensource.com>
References: <1374239399-2498-1-git-send-email-julien.grall@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jul 2013, Julien Grall wrote:
> Enable power management from the toolstack for ARM guest.
> 
> Signed-off-by: Julien Grall <julien.grall@linaro.org>
> 
> ---
>     Changes in v2:
>         - Don't compile xen/cpu_hotplug.o with ARM64
> ---
>  drivers/xen/Makefile |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 2bf461a..b550a94 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -1,9 +1,8 @@
> -ifneq ($(CONFIG_ARM),y)
> -obj-y	+= manage.o
> +ifneq ($(filter y, ($CONFIG_ARM) $(CONFIG_ARM64)),y

This is wrong: ifneq is checking for the opposite condition of what we want, and
beside you have the $ in the wrong place for CONFIG_ARM.

Please test you patches before sending them.


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
