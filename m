Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab3EaMWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:22:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57546 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab3EaMWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:22:03 -0400
Date: Fri, 31 May 2013 05:21:39 -0700
From: tip-bot for Rabin Vincent <tipbot@zytor.com>
Message-ID: <tip-3c4797d46c14fa0c7cf733a77bd4b28875078b53@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, rabin@rab.in, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, rabin@rab.in, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1368822464-4887-1-git-send-email-rabin@rab.in>
References: <1368822464-4887-1-git-send-email-rabin@rab.in>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib lk: Respect CROSS_COMPILE
Git-Commit-ID: 3c4797d46c14fa0c7cf733a77bd4b28875078b53
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c4797d46c14fa0c7cf733a77bd4b28875078b53
Gitweb:     http://git.kernel.org/tip/3c4797d46c14fa0c7cf733a77bd4b28875078b53
Author:     Rabin Vincent <rabin@rab.in>
AuthorDate: Fri, 17 May 2013 22:27:44 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 May 2013 15:46:36 +0300

tools lib lk: Respect CROSS_COMPILE

Make lk use CROSS_COMPILE, in order to be able to cross compile perf
again.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1368822464-4887-1-git-send-email-rabin@rab.in
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/lk/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 926cbf3..2c5a197 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -1,5 +1,8 @@
 include ../../scripts/Makefile.include
 
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
+
 # guard against environment variables
 LIB_H=
 LIB_OBJS=
