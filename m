Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945915Ab3BHEgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 23:36:50 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:50403 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902Ab3BHEgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 23:36:49 -0500
Date: Thu, 7 Feb 2013 20:36:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michel Lespinasse <walken@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org
Subject: Re: [RFC PATCH 1/6] kernel: implement queue spinlock API
Message-ID: <20130208043643.GN2545@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1358896415-28569-1-git-send-email-walken@google.com>
 <1358896415-28569-2-git-send-email-walken@google.com>
 <20130207223434.GG2545@linux.vnet.ibm.com>
 <1360277809.28557.60.camel@edumazet-glaptop>
 <CANN689G0N0ynSMVcH9CbOFgL_mLSswOBx5yBzPBag0AO9fk8+A@mail.gmail.com>
 <1360281834.28557.73.camel@edumazet-glaptop>
 <20130208004023.GM2545@linux.vnet.ibm.com>
 <CANN689EUBav=9LkC0s4+teQirGhymgvRxaHRcnK7brjwDU28FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689EUBav=9LkC0s4+teQirGhymgvRxaHRcnK7brjwDU28FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020804-5518-0000-0000-00000B63735E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 07:48:33PM -0800, Michel Lespinasse wrote:
> On Thu, Feb 7, 2013 at 4:40 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Feb 07, 2013 at 04:03:54PM -0800, Eric Dumazet wrote:
> >> It adds yet another memory write to store the node pointer in the
> >> lock...
> >>
> >> I suspect it's going to increase false sharing.
> >
> > On the other hand, compared to straight MCS, it reduces the need to
> > pass the node address around.  Furthermore, the node pointer is likely
> > to be in the same cache line as the lock word itself, and finally
> > some architectures can do a double-pointer store.
> >
> > Of course, it might well be slower, but it seems like it is worth
> > giving it a try.
> 
> Right. Another nice point about this approach is that there needs to
> be only one node per spinning CPU, so the node pointers (both tail and
> next) might be replaced with CPU identifiers, which would bring the
> spinlock size down to the same as with the ticket spinlock (which in
> turns makes it that much more likely that we'll have atomic stores of
> that size).

Good point!  I must admit that this is one advantage of having the
various _irq spinlock acquisition primitives disable irqs before
spinning.  ;-)

							Thanx, Paul

