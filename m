Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406AbaGaJsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:48:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313AbaGaJsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:48:35 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        pbonzini@redhat.com, kvm@vger.kernel.org, mtosatti@redhat.com
Subject: [PATCH 0/2] Avoid using TSC clocksource on AMD APUs affected by erratum 778
Date: Thu, 31 Jul 2014 09:47:11 +0000
Message-Id: <1406800033-13404-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes pvclock backwards jumps caused by TSC drifting despite
host believing that TSC is invariant/synchronized.

TSC drift maybe caused by erratum 778 described in
"Revision Guide for AMD Family 15h Models 10h-1Fh Processors,
 Publication # 48931, Issue Date: May 2013, Revision: 3.10"


Igor Mammedov (2):
  x86: AMD: mark TSC unstable on APU family 15h models 10h-1fh
  x86: kvm: do not advertise stable clocksource if CPU has TSC drift BUG

 arch/x86/include/asm/cpufeature.h | 1 +
 arch/x86/kernel/cpu/amd.c         | 9 +++++++++
 arch/x86/kvm/cpuid.c              | 3 ++-
 3 files changed, 12 insertions(+), 1 deletion(-)

-- 
1.8.3.1

