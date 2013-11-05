Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3KES54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:57:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37468 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab3KES5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:57:53 -0500
Date: Tue, 5 Nov 2013 19:57:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 4/4] MCS Lock: Make mcs_spinlock.h includable in other
 files
Message-ID: <20131105185717.GZ16117@laptop.programming.kicks-ass.net>
References: <cover.1383670202.git.tim.c.chen@linux.intel.com>
 <1383673359.11046.280.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383673359.11046.280.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 09:42:39AM -0800, Tim Chen wrote:
> + * The _raw_mcs_spin_lock() function should not be called directly. Instead,
> + * users should call mcs_spin_lock().
>   */
> -static noinline
> -void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
> +static inline
> +void _raw_mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
>  {
>  	struct mcs_spinlock *prev;
>  

So why keep it in the header at all?
