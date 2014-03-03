Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbaCCVvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 16:51:40 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:51946 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaCCVvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:51:39 -0500
Message-ID: <1393883493.30648.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
From: Davidlohr Bueso <davidlohr@hp.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, venki@google.com,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Mar 2014 13:51:33 -0800
In-Reply-To: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-03 at 11:07 -0700, Khalid Aziz wrote:
> I am working on a feature that has been requested by database folks that
> helps with performance. Some of the oft executed database code uses
> mutexes to lock other threads out of a critical section. They often see
> a situation where a thread grabs the mutex, runs out of its timeslice
> and gets switched out which then causes another thread to run which
> tries to grab the same mutex, spins for a while and finally gives up.

This strikes me more of a feature for a real-time kernel. It is
definitely an interesting concept but wonder about it being abused.
Also, what about just using a voluntary preemption model instead? I'd
think that systems where this is really a problem would opt for that.

> This can happen with multiple threads until original lock owner gets the
> CPU again and can complete executing its critical section. This queueing
> and subsequent CPU cycle wastage can be avoided if the locking thread
> could request to be granted an additional timeslice if its current
> timeslice runs out before it gives up the lock. Other operating systems
> have implemented this functionality and is used by databases as well as
> JVM. This functionality has been shown to improve performance by 3%-5%.

Could you elaborate more on those performance numbers? What
benchmark/workload?

Thanks,
Davidlohr

