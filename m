Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbaDPVe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:34:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643AbaDPVe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:34:26 -0400
Date: Wed, 16 Apr 2014 14:34:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: remove hierarchy restrictions for
 swappiness and oom_control
Message-Id: <20140416143425.c2b6f511cf4c6cd7336134b3@linux-foundation.org>
In-Reply-To: <1397682798-22906-1-git-send-email-hannes@cmpxchg.org>
References: <1397682798-22906-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014 17:13:18 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Per-memcg swappiness and oom killing can currently not be tweaked on a
> memcg that is part of a hierarchy, but not the root of that hierarchy.
> Users have complained that they can't configure this when they turned
> on hierarchy mode.  In fact, with hierarchy mode becoming the default,
> this restriction disables the tunables entirely.
> 
> But there is no good reason for this restriction.  The settings for
> swappiness and OOM killing are taken from whatever memcg whose limit
> triggered reclaim and OOM invocation, regardless of its position in
> the hierarchy tree.
> 
> Allow setting swappiness on any group.  The knob on the root memcg
> already reads the global VM swappiness, make it writable as well.
> 
> Allow disabling the OOM killer on any non-root memcg.

Documentation/cgroups/memory.txt needs updates?
