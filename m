Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaGQR7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:59:17 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:54984 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaGQR7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:59:16 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] printk: more log flag simplification
Date: Thu, 17 Jul 2014 12:59:08 -0500
Message-Id: <1405619953-5475-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series rearranges the log code in such a way that the LOG_CONT
and LOG_PREFIX log record flags can be eliminated entirely.  The
result should be considerably easier to understand than before.  It
builds on another recently-posted series of patches:
    https://lkml.org/lkml/2014/7/17/363

The first patch exploits the fact that LOG_CONT and LOG_NEWLINE
are inverses, and uses LOG_NEWLINE (or its negation) anywhere
LOG_CONT is used.  As a result, LOG_CONT is no longer needed, so
it's eliminated.

The next three patches together eliminate LOG_PREFIX.  The effect
of LOG_PREFIX is to complete the previous log entry before recording
a new one.  Patch 2 arranges to do this directly, marking the previous
log record with LOG_NEWLINE whenever a new record is presented with
LOG_PREFIX set.  Patch 3 stops saving LOG_PREFIX in any log records,
and patch 4 finally gets rid of LOG_PREFIX.

The last patch is just some cleanup of the code now that it's gone
through this transformation.

					-Alex

This series is available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/more-printk-flags
It is based on branch review/printk-flags-v2 in that same repository.

Alex Elder (5):
  printk: kill LOG_CONT
  printk: update previous message for LOG_PREFIX
  printk: stop actually recording LOG_PREFIX
  printk: kill LOG_PREFIX
  printk: rename LOG_NEWLINE and tidy up

 kernel/printk/printk.c | 135 +++++++++++++++++++++++++++++--------------------
 1 file changed, 81 insertions(+), 54 deletions(-)

-- 
1.9.1

