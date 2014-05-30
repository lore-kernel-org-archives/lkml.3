Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaE3BMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:12:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:63040 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaE3BMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:12:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,937,1392192000"; 
   d="scan'208";a="547047626"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: gleb@kernel.org, pbonzini@redhat.com, eranian@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Implement PEBS virtualization for Silvermont
Date: Thu, 29 May 2014 18:12:03 -0700
Message-Id: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PEBS is very useful (e.g. enabling the more cycles:pp event or
memory profiling) Unfortunately it didn't work in virtualization,
which is becoming more and more common.

This patch kit implements simple PEBS virtualization for KVM on Silvermont
CPUs. Silvermont does not have the leak problems that prevented successfull
PEBS virtualization earlier.

It needs some (simple) modifcations on the host perf code, in addition to 
a PEBS device model in KVM. The guest does not need any modifications.

It also requires running with -cpu host. This may in term cause
some other problems with the guest perf (due to writes to various missing
MSRs), but these can be addressed separately.

For more details please see the description of the individual patches.

Available in
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git perf/kvm-pebs-slm

-Andi
