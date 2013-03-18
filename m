Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3CRK4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:56:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33958 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3CRK4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:56:18 -0400
Date: Mon, 18 Mar 2013 03:54:54 -0700
From: tip-bot for Jack Mitchell <tipbot@zytor.com>
Message-ID: <tip-b9e8c37220c80e78289a1e87b50c09418eb59a7e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, tglx@linutronix.de,
        jack.mitchell@dbbroadcast.co.uk
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@kernel.org,
        jack.mitchell@dbbroadcast.co.uk
In-Reply-To: <1362741712-21308-1-git-send-email-ml@communistcode.co.uk>
References: <1362741712-21308-1-git-send-email-ml@communistcode.co.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] libtraceevent: Remove hard coded include to /
 usr/local/include in Makefile
Git-Commit-ID: b9e8c37220c80e78289a1e87b50c09418eb59a7e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 03:54:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9e8c37220c80e78289a1e87b50c09418eb59a7e
Gitweb:     http://git.kernel.org/tip/b9e8c37220c80e78289a1e87b50c09418eb59a7e
Author:     Jack Mitchell <jack.mitchell@dbbroadcast.co.uk>
AuthorDate: Fri, 8 Mar 2013 11:21:52 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Mar 2013 17:00:00 -0300

libtraceevent: Remove hard coded include to /usr/local/include in Makefile

having /usr/local/include hardcoded into the makefile is not necessary
as this is automatically included by GCC. It also infects cross-compile
builds with the host systems includes.

Signed-off-by: Jack Mitchell <jack.mitchell@dbbroadcast.co.uk>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362741712-21308-1-git-send-email-ml@communistcode.co.uk
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index a20e320..0b0a907 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -122,7 +122,7 @@ export Q VERBOSE
 
 EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
-INCLUDES = -I. -I/usr/local/include $(CONFIG_INCLUDES)
+INCLUDES = -I. $(CONFIG_INCLUDES)
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -Wall
