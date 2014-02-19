Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaBSIvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:51:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49666 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaBSIvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:51:36 -0500
Date: Wed, 19 Feb 2014 09:51:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v4 0/3] qspinlock: Introducing a 4-byte queue spinlock
Message-ID: <20140219085107.GG27965@twins.programming.kicks-ass.net>
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
 <53029167.4060109@zytor.com>
 <20140218073111.GW27965@twins.programming.kicks-ass.net>
 <5303B4C4.2040907@hp.com>
 <20140218212827.GR14089@laptop.programming.kicks-ass.net>
 <5303FDEC.9060001@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5303FDEC.9060001@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 07:42:20PM -0500, Waiman Long wrote:
> On 02/18/2014 04:28 PM, Peter Zijlstra wrote:
> >On Tue, Feb 18, 2014 at 02:30:12PM -0500, Waiman Long wrote:
> >>I will start looking at how to make it work with paravirt. Hopefully, it
> >>won't take too long.
> >The cheap way out is to simply switch to the test-and-set spinlock on
> >whatever X86_FEATURE_ indicates a guest I suppose.
> 
> I don't think there is X86_FEATURE flag that indicates running in a guest.
> In fact, a guest should never find out if it is running virtualized.

No it very much should; how else is paravirt ever going to work?
