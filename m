Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaKJTjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:39:46 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:50727 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaKJTjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:39:44 -0500
From: Julius Werner <jwerner@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Julius Werner <jwerner@chromium.org>
Subject: [PATCHv2] checkpatch: Allow certain SI units with three characters
Date: Mon, 10 Nov 2014 11:39:31 -0800
Message-Id: <1415648371-10586-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1415407132.23530.23.camel@perches.com>
References: <1415405880-8520-1-git-send-email-jwerner@chromium.org> <1415407132.23530.23.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch flags CamelCase identifiers in strict mode, but it has a
feature to ignore parts with only two characters to allow for SI units
like mV or uA. Unfortunately, not all SI units fit in two characters,
and not all are lower case followed by upper case.

This patch adds hardcoded detection for frequency and 1024-based size
units (Hz/KHz/MHz/GHz/THz and KiB/MiB/GiB/TiB), since allowing any three
character combinations might be too lenient. The list can later be
expanded as needed.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 scripts/checkpatch.pl | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 374abf4..b947c75 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4056,7 +4056,9 @@ sub process {
 #Ignore Page<foo> variants
 			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 #Ignore SI style variants like nS, mV and dB (ie: max_uV, regulator_min_uA_show)
-			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/) {
+			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/ &&
+#Ignore some three character SI units explicitly, like MiB and KHz
+			    $var !~ /^(?:[a-z_]*?)_?(?:[KMGT]iB|[KMGT]?Hz)(?:_[a-z_]+)?$/) {
 				while ($var =~ m{($Ident)}g) {
 					my $word = $1;
 					next if ($word !~ /[A-Z][a-z]|[a-z][A-Z]/);
-- 
2.1.2

