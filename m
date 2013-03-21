Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3CUSDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:03:50 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62117 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3CUSDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:03:48 -0400
Message-ID: <1363889025.4431.35.camel@edumazet-glaptop>
Subject: Re: +
 atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive .patch
 added to -mm tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>, Shaohua Li <shli@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 11:03:45 -0700
In-Reply-To: <20130321170827.GA23539@redhat.com>
References: <20130314162413.GA21344@redhat.com>
	 <CACVXFVP+fGeWS3xwBfaQDFaH7=e_4CbgCru9DJczB2vyWuUL1g@mail.gmail.com>
	 <20130315134632.GA18335@redhat.com>
	 <CACVXFVOjWc4RU+A-8PeYP9RfJ1-HSiZHbbv771LXDynMs0ybMQ@mail.gmail.com>
	 <20130315165131.GA32065@redhat.com>
	 <20130317172621.GQ3656@linux.vnet.ibm.com>
	 <20130321170827.GA23539@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 18:08 +0100, Oleg Nesterov wrote:

> OK... since nobody volunteered to make a patch, what do you think about
> the change below?
> 
> It should "fix" atomic_add_unless() (only on x86) and optimize
> atomic_inc/dec_unless.
> 
> With this change atomic_*_unless() can do the unnecessary mb() after
> cmpxchg() fails, but I think this case is very unlikely.
> 
> And, in the likely case atomic_inc/dec_unless avoids the 1st cmpxchg()
> which in most cases just reads the memory for the next cmpxchg().
> 
> Oleg.

Hmm, cmpxchg() has different effect on MESI transaction, than a plain
read.

Given there is a single user of atomic_inc_unless_negative(),
(get_write_access(struct inode *inode) )

maybe the 'hint' idea used in atomic_inc_not_zero_hint() could be used.

(The caller might know what is the expected current value, instead of
using atomic_read() and possibly not use appropriate transaction)




