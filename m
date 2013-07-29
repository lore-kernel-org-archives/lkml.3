Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab3G2PUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:20:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46298 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab3G2PUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:20:16 -0400
Date: Mon, 29 Jul 2013 17:20:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hillf Danton <dhillf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hugepage related lockdep trace.
Message-ID: <20130729152001.GC22156@laptop.programming.kicks-ass.net>
References: <20130717153223.GD27731@redhat.com>
 <20130718000901.GA31972@blaptop>
 <87hafrdatb.fsf@linux.vnet.ibm.com>
 <20130719001303.GB23354@blaptop>
 <20130723140120.GG8677@dhcp22.suse.cz>
 <20130724024428.GA14795@bbox>
 <20130725133040.GI12818@dhcp22.suse.cz>
 <20130729082453.GB29129@bbox>
 <20130729145308.GG4678@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729145308.GG4678@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 04:53:08PM +0200, Michal Hocko wrote:
> Peter, for you context the lockdep splat has been reported
> here: https://lkml.org/lkml/2013/7/17/381
> 
> Minchan has proposed to workaround it by using SINGLE_DEPTH_NESTING
> https://lkml.org/lkml/2013/7/23/812
> 
> my idea was to use a separate class key for hugetlb as it is quite
> special in many ways:
> https://lkml.org/lkml/2013/7/25/277
> 
> What is the preferred way of fixing such an issue?

The class is the safer annotation.

That said; it is a rather horrible issue any which way. This PMD sharing
is very unique to hugetlbfs (also is that really worth the effort these
days?) and it will make it impossible to make hugetlbfs swappable.

The other solution is to make the pmd allocation GFP_NOFS.
