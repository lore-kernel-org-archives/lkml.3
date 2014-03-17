Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbaCQN26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:28:58 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:51529 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaCQN25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:28:57 -0400
Date: Mon, 17 Mar 2014 14:28:51 +0100
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <joe@perches.com>, <gang.chen@asianux.com>, <linux390@de.ibm.com>,
        <heiko.carstens@de.ibm.com>, <schwidefsky@de.ibm.com>,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH] s390: correct misuses of module_put in
 appldata_generic_handler.
Message-ID: <20140317142851.50e5f533@thinkpad>
In-Reply-To: <1394890540-2435-1-git-send-email-zhouzhouyi@gmail.com>
References: <1394890540-2435-1-git-send-email-zhouzhouyi@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031713-0542-0000-0000-00000858B42E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Mar 2014 21:35:40 +0800
Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:

> correct misuses of module_put in  appldata_generic_handler

Sorry, I don't see any misuse, could you elaborate?

> 
> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> ---
>  arch/s390/appldata/appldata_base.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
> index 47c8630..683e0282 100644
> --- a/arch/s390/appldata/appldata_base.c
> +++ b/arch/s390/appldata/appldata_base.c
> @@ -343,7 +343,6 @@ appldata_generic_handler(struct ctl_table *ctl, int write,
>  		// protect work queue callback
>  		if (!try_module_get(ops->owner)) {
>  			mutex_unlock(&appldata_ops_mutex);
> -			module_put(ops->owner);
>  			return -ENODEV;
>  		}
>  		ops->callback(ops->data);	// init record
> @@ -354,7 +353,6 @@ appldata_generic_handler(struct ctl_table *ctl, int write,
>  		if (rc != 0) {
>  			pr_err("Starting the data collection for %s "
>  			       "failed with rc=%d\n", ops->name, rc);
> -			module_put(ops->owner);
>  		} else
>  			ops->active = 1;
>  	} else if ((buf[0] == '0') && (ops->active == 1)) {
> @@ -365,7 +363,6 @@ appldata_generic_handler(struct ctl_table *ctl, int write,
>  		if (rc != 0)
>  			pr_err("Stopping the data collection for %s "
>  			       "failed with rc=%d\n", ops->name, rc);
> -		module_put(ops->owner);
>  	}
>  	mutex_unlock(&appldata_ops_mutex);
>  out:

