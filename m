Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbaFSANO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 20:13:14 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37810 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbaFSANL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 20:13:11 -0400
Date: Wed, 18 Jun 2014 17:13:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] builddeb: fix errors caused by objtree redefinition
Message-ID: <20140619001305.GA24952@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 7e1c04779efd51154baf652e653ceb24ce68939b ("kbuild: Use
relative path for $(objtree)"), objtree was redefined from whatever
$(CURDIR) is to a simple ".".  Unfortunately, this breaks builddeb,
which was relying on $objtree to be an absolute path, not a relative
one.  Since the script is run from the object directory, pick up a
more absolute value for objtree where it's needed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scripts/package/builddeb |    1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 2f3ec77..ce7d05b 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -299,6 +299,7 @@ EOF
 fi
 
 # Build header package
+objtree="$(pwd)"
 (cd $srctree; find . -name Makefile\* -o -name Kconfig\* -o -name \*.pl > "$objtree/debian/hdrsrcfiles")
 (cd $srctree; find arch/$SRCARCH/include include scripts -type f >> "$objtree/debian/hdrsrcfiles")
 (cd $objtree; find arch/$SRCARCH/include Module.symvers include scripts -type f >> "$objtree/debian/hdrobjfiles")
