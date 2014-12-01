Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaLAR3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:29:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbaLAR3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:29:35 -0500
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 0/5] kvm: memslots lookup optimization
Date: Mon,  1 Dec 2014 17:29:22 +0000
Message-Id: <1417454967-4465-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Series speed-ups GFN to memslot lookup time by:
 * introducing LRU cache, which improves looukup time for
   same slot workload (typically boot time of Windows and Linux guest)
 * switching to binary search for GFN to memslot lookup,
   improving lookup time with large amount of memory slots

Igor Mammedov (5):
  kvm: update_memslots: drop not needed check for the same number of
    pages
  kvm: update_memslots: drop not needed check for the same slot
  kvm: search_memslots: add simple LRU memslot caching
  kvm: change memslot sorting rule from size to GFN
  kvm: optimize GFN to memslot lookup with large slots amount

 include/linux/kvm_host.h | 28 +++++++++++++++++++++++-----
 virt/kvm/kvm_main.c      | 46 ++++++++++++++++++++++++++--------------------
 2 files changed, 49 insertions(+), 25 deletions(-)

-- 
1.8.3.1

