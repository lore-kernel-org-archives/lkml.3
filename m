Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3A3IJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:09:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:44589 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab3A3IJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:09:34 -0500
Date: Tue, 29 Jan 2013 23:54:37 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: rjw@sisk.pl, lenb@kernel.org, akpm@linux-foundation.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, guohanjun@huawei.com, yinghai@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [RFC PATCH v2 03/12] drivers/base: Add system device hotplug
 framework
Message-ID: <20130130045437.GG30002@kroah.com>
References: <1357861230-29549-1-git-send-email-toshi.kani@hp.com>
 <1357861230-29549-4-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357861230-29549-4-git-send-email-toshi.kani@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 04:40:21PM -0700, Toshi Kani wrote:
> Added sys_hotplug.c, which is the system device hotplug framework code.
> 
> shp_register_handler() allows modules to register their hotplug handlers
> to the framework.  shp_submit_req() provides the interface to submit
> a hotplug or online/offline request of system devices.  The request is
> then put into hp_workqueue.  shp_start_req() calls all registered handlers
> in ascending order for each phase.  If any handler failed in validate or
> execute phase, shp_start_req() initiates its rollback procedure.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  drivers/base/Makefile      |    1 
>  drivers/base/sys_hotplug.c |  313 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 314 insertions(+)
>  create mode 100644 drivers/base/sys_hotplug.c
> 
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 5aa2d70..2e9b2f1 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -21,6 +21,7 @@ endif
>  obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
>  obj-$(CONFIG_REGMAP)	+= regmap/
>  obj-$(CONFIG_SOC_BUS) += soc.o
> +obj-y			+= sys_hotplug.o

No option to select this for systems that don't need it?  If not, then
put it up higher with all of the other code for the core.

thanks,

greg k-h
