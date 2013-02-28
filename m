Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3B1XyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:54:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3B1XyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:54:21 -0500
Date: Thu, 28 Feb 2013 15:54:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Dave Jones <davej@redhat.com>,
        Hillf Danton <dhillf@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] mempolicy: fix typo
Message-Id: <20130228155419.cf412612.akpm@linux-foundation.org>
In-Reply-To: <1362029107-3908-2-git-send-email-kosaki.motohiro@gmail.com>
References: <CAJd=RBBxTutPsF+XPZGt44eT1f0uPAQfCvQj_UmwdDg82J=F+A@mail.gmail.com>
	<1362029107-3908-2-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2013 00:25:07 -0500
kosaki.motohiro@gmail.com wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Currently, n_new is wrongly initialized. start and end parameter
> are inverted. Let's fix it.
> 
> ...
>
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2390,7 +2390,7 @@ static int shared_policy_replace(struct shared_policy *sp, unsigned long start,
>  
>  				*mpol_new = *n->policy;
>  				atomic_set(&mpol_new->refcnt, 1);
> -				sp_node_init(n_new, n->end, end, mpol_new);
> +				sp_node_init(n_new, end, n->end, mpol_new);
>  				n->end = start;
>  				sp_insert(sp, n_new);
>  				n_new = NULL;

huh.  What were the runtime effects of this problem?
