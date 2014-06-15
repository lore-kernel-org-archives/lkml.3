Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaFONLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:11:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:41540 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaFONLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:11:44 -0400
Message-Id: <20140615124657.264658593@chello.nl>
User-Agent: quilt/0.61-1
Date: Sun, 15 Jun 2014 14:46:57 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 00/11] qspinlock with paravirt support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Waiman seems incapable of doing simple things; here's my take on the
paravirt crap.

The first few patches are taken from Waiman's latest series, but the virt
support is completely new. Its primary aim is to not mess up the native code.

I've not stress tested it, but the virt and paravirt (kvm) cases boot on simple
smp guests. I've not done Xen, but the patch should be simple and similar.

I ripped out all the unfair nonsense as its not at all required for paravirt
and optimizations that make paravirt better at the cost of code clarity and/or
native performance are just not worth it.

Also; if we were to ever add some of that unfair nonsense you do so _after_ you
got the simple things working.

The thing I'm least sure about is the head tracking, I chose to do something
different from what Waiman did, because his is O(nr_cpus) and had the
assumption that guests have small nr_cpus. AFAIK this is not at all true. The
biggest problem I have with what I did is that it contains wait loops itself.



