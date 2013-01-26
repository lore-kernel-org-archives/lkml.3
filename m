Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3AZBQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:16:49 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48326 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753629Ab3AZBQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:16:47 -0500
Message-ID: <1359163006.2079.10.camel@joe-AO722>
Subject: [PATCH] checkpatch: Fix $Float creation of match variables
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>
Date: Fri, 25 Jan 2013 17:16:46 -0800
In-Reply-To: <20130125164413.dd931cb8.akpm@linux-foundation.org>
References: <20130125164413.dd931cb8.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 74349bccedb
("checkpatch: add support for floating point constants")
added an unnecessary match variable that caused
tests that used a $Constant or $LvalOrFunc to have
one too many matches.

This causes problems with usleep_range, min/max and
other extended tests.

Avoid using match variables in $Float.
Avoid using match variables in $Assignment too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9de3a69..3d0f577 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -230,12 +230,12 @@ our $Inline	= qr{inline|__always_inline|noinline};
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
-our $Float_hex	= qr{(?i:0x[0-9a-f]+p-?[0-9]+[fl]?)};
-our $Float_dec	= qr{(?i:((?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?))};
-our $Float_int	= qr{(?i:[0-9]+e-?[0-9]+[fl]?)};
+our $Float_hex	= qr{(?i)0x[0-9a-f]+p-?[0-9]+[fl]?};
+our $Float_dec	= qr{(?i)(?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?};
+our $Float_int	= qr{(?i)[0-9]+e-?[0-9]+[fl]?};
 our $Float	= qr{$Float_hex|$Float_dec|$Float_int};
-our $Constant	= qr{(?:$Float|(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*))};
-our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
+our $Constant	= qr{$Float|(?i)(?:0x[0-9a-f]+|[0-9]+)[ul]*};
+our $Assignment	= qr{\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
 			<=|>=|==|!=|


