Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaE0ADY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:03:24 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54253 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaE0ADX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:03:23 -0400
Message-ID: <5383D647.9020508@gmail.com>
Date: Tue, 27 May 2014 08:03:19 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] arch: unicore32: ksyms: export additional find_first_*()
 to avoid compiling failure
References: <5383D5F5.2000303@gmail.com>
In-Reply-To: <5383D5F5.2000303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some modules need find_first_bit() and find_first_zero_bit(), so export
them.

The related error (with allmodconfig under unicore32):

    MODPOST 4039 modules
  ERROR: "find_first_bit" [sound/soc/codecs/snd-soc-uda1380.ko] undefined!
  ERROR: "find_first_zero_bit" [net/sctp/sctp.ko] undefined!
  ...


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/kernel/ksyms.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/unicore32/kernel/ksyms.c b/arch/unicore32/kernel/ksyms.c
index e78911a..0323528 100644
--- a/arch/unicore32/kernel/ksyms.c
+++ b/arch/unicore32/kernel/ksyms.c
@@ -23,6 +23,8 @@
 
 #include "ksyms.h"
 
+EXPORT_SYMBOL(find_first_bit);
+EXPORT_SYMBOL(find_first_zero_bit);
 EXPORT_SYMBOL(find_next_zero_bit);
 EXPORT_SYMBOL(find_next_bit);
 
-- 
1.9.2.459.g68773ac
