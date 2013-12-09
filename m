Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513Ab3LIVbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:31:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24566 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758864Ab3LIVbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:31:40 -0500
Date: Mon, 9 Dec 2013 16:30:57 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: michaelc@cs.wisc.edu, pjones@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SCSI] iscsi_boot_sysfs: Fix a memory leak in
 iscsi_boot_destroy_kset()
Message-ID: <20131209213057.GA11314@phenom.dumpdata.com>
References: <1386581831-312-1-git-send-email-ethan.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386581831-312-1-git-send-email-ethan.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 05:37:11PM +0800, Ethan Zhao wrote:
> From: "Ethan Zhao" <ethan.kernel@gmail.com>
> 
> Load and unload iscsi_ibft module will cause kernel memory leak, fix it
> in scsi/iscsi_boot_sysfs.c iscsi_boot_destroy_kset().
> 

Is there a stack trace?
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
> -- 
> 1.8.3.4 (Apple Git-47)
> 
