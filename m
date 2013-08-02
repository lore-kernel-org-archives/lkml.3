Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3HBVJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:09:43 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:39934 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab3HBVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:09:42 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH 0/3] smp.h: !SMP cleanups.
Date: Fri,  2 Aug 2013 14:09:33 -0700
Message-Id: <1375477776-13302-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

This is a follow-on patch set to f21afc25f9 (smp.h: Use
local_irq_{save,restore}() in !SMP version of on_each_cpu().).  There
are no problems known to me that are fixed, but it does make things more
consistent.

These are based on linux-next next-20130802 and the corresponding mm
patch series.  And specifically akpm's
"include/linux/smp.h:on_each_cpu(): switch back to a C function"
patch.

The third patch (smp.h: Move !SMP version of on_each_cpu()
out-of-line) does seem to make the kernel slightly larger on some
architectures, so it is possible that it could be dropped if that
concerns people.

David Daney (3):
  smp: Quit unconditionally enabling irq in on_each_cpu_mask and
    on_each_cpu_cond
  up.c: Use local_irq_{save,restore}() in smp_call_function_single.
  smp.h: Move !SMP version of on_each_cpu() out-of-line

 include/linux/smp.h | 83 ++++++++++++++---------------------------------------
 kernel/up.c         | 58 +++++++++++++++++++++++++++++++++++--
 2 files changed, 76 insertions(+), 65 deletions(-)

-- 
1.7.11.7

