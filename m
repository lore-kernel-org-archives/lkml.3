Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3E0Bwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 21:52:47 -0400
Received: from intranet.asianux.com ([58.214.24.6]:13453 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab3E0Bwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 21:52:45 -0400
X-Spam-Score: -100.8
Message-ID: <51A2BC3B.4040908@asianux.com>
Date: Mon, 27 May 2013 09:51:55 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>, Paul Mundt <lethal@linux-sh.org>,
        realmz paranoid <realmz6@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, monstr@monstr.eu,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH v2] arch: blackfin: kernel: using strlcpy() instead of strncpy()
References: <51A1B419.5000704@asianux.com>
In-Reply-To: <51A1B419.5000704@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For NULL terminated string, need always be sure of ended by zero.

Just use strlcpy() instead of strncpy().


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/blackfin/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 107b306..c731ec7 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -1458,5 +1458,5 @@ void __init cmdline_init(const char *r0)
 {
 	early_shadow_stamp();
 	if (r0)
-		strncpy(command_line, r0, COMMAND_LINE_SIZE);
+		strlcpy(command_line, r0, COMMAND_LINE_SIZE);
 }
-- 
1.7.7.6


