Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaBFOE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:04:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49402 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaBFOE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:04:58 -0500
Date: Thu, 6 Feb 2014 15:04:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Jason Low <jason.low2@hp.com>, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
Message-ID: <20140206140435.GU8874@twins.programming.kicks-ass.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
 <1390936396-3962-6-git-send-email-jason.low2@hp.com>
 <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
 <1390949495.2807.52.camel@j-VirtualBox>
 <20140129115142.GE9636@twins.programming.kicks-ass.net>
 <52F2B0C2.8040408@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F2B0C2.8040408@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 04:44:34PM -0500, Waiman Long wrote:
> I have an alternative way of breaking out of the MCS lock waiting queue when
> need_resched() is set. I overload the locked flag to indicate a skipped node
> if negative. 

I'm not quite seeing how it works (then again, I've not really read the
patch carefully).

Suppose you break out; at that point you get queued and go to sleep.
Suppose you got woken up while you MCS entry is still 'pending' and
magically win the race and acquire the lock.

At that point your MCS entry can be re-used while its still part of the
list.

Its a fantastically small race window, but I don't see anything that
makes it impossible.

> I run the patch through the AIM7 high-systime workload on a
> 4-socket server and it seemed to run fine.

How do people run this AIM7 piece of shit? I let it run for over an hour
and it generated exactly 0 numbers, it just sits there eating cpu-time
and creating a racket from my pantry.
