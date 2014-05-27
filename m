Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaE0BWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:22:12 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55929 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaE0BWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:22:11 -0400
Date: Mon, 26 May 2014 18:22:07 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/4] get_maintainer: shut up perl critic
Message-ID: <20140526182207.34900c22@nehalam.linuxnetplumber.net>
In-Reply-To: <1401152635.519.42.camel@joe-AO725>
References: <20140526203309.782169359@networkplumber.org>
	<1401152449.519.41.camel@joe-AO725>
	<1401152635.519.42.camel@joe-AO725>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the no critic annotation, with comment, to silence perl critic
for places where the code is correct as is.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

---

Supersedes patch 1

--- a/scripts/get_maintainer.pl	2014-05-26 18:09:38.257783683 -0700
+++ b/scripts/get_maintainer.pl	2014-05-26 18:19:25.782478516 -0700
@@ -231,7 +231,10 @@ if ($version != 0) {
     exit 0;
 }
 
+# For this usage requiring IO::Interactive is overkill
+## no critic (ProhibitInteractiveTest)
 if (-t STDIN && !@ARGV) {
+    ## use critic
     # We're talking to a terminal, but have no command line arguments.
     die "$P: missing patchfile or -f file - use --help if necessary\n";
 }
@@ -423,8 +426,13 @@ foreach my $file (@ARGV) {
 	my $file_cnt = @files;
 	my $lastfile;
 
+	# Use two argument form of open because we want
+	# to allow using "-" to indicate standard input
+
+	## no critic (ProhibitTwoArgOpen)
 	open(my $patch, "< $file")
 	    or die "$P: Can't open $file: $!\n";
+	## use critic
 
 	# We can check arbitrary information before the patch
 	# like the commit message, mail headers, etc...
