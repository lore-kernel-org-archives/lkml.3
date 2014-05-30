Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbaE3GwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:52:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374AbaE3GwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:52:02 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Kamil Iskra <iskra@mcs.anl.gov>, Borislav Petkov <bp@suse.de>,
        Chen Gong <gong.chen@linux.jf.intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 0/3] HWPOISON: improve memory error handling for multithread process
Date: Fri, 30 May 2014 02:51:07 -0400
Message-Id: <1401432670-24664-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <53877e9c.8b2cdc0a.1604.ffffea43SMTPIN_ADDED_BROKEN@mx.google.com>
References: <53877e9c.8b2cdc0a.1604.ffffea43SMTPIN_ADDED_BROKEN@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is the summary of recent discussion about memory error handling
on multithread application. Patch 1 and 2 is for action required errors, and
patch 3 is for action optional errors.

This patchset is based on mmotm-2014-05-21-16-57.

Patches are also available on the following tree/branch.
  git@github.com:Naoya-Horiguchi/linux.git hwpoison/master

Thanks,
Naoya Horiguchi
---
Summary:

Naoya Horiguchi (1):
      mm/memory-failure.c: support dedicated thread to handle SIGBUS(BUS_MCEERR_AO)

Tony Luck (2):
      memory-failure: Send right signal code to correct thread
      memory-failure: Don't let collect_procs() skip over processes for MF_ACTION_REQUIRED

 Documentation/vm/hwpoison.txt |  5 +++
 mm/memory-failure.c           | 75 ++++++++++++++++++++++++++++++-------------
 2 files changed, 58 insertions(+), 22 deletions(-)
