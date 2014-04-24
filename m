Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbaDXQIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:08:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:20211 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757578AbaDXQIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:08:51 -0400
Message-Id: <20140424160626.491010573@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:06:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/7] ktest: A working config-bisect and other updates
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The big change here is that I rewrote the config-bisect test.

Now you can take two configs, one that works and one that does not,
and it will bisect the two until it comes down to a single change
that causes one to work and the other to fail.

I updated this because the latest kernel caused my min config to
no longer boot the kernel built with allnoconfig. I was missing
something. After rewriting this code (and making the code so much
more simpler), it found the missing config without a problem.

Also some other clean ups and fixes.

-- Steve


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
for-next

Head SHA1: 4c16b1d6d5e0ca0612de65596a3d1ead8a3372fb


Satoru Takeuchi (2):
      ktest: add 2nd parameter of run_command() to set the redirect target file
      ktest: Some cleanup for improving readability

Steven Rostedt (Red Hat) (5):
      ktest: Rewrite the config-bisect to actually work
      ktest: Put back in the CONFIG_BISECT_CHECK
      ktest: Remove unused functions
      ktest: Add the config bisect manual back
      ktest: Update documentation on config_bisect

----
 tools/testing/ktest/ktest.pl    | 581 +++++++++++++++++++---------------------
 tools/testing/ktest/sample.conf |  65 ++---
 2 files changed, 297 insertions(+), 349 deletions(-)
