Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3HBTzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:55:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab3HBTzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:55:04 -0400
Date: Fri, 2 Aug 2013 15:53:35 -0400
From: Dave Jones <davej@redhat.com>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH] Add per-process flag to control thp
Message-ID: <20130802195335.GA23255@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mgorman@suse.de>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
	Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
	Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
References: <20130802194659.GP26476@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802194659.GP26476@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 02:46:59PM -0500, Alex Thorlton wrote:

 > diff --git a/include/linux/sched.h b/include/linux/sched.h
 > index 50d04b9..f084c76 100644
 > --- a/include/linux/sched.h
 > +++ b/include/linux/sched.h
 > @@ -1406,6 +1406,9 @@ struct task_struct {
 >  	unsigned int	sequential_io;
 >  	unsigned int	sequential_io_avg;
 >  #endif
 > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 > +	int thp_disabled;
 > +#endif
 >  };

Instead of blowing a whole int on this bool, we could add it
to the bitfield a few pages up where we have other prctl things like..

	unsigned no_new_privs:1;

	Dave

