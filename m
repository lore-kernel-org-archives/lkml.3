Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab3BOQiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:38:20 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38397 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751320Ab3BOQiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:38:18 -0500
Message-ID: <1360946297.2089.6.camel@joe-AO722>
Subject: Re: [PATCH EDAC 13/13] ghes_edac: Improve driver's printk messages
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 15 Feb 2013 08:38:17 -0800
In-Reply-To: <30bb26a76d98f876648020517cd38a4884626f44.1360931635.git.mchehab@redhat.com>
References: <cover.1360931635.git.mchehab@redhat.com>
	 <30bb26a76d98f876648020517cd38a4884626f44.1360931635.git.mchehab@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 10:45 -0200, Mauro Carvalho Chehab wrote:
> Provide a better infrastructure for printk's inside the driver:
> 	- use edac_dbg() for debug messages;
> 	- standardize the usage of pr_info();
> 	- provide warning about the risk of relying on this
> 	  driver.
[]
> diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
[]
> @@ -80,7 +80,8 @@ static void ghes_edac_dmidecode(const struct dmi_header *dh, void *arg)
>  						       dimm_fill->count, 0, 0);
>  
>  		if (entry->size == 0xffff) {
> -			pr_info(GHES_PFX "Can't get dimm size\n");
> +			pr_info(GHES_PFX "Can't get DIMM%i size\n",
> +				dimm_fill->count);

Perhaps these should use
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
and remove GHEX_PFX from all the pr_<level>()'s?


