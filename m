Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaBEReT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:34:19 -0500
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:33244 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753018AbaBEReR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:34:17 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3868:3872:3874:4250:4321:5007:6119:7576:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cats11_5f53d1ebd5842
X-Filterd-Recvd-Size: 1757
Message-ID: <1391621653.30094.11.camel@joe-AO722>
Subject: Re: [PATCH 05/22] Add shared printk wrapper for consistent prefixing
From: Joe Perches <joe@perches.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, patches@linaro.org,
        Roy Franz <roy.franz@linaro.org>
Date: Wed, 05 Feb 2014 09:34:13 -0800
In-Reply-To: <1391619853-10601-6-git-send-email-leif.lindholm@linaro.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
	 <1391619853-10601-6-git-send-email-leif.lindholm@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-05 at 17:03 +0000, Leif Lindholm wrote:
> From: Roy Franz <roy.franz@linaro.org>
> 
> Add a wrapper for printk to standardize the prefix for informational and
> error messages from the EFI stub.

trivia:

> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
[]
> @@ -45,6 +45,9 @@ static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
>  	}
>  }
>  
> +#define pr_efi(sys_table, msg)     efi_printk(sys_table, "EFI stub: "msg)
> +#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)

Perhaps it'd be better to use a space after the second "

Also, maybe pr_efi should be pr_efi_info.
That would quiet any checkpatch noise around long msg uses.



