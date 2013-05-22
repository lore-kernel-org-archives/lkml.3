Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3EVVSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:18:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab3EVVST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:18:19 -0400
Date: Wed, 22 May 2013 14:18:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/auditfilter.c: need process 'tree' when
 audit_add_watch() failed in audit_add_rule().
Message-Id: <20130522141818.25520521fe5ebcd5acf61bf5@linux-foundation.org>
In-Reply-To: <518CC80A.3070608@asianux.com>
References: <518CC80A.3070608@asianux.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013 18:12:26 +0800 Chen Gang <gang.chen@asianux.com> wrote:

> 
> If both 'tree' and 'watch' are valid, need call audit_put_tree(), just
> like the upper area has done within function audit_add_rule().
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

Are you sure?  Or is the earlier audit_put_tree(tree) wrong?

Where is the "get" which this "put" is undoing?
