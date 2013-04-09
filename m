Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935399Ab3DIGBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 02:01:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:51715 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762938Ab3DIGBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 02:01:30 -0400
X-Spam-Score: -100.8
Message-ID: <5163AE9A.8060505@asianux.com>
Date: Tue, 09 Apr 2013 14:00:58 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>, Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: kallsyms: parameters checking, for EXPORT_SYMBOL_GPL
 functions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  for EXPORT_SYMBOL_GPL functions, necessary to check their parameters.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/kallsyms.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 2169fee..4ba57a9 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -175,6 +175,9 @@ unsigned long kallsyms_lookup_name(const char *name)
 	unsigned long i;
 	unsigned int off;
 
+	if (!name || !name[0])
+		return 0;
+
 	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
 		off = kallsyms_expand_symbol(off, namebuf);
 
@@ -194,6 +197,9 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 	unsigned int off;
 	int ret;
 
+	if (!fn)
+		return -EINVAL;
+
 	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
 		off = kallsyms_expand_symbol(off, namebuf);
 		ret = fn(data, namebuf, NULL, kallsyms_addresses[i]);
@@ -382,6 +388,9 @@ static int __sprint_symbol(char *buffer, unsigned long address,
  */
 int sprint_symbol(char *buffer, unsigned long address)
 {
+	if (!buffer)
+		return 0;
+
 	return __sprint_symbol(buffer, address, 0, 1);
 }
 EXPORT_SYMBOL_GPL(sprint_symbol);
@@ -399,6 +408,9 @@ EXPORT_SYMBOL_GPL(sprint_symbol);
  */
 int sprint_symbol_no_offset(char *buffer, unsigned long address)
 {
+	if (!buffer)
+		return 0;
+
 	return __sprint_symbol(buffer, address, 0, 0);
 }
 EXPORT_SYMBOL_GPL(sprint_symbol_no_offset);
-- 
1.7.7.6
