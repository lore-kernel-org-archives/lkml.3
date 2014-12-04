Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaLDOmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:42:00 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:59086 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbaLDOl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:41:58 -0500
Date: Thu, 4 Dec 2014 06:41:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 9/9] kernel: tighten rules for ACCESS ONCE
Message-ID: <20141204144145.GO25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
 <1417645821-54731-10-git-send-email-borntraeger@de.ibm.com>
 <20141204001621.GF25340@linux.vnet.ibm.com>
 <54802939.8010701@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54802939.8010701@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120414-0025-0000-0000-0000069FD080
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 10:28:25AM +0100, Christian Borntraeger wrote:
> Am 04.12.2014 um 01:16 schrieb Paul E. McKenney:
> >>   * merging, or refetching absolutely anything at any time.  Its main intended
> >> >   * use is to mediate communication between process-level code and irq/NMI
> >> >   * handlers, all running on the same CPU.
> > This comment is obsolete in the same way as that of READ_ONCE() and
> > ASSIGN_ONCE(), but probably more to the point to just get rid of
> > ACCESS_ONCE().  ;-)
> > 
> >> > 
> 
> Its now 
> 
> /*
>  * Prevent the compiler from merging or refetching accesses.  The compiler
>  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
>  * but only when the compiler is aware of some particular ordering.  One way
>  * to make the compiler aware of ordering is to put the two invocations of
>  * ACCESS_ONCE() in different C statements.
>  *
>  * ACCESS_ONCE will only work on scalar types. For union types, ACCESS_ONCE
>  * on a union member will work as long as the size of the member matches the
>  * size of the union and the size is smaller than word size.
>  *
>  * The major use cases of ACCESS_ONCE used to be (1) Mediating communication
>  * between process-level code and irq/NMI handlers, all running on the same CPU,
>  * and (2) Ensuring that the compiler does not  fold, spindle, or otherwise
>  * mutilate accesses that either do not require ordering or that interact
>  * with an explicit memory barrier or atomic instruction that provides the
>  * required ordering.
>  *
>  * If possible use READ_ONCE/ASSIGN_ONCE instead.
>  */

Looks good!

							Thanx, Paul

