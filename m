Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbbAUOYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:24:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbbAUOYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:24:08 -0500
Date: Wed, 21 Jan 2015 15:24:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: fix uninitialized return value
In-Reply-To: <cf6bea3288dabedfc62ef602720f97e2fa1573ab.1421791634.git.jpoimboe@redhat.com>
Message-ID: <alpine.LNX.2.00.1501211523550.10817@pobox.suse.cz>
References: <cf6bea3288dabedfc62ef602720f97e2fa1573ab.1421791634.git.jpoimboe@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Josh Poimboeuf wrote:

> Fix a potentially uninitialized return value.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>

Applied and pushed out, thanks.

> ---
>  kernel/livepatch/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index bc05d39..9adf86b 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -410,7 +410,7 @@ static int klp_enable_func(struct klp_func *func)
>  
>  	func->state = KLP_ENABLED;
>  
> -	return ret;
> +	return 0;
>  
>  err:
>  	list_del_rcu(&func->stack_node);

-- 
Jiri Kosina
SUSE Labs
