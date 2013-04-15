Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934880Ab3DORdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:33:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:36192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361Ab3DORdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,476,1363158000"; 
   d="scan'208";a="295215899"
Date: Mon, 15 Apr 2013 10:33:31 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [RFC 2/7] Docs: Step-by-step directions for reporting bugs.
Message-ID: <d60418bce5a2afe4ea838cda6a59c74ba8837c3f.1366046390.git.sarah.a.sharp@linux.intel.com>
References: <cover.1366046390.git.sarah.a.sharp@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1366046390.git.sarah.a.sharp@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

REPORTING-BUGS is pretty disorganized.  Bug reporters are likely to be
in a frustrated, stressed frame of mind, so introduce methodical
step-by-step directions for how to report bugs.  Use titles so people
can skim it if necessary.

Slight changes in procedures:

1. Encourage people to report bugs to maintainers and sub-system mailing
lists, not LKML at first.  I've seen way too many people get lost in the
noise because they didn't Cc the maintainer or proper mailing list.

2. Link to bugzilla.kernel.org, and let people know that some
maintainers prefer bugs filed there vs. the mailing lists.  (Perhaps we
need an entry in MAINTAINERS for which is preferred?)

3. If someone doesn't know where to report a bug, encourage them to both
file a bugzilla entry and email LKML.  Their report is less likely to
get lost if there's a bugzilla entry.

Preserve text about reporting security bugs, and get_maintainer.pl.

More will be added/modified in upcoming patches.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 REPORTING-BUGS |   65 +++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/REPORTING-BUGS b/REPORTING-BUGS
index ad709e4..6ed518b 100644
--- a/REPORTING-BUGS
+++ b/REPORTING-BUGS
@@ -1,3 +1,47 @@
+Identify the problematic subsystem
+----------------------------------
+
+Identifying which part of the Linux kernel might be causing your issue
+increases your chances of getting your bug fixed. Simply posting to the
+generic linux-kernel mailing list (LKML) may cause your bug report to be
+lost in the noise of a mailing list that gets 1000+ emails a day.
+
+Instead, try to figure out which kernel subsystem is causing the issue,
+and email that subsystem's maintainer and mailing list.  If the subsystem
+maintainer doesn't answer, then expand your scope to mailing lists like
+LKML.
+
+
+Identify who to notify
+----------------------
+
+Once you know the subsystem that is causing the issue, you should send a
+bug report.  Some maintainers prefer bugs to be reported via bugzilla
+(https://bugzilla.kernel.org), while others prefer that bugs be reported
+via the subsystem mailing list.
+
+To find out where to send an emailed bug report, find your subsystem or
+device driver in the MAINTAINERS file.  Search in the file for relevant
+entries, and send your bug report to the person(s) listed in the "M:"
+lines, making sure to Cc the mailing list(s) in the "L:" lines.  When the
+maintainer replies to you, make sure to 'Reply-all' in order to keep the
+public mailing list(s) in the email thread.
+
+If you know which driver is causing issues, you can pass one of the driver
+files to the get_maintainer.pl script:
+     perl scripts/get_maintainer.pl -f <filename>
+
+If it is a security bug, please copy the Security Contact listed in the
+MAINTAINERS file.  They can help coordinate bugfix and disclosure.  See
+Documentation/SecurityBugs for more information.
+
+If you can't figure out which subsystem caused the issue, you should file
+a bug in kernel.org bugzilla and send email to
+linux-kernel@vger.kernel.org, referencing the bugzilla URL.  (For more
+information on the linux-kernel mailing list see
+http://www.tux.org/lkml/).
+
+
 [Some of this is taken from Frohwalt Egerer's original linux-kernel FAQ]
 
 What follows is a suggested procedure for reporting Linux bugs. You aren't
@@ -9,25 +53,8 @@ please read "Documentation/oops-tracing.txt" before posting your bug
 report. This explains what you should do with the "Oops" information to
 make it useful to the recipient.
 
-Send the output to the maintainer of the kernel area that seems to be
-involved with the problem, and cc the relevant mailing list. Don't worry
-too much about getting the wrong person. If you are unsure send it to the
-person responsible for the code relevant to what you were doing.  If it
-occurs repeatably try and describe how to recreate it. That is worth even
-more than the oops itself.  The list of maintainers and mailing lists is
-in the MAINTAINERS file in this directory.  If you know the file name that
-causes the problem you can use the following command in this directory to
-find some of the maintainers of that file:
-
-     perl scripts/get_maintainer.pl -f <filename>
-
-If it is a security bug, please copy the Security Contact listed in the
-MAINTAINERS file.  They can help coordinate bugfix and disclosure.  See
-Documentation/SecurityBugs for more information.
-
-If you are totally stumped as to whom to send the report, send it to
-linux-kernel@vger.kernel.org. (For more information on the linux-kernel
-mailing list see http://www.tux.org/lkml/).
+If it occurs repeatably try and describe how to recreate it. That is worth
+even more than the oops itself.
 
 This is a suggested format for a bug report sent to the Linux kernel mailing
 list. Having a standardized bug report form makes it easier for you not to
-- 
1.7.9

