Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaBDQcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:32:16 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:57244 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbaBDQcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:32:14 -0500
Date: Tue, 4 Feb 2014 11:32:10 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH -v2 5/6] memcg, kmem: clean up memcg parameter handling
Message-ID: <20140204163210.GQ6963@cmpxchg.org>
References: <1391520540-17436-1-git-send-email-mhocko@suse.cz>
 <1391520540-17436-6-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391520540-17436-6-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 02:28:59PM +0100, Michal Hocko wrote:
> memcg_kmem_newpage_charge doesn't always set the given memcg parameter.

lol, I really don't get your patch order...

> Some early escape paths skip setting *memcg while
> __memcg_kmem_newpage_charge down the call chain sets *memcg even if no
> memcg is charged due to other escape paths.
> 
> The current code is correct because the memcg is initialized to NULL
> at the highest level in __alloc_pages_nodemask but this all is very
> confusing and error prone. Let's make the semantic clear and move the
> memcg parameter initialization to the highest level of kmem accounting
> (memcg_kmem_newpage_charge).
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Patch looks good, though.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
