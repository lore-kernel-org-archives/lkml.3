Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab3IYOxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:53:37 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:46580 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756017Ab3IYOxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:53:34 -0400
Date: Wed, 25 Sep 2013 10:53:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 7/7] jump_label: use defined macros instead of
 hard-coding for better readability
Message-ID: <20130925105330.4b717a80@gandalf.local.home>
In-Reply-To: <1380105868-31985-8-git-send-email-liuj97@gmail.com>
References: <1380105868-31985-1-git-send-email-liuj97@gmail.com>
	<1380105868-31985-8-git-send-email-liuj97@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 18:44:27 +0800
Jiang Liu <liuj97@gmail.com> wrote:

> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Use macro JUMP_LABEL_TRUE_BRANCH instead of hard-coding for better
> readability.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Jiang Liu <liuj97@gmail.com>
> ---
>  include/linux/jump_label.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> index a507907..b697fbd 100644
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -116,7 +116,8 @@ extern void static_key_slow_dec(struct static_key *key);
>  extern void jump_label_apply_nops(struct module *mod);
>  
>  #define STATIC_KEY_INIT_TRUE ((struct static_key) \
> -	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
> +	{ .enabled = ATOMIC_INIT(1), \
> +	  .entries = (void *)JUMP_LABEL_TRUE_BRANCH })
>  #define STATIC_KEY_INIT_FALSE ((struct static_key) \
>  	{ .enabled = ATOMIC_INIT(0), .entries = (void *)0 })
>  

Probably should add a comment that there is no
"JUMP_LABEL_FALSE_BRANCH" or maybe we should add one?

-- Steve


