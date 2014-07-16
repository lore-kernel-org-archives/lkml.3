Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbaGPR1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:27:06 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51728 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747AbaGPR1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:27:04 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org, jack@suse.cz,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] printk: start simplifying some flags
Date: Wed, 16 Jul 2014 12:26:56 -0500
Message-Id: <1405531620-9983-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each log record has a "flags" field.  The flags keep track of, for
instance, whether the record was saved in its entirety (as opposed
to being one of multiple records that should be merged as a single
unit).  A log record's flags field alone is not currently sufficient
to know how the record should be formatted; you need to know the
previous record's flags field as well.  I found understanding the
real effect of various combinations of these flags to be very
difficult, and was moved to try to do something about that.

This series includes three patches that begin the process of
simplifying how these flags are used and interpreted.  They include
very long, detailed explanations (as small patches often do) because
I want my reasoning to be very clear and examined very closely.  I
really don't want to break printk()...

The first patch simplifies some code based on the observation that
certain flag combinations never occur.

The second and third patch fix what I assert is a bug in two places.
The bug is that a LOG_PREFIX in a message should implicitly
terminate its predecessor, even if the predecessor was marked
LOG_CONT.  I would really like to have someone else confirm
they agree my assertion here.

One trivial extra patch is included at the end of the series.

					-Alex

This series, based on v3.16-rc4, is available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/printk-flags

Alex Elder (4):
  printk: LOG_CONT and LOG_NEWLINE are separate
  printk: honor LOG_PREFIX in devkmsg_read()
  printk: honor LOG_PREFIX in msg_print_text()
  printk: correct some more typos

 kernel/printk/printk.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

-- 
1.9.1

