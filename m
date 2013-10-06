Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3JFWXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 18:23:51 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33714 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab3JFWXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 18:23:50 -0400
X-Originating-IP: 50.43.39.152
Date: Sun, 6 Oct 2013 15:23:42 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: [PATCHv2] checkpatch.pl: Check for the FSF mailing address
Message-ID: <20131006222342.GT19510@leaf>
References: <20131005184307.GA6429@leaf>
 <1380999108.2081.138.camel@joe-AO722>
 <20131006062739.GA5218@kroah.com>
 <20131006211855.GB19510@leaf>
 <1381094837.2081.160.camel@joe-AO722>
 <20131006213309.GO19510@leaf>
 <1381096127.2081.166.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381096127.2081.166.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel maintainers reject new instances of the GPL boilerplate paragraph
directing people to write to the FSF for a copy of the GPL, since the
FSF has moved in the past and may do so again.

Make this an error for new code, but just a --strict CHK in --file mode;
anyone interested in doing tree-wide cleanups of this form can enable
this test explicitly.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

v2: Make this a CHK in --file mode, using a code pattern suggested by
    Joe Perches.

 scripts/checkpatch.pl | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2ee9eb7..9161533 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1859,6 +1859,18 @@ sub process {
 			$rpt_cleaners = 1;
 		}
 
+# Check for FSF mailing addresses.
+		if ($rawline =~ /You should have received a copy/ ||
+		    $rawline =~ /write to the Free Software/ ||
+		    $rawline =~ /59 Temple Place/ ||
+		    $rawline =~ /51 Franklin Street/) {
+			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
+			my $msg_type = \&ERROR;
+			$msg_type = \&CHK if ($file);
+			&{$msg_type}("FSF_MAILING_ADDRESS",
+				"Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
+		}
+
 # check for Kconfig help text having a real description
 # Only applies when adding the entry originally, after that we do not have
 # sufficient context to determine whether it is indeed long enough.
-- 
1.8.4.rc3

