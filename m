Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbaGHRxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:53:42 -0400
Received: from smtprelay0135.hostedemail.com ([216.40.44.135]:37064 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753747AbaGHRxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:53:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:355:379:541:982:988:989:1260:1345:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3653:3865:3867:3868:3870:3871:3872:3874:4250:5007:6261:7688:10004:10026:10848:11658:11914:12043:12291:12517:12519:12679:12683:13161:13229:13311:13357:14095:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shape67_29e52fdefd30
X-Filterd-Recvd-Size: 2166
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] checkpatch: Add ability to insert/delete lines
Date: Tue,  8 Jul 2014 10:53:34 -0700
Message-Id: <cover.1404840958.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Creating patches for files or modifying existing patches can be a bit
easier when lines need to be added or deleted.

Here's a start at that.

There are still false positives for things like

For example, this can be useful for staging where blank lines after
declarations are desired.

For instance: (using --strict also enables multiple blank line removals)

for a single file:

$ ./scripts/checkpatch.pl -f --fix-inplace --strict --types=line_spacing \
  drivers/staging/android/binder.c
$ git diff --shortstat drivers/staging/android/binder.c
 1 file changed, 4 insertions(+), 4 deletions(-)

for all files in drivers/staging:

$ git ls-files "drivers/staging/*.[ch]" | \
  xargs ./scripts/checkpatch.pl -f --fix-inplace --strict --types=line_spacing
$ git diff --shortstat drivers/staging/
 1028 files changed, 2513 insertions(+), 3540 deletions(-)

There are still some false positives like:

drivers/staging/ced1401/use14_ioc.h where an old Microsoftism for FAR is used.
The test adds an unnecessary blank line there.

So, as ever, this is just a convenience function.
Don't rely on it.
  
Joe Perches (2):
  checkpatch: Add an index variable for fixed lines
  checkpatch: Add ability to insert and delete lines to patch/file

 scripts/checkpatch.pl | 255 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 190 insertions(+), 65 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

