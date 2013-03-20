Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205Ab3CTSqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:46:16 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64131 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab3CTSqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:46:15 -0400
Date: Wed, 20 Mar 2013 11:46:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, hugetlb: include hugepages in meminfo
In-Reply-To: <20130320095306.GA21856@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1303201145260.17761@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1303191714440.13526@chino.kir.corp.google.com> <20130320095306.GA21856@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Mar 2013, Michal Hocko wrote:

> On Tue 19-03-13 17:18:12, David Rientjes wrote:
> > Particularly in oom conditions, it's troublesome that hugetlb memory is 
> > not displayed.  All other meminfo that is emitted will not add up to what 
> > is expected, and there is no artifact left in the kernel log to show that 
> > a potentially significant amount of memory is actually allocated as 
> > hugepages which are not available to be reclaimed.
> 
> Yes, I like the idea. It's bitten me already in the past.
> 
> The only objection I have is that you print only default_hstate. You
> just need to wrap your for_each_node_state by for_each_hstate to do
> that.  With that applied, feel free to add my
> Acked-by: Michal Hocko <mhocko@suse.cz>
> 

I didn't do this because it isn't already exported in /proc/meminfo and 
since we've made an effort to reduce the amount of information emitted by 
the oom killer at oom kill time to avoid spamming the kernel log, I only 
print the default hstate.
