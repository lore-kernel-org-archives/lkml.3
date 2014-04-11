Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbaDKKQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:16:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39399 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbaDKKQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:16:20 -0400
Subject: [PATCH 0/3] ppc:Set runlatch bits correctly for offline threads and
 vcpus
To: linuxppc-dev@ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Fri, 11 Apr 2014 15:41:25 +0530
Message-ID: <20140411101035.24827.17887.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041110-8236-0000-0000-000001742C95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The runlatch bits with their value indicated by CTRL_RUNLATCH are set and
cleared in the SPRN_CTRL registers to indicate a busy and idle cpu
respectively. This is currently being done in the cpuidle path of the host.
But needs to be taken care of in hotplug and kvm scenarios. This patchset
is aimed at ensuring that the runlatch bits are consisten with the
utilization of a CPU under all circumstances.
---

Preeti U Murthy (3):
      ppc/powernv: Set the runlatch bits correctly for offline cpus
      ppc/kvm: Set the runlatch bit of a CPU just before starting guest
      ppc/kvm: Clear the runlatch bit of a vcpu before napping


 arch/powerpc/kvm/book3s_hv_rmhandlers.S |   18 +++++++++++++++++-
 arch/powerpc/platforms/powernv/smp.c    |    3 +++
 2 files changed, 20 insertions(+), 1 deletion(-)

-- 

