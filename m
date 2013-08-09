Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967956Ab3HIQDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:03:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:39773 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934068Ab3HIQDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:03:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,846,1367996400"; 
   d="scan'208";a="384498929"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org,
        david.daney@cavium.com
Subject: RFC: Use single pass kallsyms
Date: Fri,  9 Aug 2013 09:03:16 -0700
Message-Id: <1376064199-8296-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my attempt to avoid extra link steps for kallsyms.

Originally for LTO (where it gives dramatic build time improvements),
but it also gives a nice build speedup on a standard build (-10s on my laptop)

Even with this we still link two times (one more for modpost), but this
may be eventually fixable too.

Right now this is an RFC, I'm particularly interested in testing
on more architectures.

