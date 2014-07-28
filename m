Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaG1V0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:26:53 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55217 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaG1V0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:26:49 -0400
Date: Tue, 29 Jul 2014 00:26:44 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] nls: remove "support" for 5- and 6-byte UTF-8 sequences
Message-ID: <20140728212643.GA27113@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5- and 6-byte UTF-8 sequences existed to accomodate code points starting
from U+200000.

Those code points couldn't fit into old 2-byte wchar_t type.

Commit 74675a58507e769beee7d949dbed788af3c4139d added 16+ bit Unicode support
but started (correctly) to check for maximum valid code point
which is U+10FFFF.

U+10FFFF decodes into just 4-byte sequence.

5- and 6- byte UTF-8 sequences were made illegal long ago in
Unicode standard and never had a chance to be used in Linux,
so put them out of misery.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/nls/nls_base.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -39,8 +39,6 @@ static const struct utf8_table utf8_table[] =
     {0xE0,  0xC0,   1*6,    0x7FF,          0x80,      /* 2 byte sequence */},
     {0xF0,  0xE0,   2*6,    0xFFFF,         0x800,     /* 3 byte sequence */},
     {0xF8,  0xF0,   3*6,    0x1FFFFF,       0x10000,   /* 4 byte sequence */},
-    {0xFC,  0xF8,   4*6,    0x3FFFFFF,      0x200000,  /* 5 byte sequence */},
-    {0xFE,  0xFC,   5*6,    0x7FFFFFFF,     0x4000000, /* 6 byte sequence */},
     {0,						       /* end of table    */}
 };
 
