Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab3FFD5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 23:57:50 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:59918 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab3FFD5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 23:57:48 -0400
Date: Wed, 5 Jun 2013 20:57:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] arch: invoke oom-killer from page fault
In-Reply-To: <1370488193-4747-1-git-send-email-hannes@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1306052053360.25115@chino.kir.corp.google.com>
References: <1370488193-4747-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jun 2013, Johannes Weiner wrote:

> Since '1c0fe6e mm: invoke oom-killer from page fault', page fault
> handlers should not directly kill faulting tasks in an out of memory
> condition.

I have no objection to the patch, but there's no explanation given here 
why exiting with a kill shouldn't be done.  Is it because of memory 
reserves and there is no guarantee that current will be able to exit?  Or 
is it just for consistency with other archs?

> Instead, they should be invoking the OOM killer to pick
> the right task.  Convert the remaining architectures.
> 

If this is a matter of memory reserves, I guess you could point people who 
want the current behavior (avoiding the expensiveness of the tasklist scan 
in the oom killer for example) to /proc/sys/vm/oom_kill_allocating_task?

This changelog is a bit cryptic in its motivation.
