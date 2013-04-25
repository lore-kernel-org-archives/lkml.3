Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab3DYKmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:42:44 -0400
Received: from multi.imgtec.com ([194.200.65.239]:57840 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728Ab3DYKmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:42:42 -0400
Message-ID: <5179089E.3010005@imgtec.com>
Date: Thu, 25 Apr 2013 11:42:38 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: <rusty@rustcorp.com.au>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        <arjan@infradead.org>, <linux-kernel@vger.kernel.org>,
        <andy.shevchenko@gmail.com>
Subject: [PATCH v2] modpost: fix unwanted VMLINUX_SYMBOL_STR expansion
References: <CAHp75VdDwh0wgCWrVDcPps1C2qfdDZra15y9BQvzfWHzSMqbWA@mail.gmail.com> <CAHp75Vfh6Bpk4j3crVEAo3UtJEqpyucbQw+AzJvO85uRJ6gVgg@mail.gmail.com> <201304222326.IJB21395.FOtVJFHFQMOOSL@I-love.SAKURA.ne.jp> <201304232140.FGF73904.QJOFOVtHFFMSOL@I-love.SAKURA.ne.jp> <51772CD3.3040405@zytor.com> <51772EBC.1050600@zytor.com> <5177B061.50107@imgtec.com> <51781AD9.7020600@zytor.com>
In-Reply-To: <51781AD9.7020600@zytor.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_04_25_11_42_39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a4b6a77b77ba4f526392612c2365797fab956014 ("module: fix symbol
versioning with symbol prefixes") broke the MODVERSIONS loading of any
module using memcmp (e.g. ipv6) on x86_32, as it's defined to
__builtin_memcmp which is expanded by VMLINUX_SYMBOL_STR. Use
__VMLINUX_SYMBOL_STR instead which doesn't expand the argument.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: H. Peter Anvin <hpa@zytor.com>
Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---

I've corrected commit message tags for Rusty's convenience.
Updated Reported-by to include Andy
Taken the liberty of adding Tetsuo's Tested-by

Cheers
James

 scripts/mod/modpost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 1f90961..a4be8e1 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1957,7 +1957,7 @@ static int add_versions(struct buffer *b, struct module *mod)
 				s->name, mod->name);
 			continue;
 		}
-		buf_printf(b, "\t{ %#8x, VMLINUX_SYMBOL_STR(%s) },\n",
+		buf_printf(b, "\t{ %#8x, __VMLINUX_SYMBOL_STR(%s) },\n",
 			   s->crc, s->name);
 	}
 
-- 
1.8.1.2

