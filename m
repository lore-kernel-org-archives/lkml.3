Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbaLKSGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:06:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758566AbaLKSGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:06:51 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 0/4] xen: auto-generate symbols for xen hypercalls
Date: Thu, 11 Dec 2014 19:04:21 +0100
Message-Id: <1418321065-10212-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Xen hypercalls are defined in include/xen/interface/xen.h. There
are some places where for each hypercall a table element is created.
Instead of manually add each hypercall element to these tables use
an auto generated header built during the make process of the kernel.

Juergen Gross (4):
  xen: build infrastructure for generating hypercall depending symbols
  xen: synchronize include/xen/interface/xen.h with xen
  xen: use generated hypervisor symbols in arch/x86/xen/trace.c
  xen: use generated hypercall symbols in arch/x86/xen/xen-head.S

 arch/x86/syscalls/Makefile  |  9 +++++++
 arch/x86/xen/trace.c        | 50 +++---------------------------------
 arch/x86/xen/xen-head.S     | 62 ++++++++-------------------------------------
 include/xen/interface/xen.h |  6 ++++-
 scripts/xen-hypercalls.sh   | 11 ++++++++
 5 files changed, 39 insertions(+), 99 deletions(-)
 create mode 100644 scripts/xen-hypercalls.sh

-- 
2.1.2

