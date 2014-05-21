Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaEUTTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:19:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbaEUTTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:19:14 -0400
Date: Wed, 21 May 2014 12:19:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] ptrace: task_clear_jobctl_trapping()->wake_up_bit()
 needs mb()
Message-Id: <20140521121912.28188135b8e450cbee62fa27@linux-foundation.org>
In-Reply-To: <20140521092932.GH30445@twins.programming.kicks-ass.net>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
	<1399974350-11089-20-git-send-email-mgorman@suse.de>
	<20140513125313.GR23991@suse.de>
	<20140513141748.GD2485@laptop.programming.kicks-ass.net>
	<20140514161152.GA2615@redhat.com>
	<20140514161755.GQ30445@twins.programming.kicks-ass.net>
	<20140516135116.GA19210@redhat.com>
	<20140516135137.GB19210@redhat.com>
	<20140521092932.GH30445@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014 11:29:32 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, May 16, 2014 at 03:51:37PM +0200, Oleg Nesterov wrote:
> > __wake_up_bit() checks waitqueue_active() and thus the caller needs
> > mb() as wake_up_bit() documents, fix task_clear_jobctl_trapping().
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> Seeing how you are one of the ptrace maintainers, how do you want this
> routed? Does Andrew pick this up, do I stuff it somewhere?

Thanks, I grabbed it.  ptrace has been pretty quiet lately.
