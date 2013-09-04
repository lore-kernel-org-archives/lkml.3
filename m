Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577Ab3IDAeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:34:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46414 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761498Ab3IDAea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:34:30 -0400
Message-ID: <1378254868.7347.40.camel@joe-AO722>
Subject: [PATCH] kernel-doc: Update script to find more "Return:" sections
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@infradead.org>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Date: Tue, 03 Sep 2013 17:34:28 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many kernel-doc return description sections headers
use variants of the "Return:" section prefix.

(some or maybe even most of these aren't in
 kernel-doc sections, but many are)

$ git grep -E -i "^\s*\*\s*return[s]?:"| \
  cut -f2- -d":" | awk '{print $1 $2}' | \
  sort | uniq -c
    121 *return:
    838 *Return:
    778 *RETURN:
    191 *returns:
   1965 *Returns:
    603 *RETURNS:

Rather than change all of the variants to the
canonical "Return:", adapt the script to accept
case insensitive "Return:" and "Returns:"

Signed-off-by: Joe Perches <joe@perches.com>
---

I don't know that this actually works.
It does seem right though.

Randy?  Rob?  Can you test this please?

 scripts/kernel-doc | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 4305b2f..2b96411 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -418,6 +418,7 @@ sub dump_section {
 	$parameterdescs{$name} = $contents;
 	$sectcheck = $sectcheck . $name . " ";
     } else {
+	$name = "Return" if $name =~ /^return[s]?$/i;
 #	print STDERR "other section '$name' = '$contents'\n";
 	if (defined($sections{$name}) && ($sections{$name} ne "")) {
 		print STDERR "Error(${file}:$.): duplicate section name '$name'\n";


