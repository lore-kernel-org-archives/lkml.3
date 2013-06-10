Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3FJVVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:21:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3FJVVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:21:19 -0400
Date: Mon, 10 Jun 2013 14:21:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc: avoid strncpy in accounting tool
Message-Id: <20130610142118.e5a3eb91c02f4185da99cd2c@linux-foundation.org>
In-Reply-To: <20130606024930.GA24279@www.outflux.net>
References: <20130606024930.GA24279@www.outflux.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jun 2013 19:49:30 -0700 Kees Cook <keescook@chromium.org> wrote:

> Avoid strncpy anti-pattern. Use strdup() instead, as already done for
> the logfile optarg.
> 

What Andreas said :)

From: Andrew Morton <akpm@linux-foundation.org>
Subject: documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix

remove the str[cpy|dup] altogether

Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix
+++ a/Documentation/accounting/getdelays.c
@@ -299,7 +299,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'C':
 			containerset = 1;
-			containerpath = strdup(optarg);
+			containerpath = optarg;
 			break;
 		case 'w':
 			logfile = strdup(optarg);
_

