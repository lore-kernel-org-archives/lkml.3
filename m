Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050AbaAFX5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:57:30 -0500
Received: from smtprelay0050.hostedemail.com ([216.40.44.50]:46891 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932192AbaAFX50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 18:57:26 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:982:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2110:2196:2199:2393:2538:2553:2559:2562:2828:2895:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4385:4560:5007:6119:6120:7576:7652:7901:7903:9545:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12262:12438:12517:12519:12555:12679:12740:13071:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chess42_5dabf0e3bf217
X-Filterd-Recvd-Size: 3429
Message-ID: <1389052641.2433.16.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Only flag FSF address, not gnu.org URL
From: Joe Perches <joe@perches.com>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: gregkh@linuxfoundation.org, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 15:57:21 -0800
In-Reply-To: <20140106231534.23578.11475.stgit@ahduyck-cp2.jf.intel.com>
References: <20140106231534.23578.11475.stgit@ahduyck-cp2.jf.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 15:16 -0800, Alexander Duyck wrote:
> This change restricts the check for the for the FSF address in the GPL
> copyright statement so that it only flags the address, not the references to
> the gnu.org/licenses URL which appear in numerous drivers.

Hello Alexander

There is already a checkpatch fsf patch in -next.
Please make patches against that.

cheers, Joe

---

$ git show --format=email 365b438dd5d
>From 365b438dd5dbb1cd5f4310efe51a7aada8e481b4 Mon Sep 17 00:00:00 2001
From: Joe Perches <joe@perches.com>
Date: Fri, 3 Jan 2014 14:10:18 +1100
Subject: [PATCH] checkpatch: update the FSF/GPL address check

The FSF address check is a bit too verbose looking for the GPL text.
Quiet it a bit by requiring --strict for the GPL bit.

Also make the address tests match a few uses of abbreviations for street
names and make it case insensitive.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 7e48d13..59be6d7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1970,15 +1970,16 @@ sub process {
 		}
 
 # Check for FSF mailing addresses.
-		if ($rawline =~ /You should have received a copy/ ||
-		    $rawline =~ /write to the Free Software/ ||
-		    $rawline =~ /59 Temple Place/ ||
-		    $rawline =~ /51 Franklin Street/) {
+		if ($rawline =~ /\bYou should have received a copy/i ||
+		    $rawline =~ /\bwrite to the Free/i ||
+		    $rawline =~ /\b59\s+Temple\s+Pl/i ||
+		    $rawline =~ /\b51\s+Franklin\s+St/i) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			my $msg_type = \&ERROR;
 			$msg_type = \&CHK if ($file);
+			$msg_type = \&CHK if ($rawline =~ /\bYou should have received a copy/i);
 			&{$msg_type}("FSF_MAILING_ADDRESS",
-				"Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
+				     "Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
 		}
 
 # check for Kconfig help text having a real description


