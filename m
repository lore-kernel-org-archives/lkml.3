Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3JESnQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 14:43:16 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:37445 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3JESnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 14:43:15 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 5 Oct 2013 11:43:08 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] checkpatch.pl: Check for the FSF mailing address
Message-ID: <20131005184307.GA6429@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel maintainers reject new instances of the GPL boilerplate paragraph
directing people to write to the FSF for a copy of the GPL, since the
FSF has moved in the past and may do so again.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Inspired by Greg's standard response to omit the paragraph "unless you
want to track the movements of the FSF's office for the next 40 years."

 scripts/checkpatch.pl | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2ee9eb7..2d7cc45 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1859,6 +1859,16 @@ sub process {
 			$rpt_cleaners = 1;
 		}
 
+# Check for FSF mailing addresses.
+		if ($rawline =~ /You should have received a copy/ ||
+		    $rawline =~ /write to the Free Software/ ||
+		    $rawline =~ /59 Temple Place/ ||
+		    $rawline =~ /51 Franklin Street/) {
+			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
+			ERROR("FSF_MAILING_ADDRESS",
+			      "Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
+		}
+
 # check for Kconfig help text having a real description
 # Only applies when adding the entry originally, after that we do not have
 # sufficient context to determine whether it is indeed long enough.
-- 
1.8.4.rc3

