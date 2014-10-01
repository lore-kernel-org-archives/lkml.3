Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaJAUu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:50:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaJAUu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:50:56 -0400
Date: Wed, 1 Oct 2014 13:50:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, neilb@suse.de,
        sasha.levin@oracle.com, rientjes@google.com, hughd@google.com,
        joe@perches.com, paul.gortmaker@windriver.com,
        liwanp@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com,
        iamjoonsoo.kim@lge.com
Subject: Re: [PATCH] mm: ksm use pr_err instead of printk
Message-Id: <20141001135055.c849d1a34e9c687775a40a0f@linux-foundation.org>
In-Reply-To: <1412195730-9629-1-git-send-email-paulmcquad@gmail.com>
References: <1412195730-9629-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Oct 2014 21:35:30 +0100 Paul McQuade <paulmcquad@gmail.com> wrote:

> WARNING: Prefer: pr_err(...  to printk(KERN_ERR ...
> 
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  mm/ksm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index fb75902..79a26b4 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2310,7 +2310,7 @@ static int __init ksm_init(void)
>  
>  	ksm_thread = kthread_run(ksm_scan_thread, NULL, "ksmd");
>  	if (IS_ERR(ksm_thread)) {
> -		printk(KERN_ERR "ksm: creating kthread failed\n");
> +		pr_err(KERN_ERR "ksm: creating kthread failed\n");
>  		err = PTR_ERR(ksm_thread);
>  		goto out_free;
>  	}
> @@ -2318,7 +2318,7 @@ static int __init ksm_init(void)
>  #ifdef CONFIG_SYSFS
>  	err = sysfs_create_group(mm_kobj, &ksm_attr_group);
>  	if (err) {
> -		printk(KERN_ERR "ksm: register sysfs failed\n");
> +		pr_err(KERN_ERR "ksm: register sysfs failed\n");
>  		kthread_stop(ksm_thread);
>  		goto out_free;
>  	}

err,

--- a/mm/ksm.c~mm-ksm-use-pr_err-instead-of-printk-fix
+++ a/mm/ksm.c
@@ -2310,7 +2310,7 @@ static int __init ksm_init(void)
 
 	ksm_thread = kthread_run(ksm_scan_thread, NULL, "ksmd");
 	if (IS_ERR(ksm_thread)) {
-		pr_err(KERN_ERR "ksm: creating kthread failed\n");
+		pr_err("ksm: creating kthread failed\n");
 		err = PTR_ERR(ksm_thread);
 		goto out_free;
 	}
@@ -2318,7 +2318,7 @@ static int __init ksm_init(void)
 #ifdef CONFIG_SYSFS
 	err = sysfs_create_group(mm_kobj, &ksm_attr_group);
 	if (err) {
-		pr_err(KERN_ERR "ksm: register sysfs failed\n");
+		pr_err("ksm: register sysfs failed\n");
 		kthread_stop(ksm_thread);
 		goto out_free;
 	}


A quick grep indicates that we have the same mistake in tens of places.
checkpatch rule, please?
