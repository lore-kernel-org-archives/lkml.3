Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3LECl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:41:58 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50078 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab3LECly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:41:54 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/4] perf trace: Fix crash on RHEL6
Date: Wed,  4 Dec 2013 19:41:40 -0700
Message-Id: <1386211302-31303-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1386211302-31303-1-git-send-email-dsahern@gmail.com>
References: <1386211302-31303-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index a7aa771a98e6..8f47eaae2f34 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1455,7 +1455,7 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 {
 	size_t printed = 0;
 
-	if (sc->tp_format != NULL) {
+	if ((sc->tp_format != NULL) && (sc->tp_format->format.fields != NULL)) {
 		struct format_field *field;
 		u8 bit = 1;
 		struct syscall_arg arg = {
-- 
1.8.3.4 (Apple Git-47)

