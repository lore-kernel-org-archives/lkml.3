Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaLDHC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 02:02:58 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34639 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaLDHC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 02:02:56 -0500
Date: Wed, 3 Dec 2014 23:02:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        dvyukov@google.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RFC] locking: Add volatile to arch_spinlock_t structures
Message-ID: <20141204070248.GJ25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141204062005.GA2553@linux.vnet.ibm.com>
 <CA+55aFzn-6asfWHB8SAvz4GJWz7uEriujgVLfaqoo_VPtNBLuA@mail.gmail.com>
 <CA+55aFxGCxQNE4HzRP_Uk2FmFDn_+Hfm6GBz75S+5+SDeODVJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxGCxQNE4HzRP_Uk2FmFDn_+Hfm6GBz75S+5+SDeODVJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120407-0005-0000-0000-000006D84BC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 10:40:45PM -0800, Linus Torvalds wrote:
> On Dec 3, 2014 10:31 PM, "Linus Torvalds" <torvalds@linux-foundation.org>
> wrote:
> >
> > So no, no, no. C got this wrong. Volatile data structures are a
> fundamental mistake and a bug.
> 
> BTW, I'm not at all interested in language lawyering and people who say
> "but but we can do x". A compiler that modifies adjacent fields because the
> standard leaves is open is a crap compiler, and we won't use it, or disable
> the broken optimization. It is wrong from a concurrency standpoint anyway,
> and adding broken volatiles is just making things worse.

Understood, for example, adjacent fields protected by different locks
as one example, where adjacent-field overwriting completely breaks even
very conservatively designed code.  Should be entertaining!  ;-)

							Thanx, Paul

