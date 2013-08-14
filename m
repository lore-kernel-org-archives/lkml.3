Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233Ab3HNVNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:13:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760012Ab3HNVM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:12:59 -0400
Date: Wed, 14 Aug 2013 14:12:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v8] mm: make lru_add_drain_all() selective
Message-Id: <20130814141258.6289d9926944245befffa3af@linux-foundation.org>
In-Reply-To: <201308142029.r7EKTMRw023404@farm-0002.internal.tilera.com>
References: <20130814200748.GI28628@htj.dyndns.org>
	<201308142029.r7EKTMRw023404@farm-0002.internal.tilera.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013 16:22:18 -0400 Chris Metcalf <cmetcalf@tilera.com> wrote:

> This change makes lru_add_drain_all() only selectively interrupt
> the cpus that have per-cpu free pages that can be drained.
> 
> This is important in nohz mode where calling mlockall(), for
> example, otherwise will interrupt every core unnecessarily.

Changelog isn't very informative.  I added this:

: This is important on workloads where nohz cores are handling 10 Gb traffic
: in userspace.  Those CPUs do not enter the kernel and place pages into LRU
: pagevecs and they really, really don't want to be interrupted, or they
: drop packets on the floor.

to attempt to describe the rationale for the patch.
