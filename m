Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936261Ab3DKOpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:45:06 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51124 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932712Ab3DKOpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:45:04 -0400
Message-ID: <1365691503.1929.15.camel@joe-AO722>
Subject: [PATCH] checkpatch: Make camelcase test --strict and less noisy
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andy Whitcroft <apw@canonical.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Date: Thu, 11 Apr 2013 07:45:03 -0700
In-Reply-To: <20130410151911.GG6857@pd.tnic>
References: <1365544254.2946.53.camel@dabdike> <20130410132628.GV7511@dm>
	 <1365604558.27174.36.camel@joe-AO722> <20130410145213.GA6854@pd.tnic>
	 <1365606461.1942.3.camel@dabdike> <20130410151911.GG6857@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CamelCase tests are a bit noisy against certain
types of code acceptable to some kernel developers.

Make the test applicable only with --strict.

Do not bleat a message on nominally acceptable
CamelCase uses that are separated by an _ like
drm_core_has_MTRR.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3fb6d86..97226fb 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2937,12 +2937,12 @@ sub process {
 		while ($line =~ m{($Constant|$Lval)}g) {
 			my $var = $1;
 			if ($var !~ /$Constant/ &&
-			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
+			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
 			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
-				WARN("CAMELCASE",
-				     "Avoid CamelCase: <$var>\n" . $herecurr);
+				CHK("CAMELCASE",
+				    "Avoid CamelCase: <$var>\n" . $herecurr);
 			}
 		}
 


