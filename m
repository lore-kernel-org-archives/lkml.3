Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab3EZKKD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 06:10:03 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30884 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3EZKJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 06:09:58 -0400
X-Spam-Score: -100.7
Message-ID: <51A1DF43.5090503@asianux.com>
Date: Sun, 26 May 2013 18:09:07 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com
CC: linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: alpha: kernel: sprintf(), the minimal buffer length
 is 20 for "0xffffffffffffffff\n"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For 'opcode_str' in sprintf(), the maximize length of format "0x%llx\n"
is 20 ("0xffffffffffffffff\n"), so need define 'opcode_str' at least 20
length.

Or the big number comes, it will cause issue.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/alpha/kernel/err_marvel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/err_marvel.c b/arch/alpha/kernel/err_marvel.c
index ae54ad9..2310082 100644
--- a/arch/alpha/kernel/err_marvel.c
+++ b/arch/alpha/kernel/err_marvel.c
@@ -275,7 +275,7 @@ marvel_print_po7_uncrr_sym(u64 uncrr_sym, u64 valid_mask)
 static void
 marvel_print_po7_ugbge_sym(u64 ugbge_sym)
 {
-	char opcode_str[10];
+	char opcode_str[20];
 
 #define IO7__PO7_UGBGE_SYM__UPH_PKT_OFF__S	(6)
 #define IO7__PO7_UGBGE_SYM__UPH_PKT_OFF__M	(0xfffffffful)
-- 
1.7.7.6
