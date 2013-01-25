Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab3AYL3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:29:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41670 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3AYL3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:29:48 -0500
Date: Fri, 25 Jan 2013 03:29:24 -0800
From: tip-bot for Al Cooper <alcooperx@gmail.com>
Message-ID: <tip-31160d7feab786c991780d7f0ce2755a469e0e5e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, alcooperx@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        alcooperx@gmail.com, tglx@linutronix.de
In-Reply-To: <1357680156-15520-1-git-send-email-alcooperx@gmail.com>
References: <1357680156-15520-1-git-send-email-alcooperx@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix GNU make v3.80 compatibility issue
Git-Commit-ID: 31160d7feab786c991780d7f0ce2755a469e0e5e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:29:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31160d7feab786c991780d7f0ce2755a469e0e5e
Gitweb:     http://git.kernel.org/tip/31160d7feab786c991780d7f0ce2755a469e0e5e
Author:     Al Cooper <alcooperx@gmail.com>
AuthorDate: Tue, 8 Jan 2013 16:22:36 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:17 -0300

perf tools: Fix GNU make v3.80 compatibility issue

According to Documentation/Changes, the kernel should be buildable with
GNU make 3.80+. tools/perf/config/utilities.mak contains the "$(or"
construct, which requires make 3.81.  This causes "make" to fail on
systems with GNU make 3.80.

Replace "$(or" with an equivalent "$(if" expression, to restore backward
compatibility. Also fix an issue where _get_attempt was called with only
one argument. This prevented the error message from printing the name of
the variable that can be used to fix the problem.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1357680156-15520-1-git-send-email-alcooperx@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/utilities.mak | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index e541312..8ef3bd3 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -13,7 +13,7 @@ newline := $(newline)
 # what should replace a newline when escaping
 # newlines; the default is a bizarre string.
 #
-nl-escape = $(or $(1),m822df3020w6a44id34bt574ctac44eb9f4n)
+nl-escape = $(if $(1),$(1),m822df3020w6a44id34bt574ctac44eb9f4n)
 
 # escape-nl
 #
@@ -173,9 +173,9 @@ _ge-abspath = $(if $(is-executable),$(1))
 # Usage: absolute-executable-path-or-empty = $(call get-executable-or-default,variable,default)
 #
 define get-executable-or-default
-$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2)))
+$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2),$(1)))
 endef
-_ge_attempt = $(or $(get-executable),$(_gea_warn),$(call _gea_err,$(2)))
+_ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
 _gea_warn = $(warning The path '$(1)' is not executable.)
 _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
 
