Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaA1WBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:01:04 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:14360 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaA1WBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:01:02 -0500
Message-ID: <1390946460.2807.19.camel@j-VirtualBox>
Subject: Re: [PATCH v2 1/5] mutex: In mutex_can_spin_on_owner(), return
 false if task need_resched()
From: Jason Low <jason.low2@hp.com>
To: paulmck@linux.vnet.ibm.com
Cc: mingo@redhat.com, peterz@infradead.org, Waiman.Long@hp.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Tue, 28 Jan 2014 14:01:00 -0800
In-Reply-To: <20140128202042.GN9012@linux.vnet.ibm.com>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
	 <1390936396-3962-2-git-send-email-jason.low2@hp.com>
	 <20140128202042.GN9012@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 12:20 -0800, Paul E. McKenney wrote:
> On Tue, Jan 28, 2014 at 11:13:12AM -0800, Jason Low wrote:
> > The mutex_can_spin_on_owner() function should also return false if the
> > task needs to be rescheduled to avoid entering the MCS queue when it
> > needs to reschedule.
> > 
> > Signed-off-by: Jason Low <jason.low2@hp.com>
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> But I cannot help asking how this affects performance.  (My guess is
> "not much", but always good to know.)

Hi Paul,

In the past, when I tested this particular patch, I did not see any
noticeable performance gains. Patch 1 is really more of a "correctness"
change which was why I didn't retest this by itself. I can be sure to
include the benchmarks numbers on this particular patch though next
time.

Thanks.

