Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbaGWWc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:32:29 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:23223 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933646AbaGWWc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:32:27 -0400
Message-ID: <1406154742.2488.19.camel@buesod1.americas.hpqcorp.net>
Subject: Re: futex: wake explicit / wait on multiple memory locations
From: Davidlohr Bueso <davidlohr@hp.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@timesys.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Darren Hart <dvhltc@us.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jul 2014 15:32:22 -0700
In-Reply-To: <53CFE1F4.60705@adfin.com>
References: <53CFE1F4.60705@adfin.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-23 at 12:25 -0400, Milosz Tanski wrote:
> I'm using futexes to control scheduling for a userspace application with multiple queues. 
> There's a global work queue and a specific pre-thread queue. And I would like to have a 
> choice between waking up any thread or a specific thread.

I'm afraid not: the api does not have a place for such an argument:

       FUTEX_WAKE
              This operation wakes at most val processes waiting
              on this futex address (i.e., inside FUTEX_WAIT).  
              The arguments timeout, uaddr2 and val3 are ignored.

In any case, when you start with this sort of thing it starts to get
messy, real fast. You have to play games with the number of tasks to
wakeup in a single futex wake call vs the "chosen" task(s).

> Is there are mechanism in the futex API by which I can control which thread to wake up.

Nope. FIFO and rt tasks always in front.

Thanks,
Davidlohr

