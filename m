Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3DQE0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 00:26:44 -0400
Received: from intranet.asianux.com ([58.214.24.6]:35152 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3DQE0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 00:26:43 -0400
X-Spam-Score: -100.8
Message-ID: <516E245A.1050400@asianux.com>
Date: Wed, 17 Apr 2013 12:26:02 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel: auditfilter: resource management, need process
 tree when audit_add_watch failed in audit_add_rule
References: <516790ED.6060202@asianux.com> <516792A6.9050904@asianux.com> <5167C36A.5000700@asianux.com> <5167CC21.8090006@asianux.com>
In-Reply-To: <5167CC21.8090006@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  also please help checking this patch, when you have time.

  thanks.

On 2013年04月12日 16:56, Chen Gang wrote:
> 
>   need call audit_put_tree, if tree is valid.
>   just like another area have done in function audit_add_rule.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/auditfilter.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index f9fc54b..81f63f9 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -952,6 +952,12 @@ static inline int audit_add_rule(struct audit_entry *entry)
>  		err = audit_add_watch(&entry->rule, &list);
>  		if (err) {
>  			mutex_unlock(&audit_filter_mutex);
> +			/*
> +			 * normally audit_add_tree_rule() will free it
> +			 * on failure
> +			 */
> +			if (tree)
> +				audit_put_tree(tree);
>  			goto error;
>  		}
>  	}
> 


-- 
Chen Gang

Asianux Corporation
