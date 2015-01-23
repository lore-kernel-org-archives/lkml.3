Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbbAWA3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:29:22 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59700 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbbAWA3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:29:19 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: david.vrabel@citrix.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, rostedt@goodmis.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v4 0/2] x86/xen: add xen hypercall preemption
Date: Thu, 22 Jan 2015 16:29:09 -0800
Message-Id: <1421972951-3940-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This v4 addresses some of the cleanups recommended and adds
tracing option for when we do actually preempt a hypercall.
I kept the NOKPROBE_SYMBOL() for now but did remove the 'notrace'
stuff.

This goes out as RFC still as I have not been able to test 32-bit.
Can anyone test that or at least confirm that the 32-bit point
we do the upcall is definitely not on the IRQ stack?

Luis R. Rodriguez (2):
  x86/xen: add xen_is_preemptible_hypercall()
  x86/xen: allow privcmd hypercalls to be preempted

 arch/arm/include/asm/xen/hypercall.h |  5 +++++
 arch/x86/include/asm/xen/hypercall.h | 20 ++++++++++++++++++++
 arch/x86/kernel/entry_32.S           |  2 ++
 arch/x86/kernel/entry_64.S           |  2 ++
 arch/x86/xen/enlighten.c             |  7 +++++++
 arch/x86/xen/xen-head.S              | 18 +++++++++++++++++-
 drivers/xen/events/events_base.c     | 23 +++++++++++++++++++++++
 include/trace/events/xen.h           |  9 +++++++++
 include/xen/events.h                 |  1 +
 9 files changed, 86 insertions(+), 1 deletion(-)

-- 
2.1.1

