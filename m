Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3FFEnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 00:43:10 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:34124 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3FFEnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 00:43:07 -0400
Date: Wed, 5 Jun 2013 21:43:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] arch: invoke oom-killer from page fault
In-Reply-To: <20130606043620.GA9406@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1306052142490.27104@chino.kir.corp.google.com>
References: <1370488193-4747-1-git-send-email-hannes@cmpxchg.org> <alpine.DEB.2.02.1306052053360.25115@chino.kir.corp.google.com> <20130606043620.GA9406@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jun 2013, Johannes Weiner wrote:

> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: [patch] mm: invoke oom-killer from remaining unconverted page fault
>  handlers
> 
> A few remaining architectures directly kill the page faulting task in
> an out of memory situation.  This is usually not a good idea since
> that task might not even use a significant amount of memory and so may
> not be the optimal victim to resolve the situation.
> 
> Since '1c0fe6e mm: invoke oom-killer from page fault' (2.6.29) there
> is a hook that architecture page fault handlers are supposed to call
> to invoke the OOM killer and let it pick the right task to kill.
> Convert the remaining architectures over to this hook.
> 
> To have the previous behavior of simply taking out the faulting task
> the vm.oom_kill_allocating_task sysctl can be set to 1.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: David Rientjes <rientjes@google.com>
