Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3G3SRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:17:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57616 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753894Ab3G3SRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:17:07 -0400
Message-ID: <1375208226.2075.126.camel@joe-AO722>
Subject: [PATCH] checkpatch: Ignore #define TRACE_<foo> macros
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Li Zefan <lizefan@huawei.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Tue, 30 Jul 2013 11:17:06 -0700
In-Reply-To: <51F73237.1010606@huawei.com>
References: <20130729195201.GC14883@xanatos> <51F7171C.4060100@huawei.com>
	 <1375149538.2075.95.camel@joe-AO722> <51F71FBC.6030600@huawei.com>
	 <1375151796.2075.97.camel@joe-AO722> <51F72D55.7050108@huawei.com>
	 <1375153806.2075.100.camel@joe-AO722> <51F73237.1010606@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracing subsystem uses slightly odd #defines
to set path/directory locations for include files.

These #defines can cause false positives for the
complex macro tests so add exclusions for these
specific #defines (TRACE_SYSTEM, TRACE_INCLUDE_FILE,
TRACE_INCLUDE_PATH).

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2ee9eb7..998ad8f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3374,7 +3374,8 @@ sub process {
 			    $dstat !~ /^for\s*$Constant$/ &&				# for (...)
 			    $dstat !~ /^for\s*$Constant\s+(?:$Ident|-?$Constant)$/ &&	# for (...) bar()
 			    $dstat !~ /^do\s*{/ &&					# do {...
-			    $dstat !~ /^\({/)						# ({...
+			    $dstat !~ /^\({/ &&						# ({...
+			    $ctx !~ /^.\s*#\s*define\s+TRACE_(?:SYSTEM|INCLUDE_FILE|INCLUDE_PATH)\b/)
 			{
 				$ctx =~ s/\n*$//;
 				my $herectx = $here . "\n";


