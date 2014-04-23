Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbaDWCF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:05:29 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:63010 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbaDWCF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:05:27 -0400
Message-ID: <1398218724.5339.16.camel@marge.simpson.net>
Subject: Re: [Bugfix] sched: fix possible invalid memory access caused by
 CPU hot-addition
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Date: Wed, 23 Apr 2014 04:05:24 +0200
In-Reply-To: <20140422200449.GF11096@twins.programming.kicks-ass.net>
References: <1398144435-26271-1-git-send-email-jiang.liu@linux.intel.com>
	 <20140422081515.GF11182@twins.programming.kicks-ass.net>
	 <20140422130151.83bc4539364ca660c68de859@linux-foundation.org>
	 <20140422200449.GF11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 22:04 +0200, Peter Zijlstra wrote: 
> On Tue, Apr 22, 2014 at 01:01:51PM -0700, Andrew Morton wrote:
> > On Tue, 22 Apr 2014 10:15:15 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Tue, Apr 22, 2014 at 01:27:15PM +0800, Jiang Liu wrote:
> > > > When calling kzalloc_node(size, flags, node), we should first check
> > > > whether node is onlined, otherwise it may cause invalid memory access
> > > > as below.
> > > 
> > > But this is only for memory less node crap, right? 
> > 
> > um, why are memoryless nodes crap?
> 
> Why wouldn't they be? Having CPUs with no local memory seems decidedly
> suboptimal.

This ain't exactly wonderful either, makes CPU domains to crawl over.
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179
node 0 size: 31723 MB
node 0 free: 27949 MB
node 1 cpus: 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149
node 1 size: 32308 MB
node 1 free: 31033 MB
node 2 cpus:
node 2 size: 32768 MB
node 2 free: 16631 MB
node 3 cpus:
node 3 size: 32768 MB
node 3 free: 32640 MB
node 4 cpus:
node 4 size: 32768 MB
node 4 free: 32640 MB
node 5 cpus:
node 5 size: 32768 MB
node 5 free: 32638 MB
node distances:
node   0   1   2   3   4   5 
  0:  10  12  12  15  12  15 
  1:  12  10  15  12  15  15 
  2:  12  15  10  12  15  15 
  3:  15  12  12  10  15  12 
  4:  12  15  15  15  10  12 
  5:  15  15  15  12  12  10


