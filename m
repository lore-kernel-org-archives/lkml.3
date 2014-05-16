Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaEPVn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:43:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:61145 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbaEPVnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:43:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1069,1389772800"; 
   d="scan'208";a="533259470"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: Fix some common inline bloat 
Date: Fri, 16 May 2014 14:43:07 -0700
Message-Id: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's very easy to bloat the kernel code significantly by adding
code to commonly called inlines. Often these inlines start small,
but later when new code is added they don't get moved out-of-line.

I wrote a new tool to account for inline bloat. Addressing selected
occurrences in the top-20 of my kernel config saved about
145k.

   text	   data	    bss	    dec	    hex	filename
14220873	2008072	1507328	17736273	10ea251	vmlinux-before-anything
14074978	2008168	1507328	17590474	10c68ca	vmlinux-inline

-Andi
