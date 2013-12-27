Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3L0A6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 19:58:46 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59290 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3L0A6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 19:58:45 -0500
X-Originating-IP: 50.43.14.201
Date: Thu, 26 Dec 2013 16:58:35 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>, akpm@linux-foundation.org
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] checkpatch: Add tests for function pointer style
 misuses
Message-ID: <20131227005835.GA10986@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <52bcaaaa.D88khTPM+2orJGqY%akpm@linux-foundation.org>
 <20131226200723.GA7267@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 12:07:23PM -0800, Josh Triplett wrote:
> On Thu, Dec 26, 2013 at 11:20:28AM -0800, Joe Perches wrote:
> > Kernel style uses function pointers in this form:
> >         "type (*funcptr)(args...)"
> > 
> > Emit warnings when this function pointer form isn't used.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Two comments below.

On Thu, Dec 26, 2013 at 02:16:10PM -0800, akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: checkpatch: add tests for function pointer style misuses
> has been added to the -mm tree.  Its filename is
>      checkpatch-add-tests-for-function-pointer-style-misuses.patch

Here's a patch that fixes the two messages I commented about, which
applies on top of the version of the patch that went into -mm.

---8<---
From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH] Fix up messages from "checkpatch: Add tests for function pointer style misuses"

Fix an ambiguity in one warning message and a copy/paste problem in
another.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2460094..b74b086 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2831,7 +2831,7 @@ sub process {
 			if (defined $pre_pointer_space &&
 			    $pre_pointer_space =~ /^\s/) {
 				WARN("SPACING",
-				     "Unnecessary space after function pointer open parenthesis\n" . $herecurr);
+				     "Unnecessary space between open parenthesis and '*' in function pointer declaration\n" . $herecurr);
 			}
 
 # unnecessary space "type (* funcptr)(args...)"
@@ -2852,7 +2852,7 @@ sub process {
 			if (defined $pre_args_space &&
 			    $pre_args_space =~ /^\s/) {
 				WARN("SPACING",
-				     "Unnecessary space before function pointer name\n" . $herecurr);
+				     "Unnecessary space before function pointer argument list\n" . $herecurr);
 			}
 
 			if (show_type("SPACING") && $fix) {
-- 
1.8.5.2

