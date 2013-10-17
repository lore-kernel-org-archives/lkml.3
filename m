Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308Ab3JQRu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:50:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab3JQRu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:50:28 -0400
Date: Thu, 17 Oct 2013 10:50:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd
Message-Id: <20131017105026.451ce2782d573c0b7dfbbc5d@linux-foundation.org>
In-Reply-To: <20131017160726.GJ28963@localhost.localdomain>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com>
	<20131017135509.GB28963@localhost.localdomain>
	<00000141c704b634-d1e47864-686f-40a9-b42e-cd5416dec367-000000@email.amazonses.com>
	<20131017160726.GJ28963@localhost.localdomain>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013 18:07:28 +0200 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Couldn't we instead make kthread children (those created with kthread_create()) to inherit
> kthread initial affinity? Currently kthread's children have cpu_all_mask. We could change
> that behaviour. This way the initial kthread affinity could be inherited all along.

I'm wondering if it's clean/logical to tie usermodehelper affinity to
kthreadd affinity at all.  It's certainly convenient, but they're
distinct concepts.  What is the reason to not have a separate control
for usermodehelper cpus-allowed?
