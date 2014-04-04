Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaDDObz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:31:55 -0400
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:34232 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753169AbaDDObx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:31:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3868:4250:4321:4605:5007:7652:9040:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: leg94_8486af860335a
X-Filterd-Recvd-Size: 1906
Message-ID: <1396621909.2863.1.camel@joe-AO722>
Subject: Re: [PATCH 4/5] efi: Add shared printk wrapper for consistent
 prefixing
From: Joe Perches <joe@perches.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, matt.fleming@intel.com,
        linux-kernel@vger.kernel.org, Roy Franz <roy.franz@linaro.org>
Date: Fri, 04 Apr 2014 07:31:49 -0700
In-Reply-To: <1396614350-20889-5-git-send-email-leif.lindholm@linaro.org>
References: <1396614350-20889-1-git-send-email-leif.lindholm@linaro.org>
	 <1396614350-20889-5-git-send-email-leif.lindholm@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 13:25 +0100, Leif Lindholm wrote:
> Add a wrapper for printk to standardize the prefix for informational and
> error messages from the EFI stub.
[]
> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
[]
> @@ -33,6 +33,9 @@ static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
[]
> +#define pr_efi(sys_table, msg)     efi_printk(sys_table, "EFI stub: "msg)
> +#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
[]
> @@ -486,7 +489,7 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
>  				       &new_addr);
>  	}
>  	if (status != EFI_SUCCESS) {
> -		efi_printk(sys_table_arg, "ERROR: Failed to allocate usable memory for kernel.\n");
> +		pr_efi_err(sys_table_arg, "ERROR: Failed to allocate usable memory for kernel.\n");

Author! Author! "ERROR: ERROR:"!

One too many "ERROR:" prefixes.

