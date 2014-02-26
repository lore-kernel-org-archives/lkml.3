Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaBZSPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 13:15:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbaBZSPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:15:19 -0500
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mtosatti@redhat.com, pbonzini@redhat.com
Subject: [PATCH 0/2] x86: kvm: global clock updates
Date: Wed, 26 Feb 2014 19:15:10 +0100
Message-Id: <1393438512-21273-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series addresses two issues with global clock updates.
The first fixes a bug found on hosts that have a tsc marked as
unstable. As global clock updates get triggered on every vcpu load
in these cases, guests with a large number of vcpus have their
progress nearly halted. The fix for that bug should also go to
stable. The second patch in this series ensures that NTP corrections
on the host, as well as on guests with all vcpus pinned, will be
propagated periodically. That patch improves things, but doesn't
fix a bug, thus it can be merged at a later time than the first.
I've posted them together as a series, as the second one builds
on the first.

Andrew Jones (2):
  x86: kvm: rate-limit global clock updates
  x86: kvm: introduce periodic global clock updates

 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/x86.c              | 92 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 90 insertions(+), 4 deletions(-)

-- 
1.8.1.4

