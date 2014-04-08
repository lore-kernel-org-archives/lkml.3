Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaDHRYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 13:24:47 -0400
Received: from mail.kernel.org ([198.145.19.201]:40334 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbaDHRYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 13:24:46 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@Citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org, keir@xen.org,
        jbeulich@suse.com
Subject: [PATCH] Fixes for more than 32 VCPUs migration for HVM guests (v1).
Date: Tue,  8 Apr 2014 13:25:48 -0400
Message-Id: <1396977950-8789-1-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1396859560.22845.4.camel@kazak.uk.xensource.com>
References: <1396859560.22845.4.camel@kazak.uk.xensource.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches (one for Linux, one for Xen) allow PVHVM guests to use
the per-cpu VCPU mechanism after migration. Currently when an PVHVM guest
migrates all the per-cpu information is lost and we fallback on the
shared_info structure. This is regardless if the HVM guest has 2 or 128 CPUs.
Since the structure has an array for only 32 CPUs that means if we are
to migrate a PVHVM guest - we can only do it up to 32 CPUs.

These patches fix it and allow more than 32 VCPUs to be migrated with
PVHVM Linux guests.

The Linux diff is:

 arch/x86/xen/enlighten.c |   21 ++++++++++++++++-----
 arch/x86/xen/suspend.c   |    6 +-----
 arch/x86/xen/time.c      |    3 +++
 3 files changed, 20 insertions(+), 10 deletions(-)

while the Xen one is:

 xen/arch/x86/hvm/hvm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

