Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaJTS76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:59:58 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42410 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbaJTS7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:59:54 -0400
Date: Mon, 20 Oct 2014 14:59:47 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: simplify unreclaimable groups handling in soft
 limit reclaim
Message-ID: <20141020185947.GB11973@phnom.home.cmpxchg.org>
References: <1413820554-15611-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413820554-15611-1-git-send-email-vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 07:55:54PM +0400, Vladimir Davydov wrote:
> If we fail to reclaim anything from a cgroup during a soft reclaim pass
> we want to get the next largest cgroup exceeding its soft limit. To
> achieve this, we should obviously remove the current group from the tree
> and then pick the largest group. Currently we have a weird loop instead.
> Let's simplify it.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

I wonder if there will be anything left once we removed all that which
is pointless and the unnecessary from the memcg code.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
