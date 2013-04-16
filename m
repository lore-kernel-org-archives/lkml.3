Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab3DPHfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 03:35:52 -0400
Received: from intranet.asianux.com ([58.214.24.6]:24870 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab3DPHfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 03:35:51 -0400
X-Spam-Score: -100.8
Message-ID: <516CFF2C.7010509@asianux.com>
Date: Tue, 16 Apr 2013 15:35:08 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: audit_tree: resource management: need put_tree
 and goto Err when failure occures
References: <516790ED.6060202@asianux.com>
In-Reply-To: <516790ED.6060202@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  oh, sorry, this patch need improving (got --> goto)

  and I should compile, install, running in normal condition, and be
sure of no additional issues occur at least.


On 2013年04月12日 12:43, Chen Gang wrote:
> 
>   since "normally audit_add_tree_rule() will free it on failure",
>   need free it completely, when failure occures.
> 
>     need additional put_tree before return, since get_tree was called.
>     always need goto error processing area for list_del_init.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/audit_tree.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> index 642a89c..3729d49 100644
> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c
> @@ -694,13 +694,15 @@ int audit_add_tree_rule(struct audit_krule *rule)
>  		spin_unlock(&hash_lock);
>  	} else {
>  		trim_marked(tree);
> +		put_tree(tree);
>  		goto Err;
>  	}
>  
>  	mutex_lock(&audit_filter_mutex);
>  	if (list_empty(&rule->rlist)) {
>  		put_tree(tree);
> -		return -ENOENT;
> +		err = -ENOENT;
> +		got Err1;
>  	}
>  	rule->tree = tree;
>  	put_tree(tree);
> @@ -708,6 +710,7 @@ int audit_add_tree_rule(struct audit_krule *rule)
>  	return 0;
>  Err:
>  	mutex_lock(&audit_filter_mutex);
> +Err1:
>  	list_del_init(&tree->list);
>  	list_del_init(&tree->rules);
>  	put_tree(tree);
> 


-- 
Chen Gang

Asianux Corporation
