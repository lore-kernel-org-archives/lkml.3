Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaGONlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:41:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbaGONky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:40:54 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: xen-devel@lists.xenproject.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 0/4] xen/pvhvm: fix shared_info and pirq issues with kexec
Date: Tue, 15 Jul 2014 15:40:36 +0200
Message-Id: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch series I'm trying to address several issues with kexec on pvhvm:
- shared_info issue (1st patch, just sending Olaf's work with Konrad's fix)
- create specific pvhvm shutdown handler for kexec (2nd patch)
- GSI PIRQ issue (3rd patch, I'm pretty confident that it does the right thing)
- MSI PIRQ issue (4th patch, and I'm not sure it doesn't break anything -> RFC)

This patch series can be tested on single vCPU guest. We still have SMP issues with
pvhvm guests and kexec which require additional fixes.

Olaf Hering (1):
  xen PVonHVM: use E820_Reserved area for shared_info

Vitaly Kuznetsov (3):
  xen/pvhvm: Introduce xen_pvhvm_kexec_shutdown()
  xen/pvhvm: Unmap all PIRQs on startup and shutdown
  xen/pvhvm: Make MSI IRQs work after kexec

 arch/x86/pci/xen.c               |  3 +-
 arch/x86/xen/enlighten.c         | 83 +++++++++++++++++++++++++++++++---------
 arch/x86/xen/smp.c               | 10 +++++
 arch/x86/xen/smp.h               |  1 +
 arch/x86/xen/suspend.c           |  2 +-
 arch/x86/xen/xen-ops.h           |  2 +-
 drivers/xen/events/events_base.c | 76 ++++++++++++++++++++++++++++++++++++
 include/xen/events.h             |  3 ++
 8 files changed, 158 insertions(+), 22 deletions(-)

-- 
1.9.3

