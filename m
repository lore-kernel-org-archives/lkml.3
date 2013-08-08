Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab3HHDtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 23:49:45 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64827 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab3HHDto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 23:49:44 -0400
Date: Wed, 7 Aug 2013 20:49:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Thorlton <athorlton@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCHv2] Add per-process flag to control thp
In-Reply-To: <20130806150807.GA2456@sgi.com>
Message-ID: <alpine.DEB.2.02.1308072046560.28256@chino.kir.corp.google.com>
References: <20130802205735.GS26476@sgi.com> <20130805160306.a620c88ba9098b98a0f93665@linux-foundation.org> <20130806150807.GA2456@sgi.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Aug 2013, Alex Thorlton wrote:

> I've gotten my hands on some of the benchmarks/code that were used to
> originally uncover the performance issues we're seeing.  I'm currently
> trying to separate out the performance issues that are being caused by
> the kernel code from issues involving hardware - the cost of remote
> memory accesses is a bit higher on our systems with node controllers vs.
> glueless QPI/Hypertransport-based systems.  
> 

We've seen some issues where accessing remote hugepages causes performance 
degradations over accessing local pages that affects some workloads, but 
that seems like a mempolicy issue rather than madvise.  You probably want 
local hugepages but not fallback to remote hugepages before allocating 
local pages?  It would be interesting to see /proc/pid/numa_maps and 
/proc/pid/smaps for workloads that don't like thp.
