Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441Ab3BZXxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:53:31 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53131 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab3BZXx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:53:28 -0500
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, Nishanth Menon <nm@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] PM / OPP: improve introductory documentation
Date: Tue, 26 Feb 2013 17:53:02 -0600
Message-ID: <1361922782-24993-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <[PATCH] PM / OPP: improve introductory documentation>
References: <[PATCH] PM / OPP: improve introductory documentation>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make Operating Performance Points (OPP) library introductory chapter
a little more reader-friendly. Split the chapter into two sections,
highlight the definition with an example and minor rewording to be
verbose.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-pm@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Nishanth Menon <nm@ti.com>
---
v2:
   review updates from v1

v1: https://patchwork.kernel.org/patch/2186921/
 originally reported in thread http://marc.info/?t=135760248900003&r=1&w=2

 Documentation/power/opp.txt |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/Documentation/power/opp.txt b/Documentation/power/opp.txt
index 3035d00..425c51d 100644
--- a/Documentation/power/opp.txt
+++ b/Documentation/power/opp.txt
@@ -1,6 +1,5 @@
-*=============*
-* OPP Library *
-*=============*
+Operating Performance Points (OPP) Library
+==========================================
 
 (C) 2009-2010 Nishanth Menon <nm@ti.com>, Texas Instruments Incorporated
 
@@ -16,15 +15,31 @@ Contents
 
 1. Introduction
 ===============
+1.1 What is an Operating Performance Point (OPP)?
+
 Complex SoCs of today consists of a multiple sub-modules working in conjunction.
 In an operational system executing varied use cases, not all modules in the SoC
 need to function at their highest performing frequency all the time. To
 facilitate this, sub-modules in a SoC are grouped into domains, allowing some
-domains to run at lower voltage and frequency while other domains are loaded
-more. The set of discrete tuples consisting of frequency and voltage pairs that
+domains to run at lower voltage and frequency while other domains run at
+voltage/frequency pairs that are higher.
+
+The set of discrete tuples consisting of frequency and voltage pairs that
 the device will support per domain are called Operating Performance Points or
 OPPs.
 
+As an example:
+Let us consider an MPU device which supports the following:
+{300MHz at minimum voltage of 1V}, {800MHz at minimum voltage of 1.2V},
+{1GHz at minimum voltage of 1.3V}
+
+We can represent these as three OPPs as the following {Hz, uV} tuples:
+{300000000, 1000000}
+{800000000, 1200000}
+{1000000000, 1300000}
+
+1.2 Operating Performance Points Library
+
 OPP library provides a set of helper functions to organize and query the OPP
 information. The library is located in drivers/base/power/opp.c and the header
 is located in include/linux/opp.h. OPP library can be enabled by enabling
-- 
1.7.9.5

