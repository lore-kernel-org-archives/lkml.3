Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039Ab3DAEGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 00:06:21 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:43435 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3DAEGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 00:06:20 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 0/2] KVM: x86: avoid potential soft lockup and unneeded mmu reload
Date: Mon,  1 Apr 2013 12:06:07 +0800
Message-Id: <1364789169-11761-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040104-5816-0000-0000-0000075BA014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes kvm_mmu_zap_all be preemptable since it is a slow path,
break the mmu-lock if needed to avoid potential soft lockup. Also it drops
unnecessary kvm_reload_remote_mmus

This is the preparing work about kvm_mmu_zap_all, the fast approach is being
developed

Xiao Guangrong (2):
  KVM: MMU: make kvm_mmu_zap_all preemptable
  KVM: MMU: drop unnecessary kvm_reload_remote_mmus

 arch/x86/kvm/mmu.c |   11 ++++++++++-
 arch/x86/kvm/x86.c |    5 +----
 2 files changed, 11 insertions(+), 5 deletions(-)

-- 
1.7.7.6

