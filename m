Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbbA0BvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:51:17 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38054 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbbA0BvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:51:13 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: david.vrabel@citrix.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, rostedt@goodmis.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v5 0/2] x86/xen: add xen hypercall preemption
Date: Mon, 26 Jan 2015 17:51:05 -0800
Message-Id: <1422323467-16713-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This v5 nukes tracing as David said it was useless, it also
only adds support for 64-bit as its the only thing I can test,
and slightly modifies the documentation in code as to why we
want this. The no krobe thing is left in place as I haven't
heard confirmation its kosher to remove it.

Luis R. Rodriguez (2):
  x86/xen: add xen_is_preemptible_hypercall()
  x86/xen: allow privcmd hypercalls to be preempted on 64-bit

 arch/arm/include/asm/xen/hypercall.h |  5 +++++
 arch/x86/include/asm/xen/hypercall.h | 20 ++++++++++++++++++++
 arch/x86/kernel/entry_64.S           |  2 ++
 arch/x86/xen/enlighten.c             |  7 +++++++
 arch/x86/xen/xen-head.S              | 18 +++++++++++++++++-
 drivers/xen/events/events_base.c     | 14 ++++++++++++++
 include/xen/events.h                 |  1 +
 7 files changed, 66 insertions(+), 1 deletion(-)

-- 
2.1.1

