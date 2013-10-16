Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761218Ab3JPWhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:37:55 -0400
Received: from b232-131.smtp-out.amazonses.com ([199.127.232.131]:37290 "EHLO
	b232-131.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758776Ab3JPWhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:37:54 -0400
Date: Wed, 16 Oct 2013 22:37:52 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd
In-Reply-To: <20131016141326.2e517e18e4d8af880c97a282@linux-foundation.org>
Message-ID: <00000141c36b03b6-2f9bd3de-d153-4359-901f-084aeb4c040d-000000@email.amazonses.com>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com> <20131016141326.2e517e18e4d8af880c97a282@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Andrew Morton wrote:

> > usermodehelper() threads can currently run on all processors.
> > This is an issue for low latency cores.
>
> How much of an issue?  The severity of the problem is utterly unclear
> from this description.

This causes a context switch and processing to occur. Can take up to
microseconds which is a pretty long timeframe when decisions have to be
made in microseconds by active processing. This will cause a trade to
fail.

> > -	/* We can run anywhere, unlike our parent keventd(). */
> > -	set_cpus_allowed_ptr(current, cpu_all_mask);
> > +	/* We can run anywhere kthreadd can run */
>
> This is a poor comment - it explains "what" (which was utterly obvious)
> but doesn't explain "why".  The reader will want to know *why*
> call_usermodehelper() only runs on kthreadd CPUs, but we didn't tell
> him.

We'd like to have the ability to avoid running usermodehelper on certain
cpus to avoid cpu holdoff situations? Would that we an acceptable
explanation?

Or restricting kthreadd will also restrict usermodehelper spawning to
allow control for all spawned kernel threads?



