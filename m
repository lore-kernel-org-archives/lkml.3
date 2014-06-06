Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaFFSdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:33:19 -0400
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:46708 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751279AbaFFSdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:33:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3867:3871:4321:4605:5007:7652:7904:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12555:12740:13069:13221:13229:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: frame53_56c81bc7c9a17
X-Filterd-Recvd-Size: 2942
Message-ID: <1402079594.13264.18.camel@joe-AO725>
Subject: [PATCH] checkpatch: Fix function pointers in blank line needed
 after declarations test
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Allan, Bruce W" <bruce.w.allan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>
Date: Fri, 06 Jun 2014 11:33:14 -0700
In-Reply-To: <804857E1F29AAC47BF68C404FC60A184656254DF@ORSMSX105.amr.corp.intel.com>
References: <20140604225241.16944.94025.stgit@gitlad.jf.intel.com>
	 <20140604225343.16944.46261.stgit@gitlad.jf.intel.com>
	 <804857E1F29AAC47BF68C404FC60A18465623125@ORSMSX105.amr.corp.intel.com>
	 <1402071084.13264.0.camel@joe-AO725>
	 <804857E1F29AAC47BF68C404FC60A184656232C2@ORSMSX105.amr.corp.intel.com>
	 <1402072268.13264.4.camel@joe-AO725>
	 <804857E1F29AAC47BF68C404FC60A184656254DF@ORSMSX105.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function pointer declaration check to the
test for blank line needed after declarations.

Reported-by: Bruce W Allan <bruce.w.allan@intel.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
On Fri, 2014-06-06 at 17:23 +0000, Allan, Bruce W wrote:
> > WARNING: Missing a blank line after declarations
> > #318: FILE: drivers/crypto/qat/qat_common/adf_accel_devices.h:140:
> > +	struct adf_hw_device_class *dev_class;
> > +	uint32_t (*get_accel_mask)(uint32_t fuse);
> 
> This one is a false positive from checkpatch

 scripts/checkpatch.pl | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 010b18e..f4b8911 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2295,6 +2295,8 @@ sub process {
 		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
 			# actual declarations
 		    ($prevline =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
+			# function pointer declarations
+		     $prevline =~ /^\+\s+$Declare\s*\(\s*\*\s*$Ident\s*\)\s*[=,;:\[\(]/ ||
 			# foo bar; where foo is some local typedef or #define
 		     $prevline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
@@ -2307,6 +2309,8 @@ sub process {
 		      $prevline =~ /(?:\{\s*|\\)$/) &&
 			# looks like a declaration
 		    !($sline =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
+			# function pointer declarations
+		      $sline =~ /^\+\s+$Declare\s*\(\s*\*\s*$Ident\s*\)\s*[=,;:\[\(]/ ||
 			# foo bar; where foo is some local typedef or #define
 		      $sline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros


