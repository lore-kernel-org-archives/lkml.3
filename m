Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab3JQPfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:35:22 -0400
Received: from a14-6.smtp-out.amazonses.com ([54.240.14.6]:40186 "EHLO
	a14-6.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756444Ab3JQPfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:35:21 -0400
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Oct 2013 11:35:21 EDT
Date: Thu, 17 Oct 2013 15:24:36 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Mike Galbraith <bitbucket@online.de>, Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd
In-Reply-To: <20131017135509.GB28963@localhost.localdomain>
Message-ID: <00000141c704b634-d1e47864-686f-40a9-b42e-cd5416dec367-000000@email.amazonses.com>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com> <20131017135509.GB28963@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.17-54.240.14.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013, Frederic Weisbecker wrote:

> > -	/* We can run anywhere, unlike our parent keventd(). */
> > -	set_cpus_allowed_ptr(current, cpu_all_mask);
> > +	/* We can run anywhere kthreadd can run */
> > +	set_kthreadd_affinity();
>
> If you really want your isolated CPUs to be undisturbed, you need this affinity to
> be set before the creation of this usermode helper. Otherwise it's going to run to any random
> place before you call the above function.
>
> Is there now way to control the kworker affinity which create this usermode helpers threads
> instead?

The invocation is coming from keventd so the affinity seems to be set to
a different cpu before we get the thread moved.

A tsc loop is running on the processor that gets hit by the usermodehelper spawns.

We see spawning by the tty notifier (when typing on a vt) as well as by a
mellanox driver (periodically).

