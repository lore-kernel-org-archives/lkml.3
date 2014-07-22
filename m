Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbaGVOBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:01:55 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:55586 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaGVOBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:01:53 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] printk: more log flag simplification
Date: Tue, 22 Jul 2014 09:01:55 -0500
Message-Id: <1406037717-9670-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series eliminates the LOG_CONT entirely from the printk/log code.
It builds on another series, posted earlier today:
    http://www.spinics.net/lists/kernel/msg1791665.html
This series was originally longer, but in review I was reminded
that some of the simplifications I had done were not valid.

The first patch exploits the fact that LOG_CONT and LOG_NEWLINE
are inverses, and uses LOG_NEWLINE (or its negation) anywhere
LOG_CONT is used.  As a result, LOG_CONT is no longer needed, so
it's eliminated.

The second patch improves some comments and makes a few small
code cleanups, now that it's gone through this transformation.

					-Alex

This series is available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/more-printk-flags-v2
It is based on branch review/printk-flags-v6 in that same repository.

Alex Elder (2):
  printk: kill LOG_CONT
  printk: improve some commentary; tidy up

 kernel/printk/printk.c | 99 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 59 insertions(+), 40 deletions(-)

-- 
1.9.1

