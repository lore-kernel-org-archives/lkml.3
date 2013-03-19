Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab3CSG7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:59:49 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:60939 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab3CSG7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:59:47 -0400
Message-ID: <51480C99.8090206@linux.vnet.ibm.com>
Date: Tue, 19 Mar 2013 14:58:33 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dong Hao <haodong@linux.vnet.ibm.com>
CC: gregkh@linuxfoundation.org, shangw@linux.vnet.ibm.com,
        weiyang@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] lib/kobject: Panic when kobj or ktype is not properly
 assigned
References: <1363675621-31186-1-git-send-email-haodong@linux.vnet.ibm.com> <1363675621-31186-2-git-send-email-haodong@linux.vnet.ibm.com>
In-Reply-To: <1363675621-31186-2-git-send-email-haodong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 13031906-0260-0000-0000-000002B00A14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 02:47 PM, Dong Hao wrote:
> From: Dong Hao <haodong@linux.vnet.ibm.com>
> 
> kobj and ktype are two important attributes which will be used after kobject_init(),

> and (!kobj)|(!ktype) may cause FS corruption which could not be recovered.

delete this line, i am not very convinced about corruption  ...

> Panic instead of dump_stack() when neither kobj nor ktype is properly assigned to
> detect the bug early.
> 
> Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
> ---
>  lib/kobject.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 279a172..ff9b3c3 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -290,7 +290,7 @@ void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
> 
>  error:
>  	printk(KERN_ERR "kobject (%p): %s\n", kobj, err_str);
> -	dump_stack();
> +	BUG_ON(1);
>  }
>  EXPORT_SYMBOL(kobject_init);
> 

