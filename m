Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216AbaGQPwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:52:09 -0400
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:34423 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757360AbaGQPwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:52:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:982:988:989:1260:1345:1437:1534:1541:1711:1730:1747:1777:1792:1981:2194:2198:2199:2200:2393:2553:2559:2562:2731:2919:3138:3139:3140:3141:3142:3352:3653:3865:3866:3867:3868:3870:3871:3872:3874:5007:6261:7903:7904:10004:10026:10848:11658:11914:12043:12291:12517:12519:12679:12683:13311:13357:14093:14095:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sail94_2f44415664052
X-Filterd-Recvd-Size: 1911
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Hartley Sweeten <HartleyS@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] checkpatch: Add missing c90 types
Date: Thu, 17 Jul 2014 08:52:00 -0700
Message-Id: <cover.1405609481.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c90 section "6.7.2 Type Specifiers" says:
    "type specifiers may occur in any order"

That means that:
    short int is the same as int short
    unsigned short int is the same as int unsigned short
    etc...

checkpatch currently parses only a subset of these allowed types.

For instance: "unsigned short" is a found by checkpatch as a
specific type, but none of the "signed int" or "int short" variants
are found.

Change all the existing types to allow signed and unsigned variants.
Reorder the existing types array to match longest type first.

Add another table for the "kernel style misordered" variants.

Add this misordered table to the findable types.

Warn when the misordered style is used.

This improves the "Missing a blank line after declarations" test as
it depends on the correct parsing of the $Declare variable which
looks for "$Type $Ident;" (ie: declarations like "int foo;").

Joe Perches (3):
  checkpatch: Add short int to c variable types
  checkpatch: Add signed generic types
  checkpatch: Add test for native c90 types in unusual order

 scripts/checkpatch.pl | 61 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 8 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

