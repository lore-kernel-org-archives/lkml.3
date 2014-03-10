Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaCJQCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:02:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53941 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaCJQCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:02:37 -0400
Message-Id: <20140310154236.038181843@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Mar 2014 16:42:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 0/7] locking: qspinlock
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Waiman,

I promised you this series a number of days ago; sorry for the delay I've been
somewhat unwell :/

That said, these few patches start with a (hopefully) simple and correct form
of the queue spinlock, and then gradually build upon it, explaining each
optimization as we go.

Having these optimizations as separate patches helps twofold; firstly it makes
one aware of which exact optimizations were done, and secondly it allows one to
proove or disprove any one step; seeing how they should be mostly identity
transforms.

The resulting code is near to what you posted I think; however it has one
atomic op less in the pending wait-acquire case for NR_CPUS != huge. It also
doesn't do lock stealing; its still perfectly fair afaict.

Have I missed any tricks from your code?

The patches apply to tip/master + lkml.kernel.org/r/20140210195820.834693028@infradead.org

I've yet to look at the paravirt stuff.



