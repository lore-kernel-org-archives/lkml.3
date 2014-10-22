Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaJVRme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:42:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:33367 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbaJVRmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:42:32 -0400
Date: Wed, 22 Oct 2014 14:42:26 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        jmario@redhat.com, rfowles@redhat.com
Subject: Re: perf:  Translating mmap2 ids into socket info?
Message-ID: <20141022174226.GF4160@kernel.org>
References: <20141022162026.GG135937@redhat.com>
 <20141022164510.GJ21513@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022164510.GJ21513@worktop.programming.kicks-ass.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 22, 2014 at 06:45:10PM +0200, Peter Zijlstra escreveu:
> On Wed, Oct 22, 2014 at 12:20:26PM -0400, Don Zickus wrote:
> > Our cache-to-cache tool noticed the slowdown but we couldn't understand
> > why because we had falsely assumed the memory was allocated on the local
> > node but instead it was on the remote node.
 
> But in general, you can never say for user memory, since that has the
> process page table mapping in between, the user virtual address is
> unrelated to backing (and can change frequently and without
> notification).
 
> Therefore the mmap(2) information is useless for this, it only concerns
> user memory.

So what you are saying is that it is difficult to have some sort of
mechanism that an mmap moved from one node to another, when that
happens, i.e. a new tracepoint for that?

- Arnaldo
