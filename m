Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920Ab3E3DO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:14:29 -0400
Received: from intranet.asianux.com ([58.214.24.6]:8458 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab3E3DOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:14:25 -0400
X-Spam-Score: -100.8
Message-ID: <51A6C3DD.70209@asianux.com>
Date: Thu, 30 May 2013 11:13:33 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "dhowells@redhat.com" <dhowells@redhat.com>, ak@linux.intel.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: frv: kernel: using strncmp() instead of memcmp()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


'cmdline' is a NUL terminated string, when its length < 4, memcmp()
will cause memory access out of boundary.

So need use strncmp() instead of memcmp().


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/frv/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index a513647..622d5ee 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -735,7 +735,7 @@ static void __init parse_cmdline_early(char *cmdline)
 		/* "mem=XXX[kKmM]" sets SDRAM size to <mem>, overriding the value we worked
 		 * out from the SDRAM controller mask register
 		 */
-		if (!memcmp(cmdline, "mem=", 4)) {
+		if (!strncmp(cmdline, "mem=", 4)) {
 			unsigned long long mem_size;
 
 			mem_size = memparse(cmdline + 4, &cmdline);
-- 
1.7.7.6
