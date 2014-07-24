Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934691AbaGXKNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:13:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230AbaGXKNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:13:45 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: uobergfe@redhat.com, dzickus@redhat.com, pbonzini@redhat.com,
        akpm@linux-foundation.org, mingo@redhat.com
Subject: [PATCH 0/3] watchdog: kvm: disable hard lockup detection by default
Date: Thu, 24 Jul 2014 12:13:28 +0200
Message-Id: <1406196811-5384-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not recommended for KVM guests to enable hard lockup detection, as
false positives may be easily triggered by, for example, vcpu overcommit.
However any kernel compiled with HARDLOCKUP_DETECTOR that detects a PMU
on boot will by default enable hard lockup detection. This series gives
a kernel a mechanism to opt out of this default. Users can still force
hard lockup detection on using the kernel command line option
'nmi_watchdog=1'.

The first patch is a watchdog fix, and can be taken separately. The next
patch provides the default opt out mechanism, and the final patch applies
it to kvm guests.

Thanks in advance for reviews,
drew


Ulrich Obergfell (3):
  watchdog: fix print-once on enable
  watchdog: control hard lockup detection default
  kvm: ensure hard lockup detection is disabled by default

 arch/x86/kernel/kvm.c |  8 ++++++++
 include/linux/nmi.h   |  9 +++++++++
 kernel/watchdog.c     | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 63 insertions(+), 2 deletions(-)

-- 
1.9.3

