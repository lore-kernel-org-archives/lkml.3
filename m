Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab3BUAnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 19:43:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab3BUAm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 19:42:59 -0500
Date: Wed, 20 Feb 2013 16:42:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v4] lockdep: check that no locks held at freeze time
Message-Id: <20130220164257.0905dc45.akpm@linux-foundation.org>
In-Reply-To: <CACBanvrdvTW+C2d2-+bC++mJOb8+3qNs2GgY3gf_9EfY+kNPvA@mail.gmail.com>
References: <20130220223013.GA15760@redhat.com>
	<1361402236-28644-1-git-send-email-msb@chromium.org>
	<20130220152446.a65ff84f.akpm@linux-foundation.org>
	<CACBanvr+1VEM6UqfNVx+KiuehZejwqpGp6djPN5kTgYD-umP2g@mail.gmail.com>
	<20130220162015.545ebb6b.akpm@linux-foundation.org>
	<CACBanvrdvTW+C2d2-+bC++mJOb8+3qNs2GgY3gf_9EfY+kNPvA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013 16:28:07 -0800
Mandeep Singh Baines <msb@chromium.org> wrote:

> > Backtraces aren't *that* bad.  We'll easily be able to tell which of
> > the two callsites triggered the trace.
> >
> 
> Let's say there was a try_to_freeze() that got inlined indirectly
> (multiple levels of inline) into do_exit. Wouldn't the backtraces for
> the regular exit check and the try_to_freeze check be identical except
> for the offset (do_exit+0x45 versus do_exit+0x88)? So unless you had
> an object file you wouldn't know which check you hit.

Mutter.  Spose so.  Vaguely possible.  Yes, if we want to avoid a
wont-happen, use __FILE__ and __LINE__.  Or, probably more sanely,
__func__.

Or uninline try_to_freeze().  If anything's calling that at high
frequency, we have a problem.  And given the number of callsites,
getting it into icache might result in a faster kernel...

(Someone needs to teach __might_sleep() about __ratelimit())
