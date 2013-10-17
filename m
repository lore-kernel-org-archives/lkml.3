Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232Ab3JQSY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:24:26 -0400
Received: from a10-51.smtp-out.amazonses.com ([54.240.10.51]:33601 "EHLO
	a10-51.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758657Ab3JQSYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:24:25 -0400
Date: Thu, 17 Oct 2013 18:24:23 +0000
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
In-Reply-To: <20131017105026.451ce2782d573c0b7dfbbc5d@linux-foundation.org>
Message-ID: <00000141c7a94e5e-0f76f304-d0dc-4514-bccd-0cbc9e0a61e9-000000@email.amazonses.com>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com> <20131017135509.GB28963@localhost.localdomain> <00000141c704b634-d1e47864-686f-40a9-b42e-cd5416dec367-000000@email.amazonses.com> <20131017160726.GJ28963@localhost.localdomain>
 <20131017105026.451ce2782d573c0b7dfbbc5d@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.17-54.240.10.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013, Andrew Morton wrote:

> On Thu, 17 Oct 2013 18:07:28 +0200 Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> > Couldn't we instead make kthread children (those created with kthread_create()) to inherit
> > kthread initial affinity? Currently kthread's children have cpu_all_mask. We could change
> > that behaviour. This way the initial kthread affinity could be inherited all along.
>
> I'm wondering if it's clean/logical to tie usermodehelper affinity to
> kthreadd affinity at all.  It's certainly convenient, but they're
> distinct concepts.  What is the reason to not have a separate control
> for usermodehelper cpus-allowed?

It was suggested in the earlier discussion. We could do it separately.

We have to limit kthreadd anyways and the idea was that the setting would
be used to limit any threads spawned that can be limited to a set of
processors.

