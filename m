Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762424Ab3JQS3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:29:33 -0400
Received: from a14-29.smtp-out.amazonses.com ([54.240.14.29]:58855 "EHLO
	a14-29.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758216Ab3JQS3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:29:32 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Oct 2013 14:29:32 EDT
Date: Thu, 17 Oct 2013 18:23:01 +0000
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
In-Reply-To: <20131017160726.GJ28963@localhost.localdomain>
Message-ID: <00000141c7a80d07-b74ad917-06d0-419a-aac6-ec643e2ccbe2-000000@email.amazonses.com>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com> <20131017135509.GB28963@localhost.localdomain> <00000141c704b634-d1e47864-686f-40a9-b42e-cd5416dec367-000000@email.amazonses.com>
 <20131017160726.GJ28963@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.17-54.240.14.29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013, Frederic Weisbecker wrote:

> > The invocation is coming from keventd so the affinity seems to be set to
> > a different cpu before we get the thread moved.
>
> Looking at alloc_singlethread_workqueue(), it seems to create a kthread by using
> kthread_create(). So I guess the resulting works have the affinity of that kthread.
> And thus call_usermodehelper() initially has that affinity, until it spreads it explicitly
> to all CPUs.
>
> Couldn't we instead make kthread children (those created with kthread_create()) to inherit
> kthread initial affinity? Currently kthread's children have cpu_all_mask. We could change
> that behaviour. This way the initial kthread affinity could be inherited all along.

Some of the code relies on being able to set the affinities separately.
