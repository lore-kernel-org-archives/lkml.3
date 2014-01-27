Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbaA0Xbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:31:37 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:52769 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbaA0Xbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:31:36 -0500
Date: Mon, 27 Jan 2014 15:31:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.14] mm, mempolicy: fix mempolicy printing in
 numa_maps
In-Reply-To: <20140127110330.GH4963@suse.de>
Message-ID: <alpine.DEB.2.02.1401271526010.17114@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1401251902180.3140@chino.kir.corp.google.com> <20140127110330.GH4963@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014, Mel Gorman wrote:

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index c2ccec0..c1a2573 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -120,6 +120,14 @@ static struct mempolicy default_policy = {
>  
>  static struct mempolicy preferred_node_policy[MAX_NUMNODES];
>  
> +/* Returns true if the policy is the default policy */
> +static bool mpol_is_default(struct mempolicy *pol)
> +{
> +	return !pol ||
> +		pol == &default_policy ||
> +		pol == &preferred_node_policy[numa_node_id()];
> +}
> +
>  static struct mempolicy *get_task_policy(struct task_struct *p)
>  {
>  	struct mempolicy *pol = p->mempolicy;

I was trying to avoid doing this because numa_node_id() of process A 
reading numa_maps for process B has nothing to do with the policy of the 
process A and I thought MPOL_F_MORON's purpose was exactly for what it is 
used for today.  It works today since you initialize preferred_node_policy 
for all nodes, but could this ever change to only be valid for N_MEMORY 
node states, for example?

I'm not sure what the harm in updating mpol_to_str() would be if 
MPOL_F_MORON is to change in the future?
