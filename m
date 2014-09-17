Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaIQMy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:54:29 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:59483 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbaIQMy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:54:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAPqDGVSERCAB/2dsb2JhbABggw3SHAGBFRYBAXiEBAEFeRBRV4hXt3qGRY9LBxaENQWLOZ4XiQCDYYMzAQEB
X-IPAS-Result: AhIFAPqDGVSERCAB/2dsb2JhbABggw3SHAGBFRYBAXiEBAEFeRBRV4hXt3qGRY9LBxaENQWLOZ4XiQCDYYMzAQEB
X-IronPort-AV: E=Sophos;i="5.04,540,1406581200"; 
   d="scan'208";a="122640340"
From: Nadav Amit <namit@cs.technion.ac.il>
To: bp@alien8.de
Cc: mingo@kernel.org, nadav.amit@gmail.com, pbonzini@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, Nadav Amit <namit@cs.technion.ac.il>
Subject: [RESEND PATCH 0/3] x86: structs for cpuid info in x86
Date: Wed, 17 Sep 2014 15:54:11 +0300
Message-Id: <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140917124501.GC5358@nazgul.tnic>
References: <20140917124501.GC5358@nazgul.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code that deals with x86 cpuid fields is hard to follow since it performs
many bit operations and does not refer to cpuid field explicitly.  To
eliminate the need of openning a spec whenever dealing with cpuid fields, this
patch-set introduces structs that reflect the various cpuid functions.

Thanks for reviewing the patch-set.

Nadav Amit (3):
  x86: Adding structs to reflect cpuid fields
  x86: Use new cpuid structs in cpuid functions
  KVM: x86: Using cpuid structs in KVM

 arch/x86/include/asm/cpuid_def.h | 163 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/common.c     |  56 ++++++++------
 arch/x86/kvm/cpuid.c             |  36 +++++----
 3 files changed, 219 insertions(+), 36 deletions(-)
 create mode 100644 arch/x86/include/asm/cpuid_def.h

-- 
1.9.1

