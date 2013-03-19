Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3CSN2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:28:19 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:37188 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3CSN2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:28:17 -0400
Date: Tue, 19 Mar 2013 06:29:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: xiaoguangrong@linux.vnet.ibm.com, shangw@linux.vnet.ibm.com,
        weiyang@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] lib/kobject: Panic when kobj or ktype is not
 properly assigned
Message-ID: <20130319132936.GA24313@kroah.com>
References: <1363675621-31186-1-git-send-email-haodong@linux.vnet.ibm.com>
 <1363675621-31186-2-git-send-email-haodong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363675621-31186-2-git-send-email-haodong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 02:47:00PM +0800, Dong Hao wrote:
> From: Dong Hao <haodong@linux.vnet.ibm.com>
> 
> kobj and ktype are two important attributes which will be used after kobject_init(),
> and (!kobj)|(!ktype) may cause FS corruption which could not be recovered.
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

You just crashed the machine.  That's horrible, and unacceptable.

*plonk*
