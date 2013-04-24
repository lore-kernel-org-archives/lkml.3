Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab3DXE0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 00:26:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36943 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab3DXE01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 00:26:27 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        DJ Johnston <dj.johnston@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v2 0/2] random: Account for entropy loss due to overwrites
Date: Tue, 23 Apr 2013 21:26:07 -0700
Message-Id: <1366777569-23192-1-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

When we write entropy into a non-empty pool, we currently don't
account at all for the fact that we will probabilistically overwrite
some of the entropy in that pool.  This means that unless the pool is
fully empty, we are currently *guaranteed* to overestimate the amount
of entropy in the pool!

This version of the patchset avoids manually duplicating information
by using a macro.  This removes *all* dynamic computation of derived
pool information and replaces them with static information: on just
about every architecture accessing pointer+offset is no more expensive
than just plain pointer, and this lets us get the information we
actually need from the start.

I originally wrote this patchset up back in November, but it looks
like I never sent it out.  Oops.

I am tagging this for -stable since it is at least theoretically a
security issue.
