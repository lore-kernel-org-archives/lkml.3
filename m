Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaH2QG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:06:56 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:58727 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaH2QGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:06:55 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, jbaron@akamai.com, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com, akpm@linux-foundation.org,
        linux-kernel@codethink.co.uk, rob.jones@codethink.co.uk
Subject: [PATCH 0/4] Tidy up of modules using seq_open()
Date: Fri, 29 Aug 2014 17:06:36 +0100
Message-Id: <1409328400-18212-1-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many modules use seq_open() when seq_open_private() or
__seq_open_private() would be more appropriate and result in
simpler, cleaner code.

This patch sequence changes those instances in IPC, MM and LIB.

Rob Jones (4):
  ipc: Use __seq_open_private() instead of seq_open()
  mm: Use seq_open_private() instead of seq_open()
  mm: Use __seq_open_private() instead of seq_open()
  lib: Use seq_open_private() instead of seq_open()

 ipc/util.c          |   20 ++++----------------
 lib/dynamic_debug.c |   17 ++---------------
 mm/slab.c           |   22 +++++++++-------------
 mm/vmalloc.c        |   20 +++++---------------
 4 files changed, 20 insertions(+), 59 deletions(-)

-- 
1.7.10.4

