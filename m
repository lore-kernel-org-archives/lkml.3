Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbaDKKzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:55:03 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62738 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbaDKKy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:54:56 -0400
Date: Fri, 11 Apr 2014 03:54:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@infradead.org>
cc: Tang Chen <tangchen@cn.fujitsu.com>, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, guz.fnst@cn.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] doc, mempolicy: Fix wrong document in
 numa_memory_policy.txt
In-Reply-To: <5347280B.3000303@infradead.org>
Message-ID: <alpine.DEB.2.02.1404110353440.30610@chino.kir.corp.google.com>
References: <1396410782-26208-1-git-send-email-tangchen@cn.fujitsu.com> <5347280B.3000303@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014, Randy Dunlap wrote:

> On 04/01/2014 08:53 PM, Tang Chen wrote:
> > In document numa_memory_policy.txt, the following examples for flag
> > MPOL_F_RELATIVE_NODES are incorrect.
> > 
> > 	For example, consider a task that is attached to a cpuset with
> > 	mems 2-5 that sets an Interleave policy over the same set with
> > 	MPOL_F_RELATIVE_NODES.  If the cpuset's mems change to 3-7, the
> > 	interleave now occurs over nodes 3,5-6.  If the cpuset's mems
> > 	then change to 0,2-3,5, then the interleave occurs over nodes
> > 	0,3,5.
> > 
> > According to the comment of the patch adding flag MPOL_F_RELATIVE_NODES,
> > the nodemasks the user specifies should be considered relative to the
> > current task's mems_allowed.
> > (https://lkml.org/lkml/2008/2/29/428)
> > 
> > And according to numa_memory_policy.txt, if the user's nodemask includes
> > nodes that are outside the range of the new set of allowed nodes, then
> > the remap wraps around to the beginning of the nodemask and, if not already
> > set, sets the node in the mempolicy nodemask.
> > 
> > So in the example, if the user specifies 2-5, for a task whose mems_allowed
> > is 3-7, the nodemasks should be remapped the third, fourth, fifth, sixth
> > node in mems_allowed.  like the following:
> > 
> > 	mems_allowed:       3  4  5  6  7
> > 
> > 	relative index:     0  1  2  3  4
> > 	                    5
> > 
> > So the nodemasks should be remapped to 3,5-7, but not 3,5-6.
> > 
> > And for a task whose mems_allowed is 0,2-3,5, the nodemasks should be
> > remapped to 0,2-3,5, but not 0,3,5.
> > 
> > 	mems_allowed:       0  2  3  5
> > 
> >         relative index:     0  1  2  3
> >                             4  5
> > 
> > 
> > Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> 
> Wow.  This was not an April fools joke, right?
> 

It would have been a horrible joke if it was intended to be :)

> Have there been any acks of this?  I haven't seen any responses to it.
> 

Because everybody in the phonebook was cc'd on it except for the author 
who wrote it.

Tang, good catch.

Acked-by: David Rientjes <rientjes@google.com>
