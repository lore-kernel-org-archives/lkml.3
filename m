Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab3LKA0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 19:26:23 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:57852 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3LKA0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:26:20 -0500
Date: Tue, 10 Dec 2013 16:26:14 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] checkpatch: add warning of future __GFP_NOFAIL use
In-Reply-To: <alpine.DEB.2.02.1312101618530.22701@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1312101624330.22701@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312091355360.11026@chino.kir.corp.google.com> <20131209152202.df3d4051d7dc61ada7c420a9@linux-foundation.org> <alpine.DEB.2.02.1312101504120.22701@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1312101618530.22701@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gfp.h and page_alloc.c already specify that __GFP_NOFAIL is deprecated and 
no new users should be added.

Add a warning to checkpatch to catch this.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9c98100..6667689 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4114,6 +4114,12 @@ sub process {
 			     "$1 uses number as first arg, sizeof is generally wrong\n" . $herecurr);
 		}
 
+# check for GFP_NOWAIT use
+		if ($line =~ /\b__GFP_NOFAIL\b/) {
+			WARN("__GFP_NOFAIL",
+			     "Use of __GFP_NOFAIL is deprecated, no new users should be added\n" . $herecurr);
+		}
+
 # check for multiple semicolons
 		if ($line =~ /;\s*;\s*$/) {
 			if (WARN("ONE_SEMICOLON",
