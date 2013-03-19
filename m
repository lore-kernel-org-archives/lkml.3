Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab3CSHDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 03:03:55 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:47844 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab3CSHDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 03:03:54 -0400
Message-ID: <51480DA7.7000403@linux.vnet.ibm.com>
Date: Tue, 19 Mar 2013 15:03:03 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dong Hao <haodong@linux.vnet.ibm.com>
CC: gregkh@linuxfoundation.org, shangw@linux.vnet.ibm.com,
        weiyang@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] lib/kobject: WARN_ON corresponds to BUG_ON
References: <1363675621-31186-1-git-send-email-haodong@linux.vnet.ibm.com> <1363675621-31186-3-git-send-email-haodong@linux.vnet.ibm.com>
In-Reply-To: <1363675621-31186-3-git-send-email-haodong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031906-9574-0000-0000-000007192465
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 02:47 PM, Dong Hao wrote:
> From: Dong Hao <haodong@linux.vnet.ibm.com>
> 
> WARN_ON corresponds to BUG_ON and also gets more info.

Change the log like this:
like the comments said, double initialize a kobj is wrong
but can be recoverd, using WARN_ON to warn the developer also
it can get more info.

(Or you refine the code by yourself.)

> 
> Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
> ---
>  lib/kobject.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index ff9b3c3..f7d9f31 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -281,7 +281,7 @@ void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
>  		/* do not error out as sometimes we can recover */
>  		printk(KERN_ERR "kobject (%p): tried to init an initialized "
>  		       "object, something is seriously wrong.\n", kobj);
> -		dump_stack();
> +		WARN_ON(1);
>  	}
> 
>  	kobject_init_internal(kobj);
> 

