Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaEZUd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:33:59 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:65295 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaEZUdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:33:55 -0400
Message-Id: <20140526203352.885433946@networkplumber.org>
User-Agent: quilt/0.63-1
Date: Mon, 26 May 2014 13:33:10 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 1/4] get_maintainer: use three argument open
References: <20140526203309.782169359@networkplumber.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=get_maintainer-perlcritic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use 3 argument open to avoid any issues with parsing
and silence perlcritic.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

--- a/scripts/get_maintainer.pl	2014-05-26 12:47:35.039720690 -0700
+++ b/scripts/get_maintainer.pl	2014-05-26 13:27:52.000000000 -0700
@@ -426,7 +426,7 @@ foreach my $file (@ARGV) {
 	my $file_cnt = @files;
 	my $lastfile;
 
-	open(my $patch, "< $file")
+	open(my $patch, '<', $file)
 	    or die "$P: Can't open $file: $!\n";
 
 	# We can check arbitrary information before the patch

