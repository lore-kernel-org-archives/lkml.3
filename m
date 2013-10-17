Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762403Ab3JQTXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:23:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762281Ab3JQTXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:23:46 -0400
Date: Thu, 17 Oct 2013 12:23:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd
Message-Id: <20131017122344.39d55db97c3923131bdf2831@linux-foundation.org>
In-Reply-To: <00000141c36b03b6-2f9bd3de-d153-4359-901f-084aeb4c040d-000000@email.amazonses.com>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com>
	<20131016141326.2e517e18e4d8af880c97a282@linux-foundation.org>
	<00000141c36b03b6-2f9bd3de-d153-4359-901f-084aeb4c040d-000000@email.amazonses.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013 22:37:52 +0000 Christoph Lameter <cl@linux.com> wrote:

> > > -	/* We can run anywhere, unlike our parent keventd(). */
> > > -	set_cpus_allowed_ptr(current, cpu_all_mask);
> > > +	/* We can run anywhere kthreadd can run */
> >
> > This is a poor comment - it explains "what" (which was utterly obvious)
> > but doesn't explain "why".  The reader will want to know *why*
> > call_usermodehelper() only runs on kthreadd CPUs, but we didn't tell
> > him.
> 
> We'd like to have the ability to avoid running usermodehelper on certain
> cpus to avoid cpu holdoff situations? Would that we an acceptable
> explanation?
> 
> Or restricting kthreadd will also restrict usermodehelper spawning to
> allow control for all spawned kernel threads?

Both, please ;)
