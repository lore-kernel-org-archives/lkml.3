Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab3KRCIE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 21:08:04 -0500
Received: from dmz-mailsec-scanner-3.mit.edu ([18.9.25.14]:42099 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546Ab3KRCHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 21:07:54 -0500
X-AuditID: 1209190e-b7efb6d000000bb9-81-528976795aa5
Date: Sun, 17 Nov 2013 21:07:46 -0500
From: Greg Price <price@MIT.EDU>
To: Al Viro <viro@ZenIV.linux.org.uk>, Christopher Li <sparse@chrisli.org>
Cc: Joe Perches <joe@perches.com>, Erico Nunes <nunes.erico@gmail.com>,
        linux-sparse@vger.kernel.org, dwmw2 <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Clarify error on directive in macro arguments (Re: [PATCH]
 jffs2: fix sparse errors: directive in argument list)
Message-ID: <20131118020746.GX16018@ringworld.MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118013349.GM13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsUixG6noltZ1hlkcPiRnsXElZOZLWbff8xi
	cXnXHDaL3U3L2C3u3d7PYtHSu4TRomvNIVaL83+PszpweKxYdYXFY+esu+wem1doeWxeUu/x
	ZdU1Zo/Pm+Q8Nj15yxTAHsVlk5Kak1mWWqRvl8CVcWn3VraCmQIVM/5eY29g/MDTxcjJISFg
	IrG04QALhC0mceHeerYuRi4OIYHZTBLvZr5gBEkICWxklJj6WAzC/sUo0XBHrYuRg4NFQFXi
	eZ8qSJhNQEHix/x1zCBhEQEviQPXNUHGMAt8YZR4dL+TCcQRFmhmlGhvbmYGaeAVMJN49eo6
	lC0ocXLmE7AjmAW0JG78e8kEMohZQFpi+T8OkDCngIVEZ+chsHNEBVQkppzcxjaBUWAWku5Z
	SLpnIXQvYGRexSibklulm5uYmVOcmqxbnJyYl5dapGusl5tZopeaUrqJERQLnJJ8Oxi/HlQ6
	xCjAwajEw6sR1hkkxJpYVlyZe4hRkoNJSZTXsgQoxJeUn1KZkVicEV9UmpNafIhRgoNZSYTX
	xB8ox5uSWFmVWpQPk5LmYFES573JYR8kJJCeWJKanZpakFoEk5Xh4FCS4C0pBWoULEpNT61I
	y8wpQUgzcXCCDOcBGt4PUsNbXJCYW5yZDpE/xagoJc4rBJIQAElklObB9cJS1StGcaBXhHmn
	glTxANMcXPcroMFMQIOPP28DGVySiJCSamDU+f5tl97FgGX32XpNxAvnJ5nWnKyvNnwcm/ni
	bEj5XL4FfJOtC/zDD3skP2ixYohmY4rlP5H9ce39N0cctmxvqP7x9Uukk+AvpSufEtwPGxil
	W0spMIbfZ57xiOGM2mv2n4kF7/Jn193g7L8RnCt89rIql97qHF0+dyab3+/uCsbGfi/8+kiJ
	pTgj0VCLuag4EQDGV9rGMAMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+linux-sparse and Chris]

On Mon, Nov 18, 2013 at 01:33:49AM +0000, Al Viro wrote:
> On Sun, Nov 17, 2013 at 02:45:05PM -0800, Joe Perches wrote:
> > Yes.  I think it's a defect in how sparse
> > treats string concatenation.
> > 
> > That style [... with printk ...] is pretty common in the kernel sources.
> 
> ... and it's perfectly fine, until somebody starts playing in nasal
> daemon country and do that in *macro* arguments.  And a nasal daemon
> country it is - it's an undefined behaviour.  See 6.10.3p11 in C99.
> And trying to define a semantics for that gets real ugly real fast.
> sparse matches gcc behaviour (I hope), but it warns about such abuses.
> It's a defect, all right - one being reported by sparse.

Perhaps the following tweak to the error message would make this
subtlety clearer?

Cheers,
Greg


From: Greg Price <price@mit.edu>
Date: Sun, 17 Nov 2013 17:57:41 -0800
Subject: [PATCH] Clarify error on directive in macro arguments

Preprocessor directives in the arguments of a real function
are innocuous and in some contexts common.  If a developer
doesn't realize that a "function" is implemented as a macro,
they may mistake this error for a false alarm.

See http://www.spinics.net/lists/kernel/msg1636974.html
and http://www.spinics.net/lists/kernel/msg1636976.html
for an example.

Easy enough to clarify that this is a macro, so do it.

Signed-off-by: Greg Price <price@mit.edu>
---
 pre-process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/pre-process.c b/pre-process.c
index d521318..db58a97 100644
--- a/pre-process.c
+++ b/pre-process.c
@@ -204,7 +204,7 @@ static struct token *collect_arg(struct token *prev, int vararg, struct position
 		if (next->pos.newline && match_op(next, '#')) {
 			if (!next->pos.noexpand) {
 				sparse_error(next->pos,
-					     "directive in argument list");
+					     "directive in macro argument list");
 				preprocessor_line(stream, p);
 				__free_token(next);	/* Free the '#' token */
 				continue;
-- 
1.8.3.2
