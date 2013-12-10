Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276Ab3LJAQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:16:21 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39764 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab3LJAQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:16:17 -0500
Message-ID: <52A65D44.7070007@cs.wisc.edu>
Date: Mon, 09 Dec 2013 18:16:04 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130917 Thunderbird/17.0.9
MIME-Version: 1.0
To: Ethan Zhao <ethan.kernel@gmail.com>
CC: konrad.wilk@oracle.com, pjones@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SCSI] iscsi_boot_sysfs: Fix a memory leak in iscsi_boot_destroy_kset()
References: <1386581831-312-1-git-send-email-ethan.kernel@gmail.com>
In-Reply-To: <1386581831-312-1-git-send-email-ethan.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 03:37 AM, Ethan Zhao wrote:
> From: "Ethan Zhao" <ethan.kernel@gmail.com>
> 
> Load and unload iscsi_ibft module will cause kernel memory leak, fix it
> in scsi/iscsi_boot_sysfs.c iscsi_boot_destroy_kset().
> 
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> ---
>  drivers/scsi/iscsi_boot_sysfs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c
> index 14c1c8f..680bf6f 100644
> --- a/drivers/scsi/iscsi_boot_sysfs.c
> +++ b/drivers/scsi/iscsi_boot_sysfs.c
> @@ -490,5 +490,6 @@ void iscsi_boot_destroy_kset(struct iscsi_boot_kset *boot_kset)
>  		iscsi_boot_remove_kobj(boot_kobj);
>  
>  	kset_unregister(boot_kset->kset);
> +	kfree(boot_kset);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_boot_destroy_kset);

Thanks. Patch looks ok.

It is probably best to just kill the iscsi_boot_kset use and use the
kset directly. To do that, we would need to make kset's list a klist and
add some iterators then modify iscsi_boot_sysfs.c and iscsi_ibft.c to
use them instead of using the iscsi_boot_kset->kobj_list. I will work on
a patch to do this. But for now your patch is ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

