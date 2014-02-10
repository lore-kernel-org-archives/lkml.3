Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaBJUlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:41:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35706 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbaBJUl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:41:29 -0500
Message-Id: <20140210195820.834693028@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Feb 2014 20:58:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Jason Low <jason.low2@hp.com>, Waiman Long <waiman.long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: [PATCH 0/8] locking/core patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I would propose merging the following patches...

The first set is mostly from Jason and tweaks the mutex adaptive
spinning, AIM7 throughput numbers:

PRE:  100   2000.04  21564.90 2721.29 311.99     3.12       0.01     0.00     99
POST: 100   2000.04  42603.85 5142.80 311.99     3.12       0.00     0.00     99

The second set is the qrwlock, although mostly rewritten by me. I didn't do
much with it other than boot and build a kernel. But I like them because
of the much better worst case preformance.

