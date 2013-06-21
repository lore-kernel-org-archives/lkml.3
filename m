Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965615Ab3FUJCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:02:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030249Ab3FUJCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:02:49 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mtosatti@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        kvm@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
        eabatalov89@gmail.com
Subject: [PATCH 0/2 v2] x86: kvmclock: Prevent uninitialized per-cpu kvmclock usage
Date: Fri, 21 Jun 2013 11:01:19 +0200
Message-Id: <1371805281-21305-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <bug-59521-28872@https.bugzilla.kernel.org/>
References: <bug-59521-28872@https.bugzilla.kernel.org/>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes regression introduced by
    7069ed6 x86: kvmclock: allocate pvclock shared memory area
and reported by Eugene:
    https://bugzilla.kernel.org/show_bug.cgi?id=59521

v2:
 - "[1/2] x86: kvmclock: zero initialize pvclock shared memory area"
      added to commit messaged another reason why it's clearing
      is necessary.
 - added "[2/2] x86: kvmclock: register per-cpu kvmclock at earliest possible time"
      to register clock earlier.

Igor Mammedov (2):
  x86: kvmclock: zero initialize pvclock shared memory area
  x86: kvmclock: register per-cpu kvmclock at earliest possible time

 arch/x86/kernel/kvmclock.c |   12 ++++++++++--
 arch/x86/kernel/smpboot.c  |    2 +-
 arch/x86/mm/pageattr.c     |    4 ++--
 3 files changed, 13 insertions(+), 5 deletions(-)

