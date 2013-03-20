Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab3CTS6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:58:24 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:47624 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab3CTS6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:58:23 -0400
Date: Wed, 20 Mar 2013 11:58:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, hugetlb: include hugepages in meminfo
In-Reply-To: <20130320185618.GC970@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1303201157120.17761@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1303191714440.13526@chino.kir.corp.google.com> <20130320095306.GA21856@dhcp22.suse.cz> <alpine.DEB.2.02.1303201145260.17761@chino.kir.corp.google.com> <20130320185618.GC970@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Mar 2013, Michal Hocko wrote:

> > I didn't do this because it isn't already exported in /proc/meminfo and 
> > since we've made an effort to reduce the amount of information emitted by 
> > the oom killer at oom kill time to avoid spamming the kernel log, I only 
> > print the default hstate.
> 
> I do not see how this would make the output too much excessive. If
> you do not want to have too many lines in the output then the hstate
> loop can be pushed inside the node loop and have only per-node number
> of lines same as you are proposing except you would have a complete
> information.
> Besides that we are talking about handful of hstates.
> 

Sigh.  Because nobody is going to be mapping non-default hstates and then 
not know about them at oom time; 1GB hugepages on x86 with pse must be 
reserved at boot and never freed, for example.  I'll add them but it's 
just a waste of time.
