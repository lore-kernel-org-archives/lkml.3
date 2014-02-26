Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaBZVkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:40:08 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:36135 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaBZVkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:40:06 -0500
Date: Wed, 26 Feb 2014 13:40:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Waiman Long <waiman.long@hp.com>, mingo@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 0/8] locking/core patches
Message-ID: <20140226214002.GA5660@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140210195820.834693028@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210195820.834693028@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022621-3532-0000-0000-0000060C5046
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 08:58:20PM +0100, Peter Zijlstra wrote:
> Hi all,
> 
> I would propose merging the following patches...
> 
> The first set is mostly from Jason and tweaks the mutex adaptive
> spinning, AIM7 throughput numbers:
> 
> PRE:  100   2000.04  21564.90 2721.29 311.99     3.12       0.01     0.00     99
> POST: 100   2000.04  42603.85 5142.80 311.99     3.12       0.00     0.00     99
> 
> The second set is the qrwlock, although mostly rewritten by me. I didn't do
> much with it other than boot and build a kernel. But I like them because
> of the much better worst case preformance.

This series passes a short locktorture test when based on top of current
tip/core/locking.

But don't read too much into this...  This was in an 8-CPU KVM guest on
x86, and locktorture is still a bit on the lame side.  But you have to
start somewhere!

							Thanx, Paul

