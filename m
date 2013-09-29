Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3I2T1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:27:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab3I2T1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:27:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Santos <daniel.santos@pobox.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 17/17] kernel-doc: bugfix - multi-line macros
Date: Sun, 29 Sep 2013 12:26:56 -0700
Message-Id: <20130929190758.311017758@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929190757.138351117@linuxfoundation.org>
References: <20130929190757.138351117@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Santos <daniel.santos@pobox.com>

commit 654784284430bf2739985914b65e09c7c35a7273 upstream.

Prior to this patch the following code breaks:

/**
 * multiline_example - this breaks kernel-doc
 */
 #define multiline_example( \
myparam)

Producing this error:

Error(somefile.h:983): cannot understand prototype: 'multiline_example( \ '

This patch fixes the issue by appending all lines ending in a blackslash
(optionally followed by whitespace), removing the backslash and any
whitespace after it prior to appending (just like the C pre-processor
would).

This fixes a break in kerel-doc introduced by the additions to rbtree.h.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/kernel-doc |    3 +++
 1 file changed, 3 insertions(+)

--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2044,6 +2044,9 @@ sub process_file($) {
 
     $section_counter = 0;
     while (<IN>) {
+	while (s/\\\s*$//) {
+	    $_ .= <IN>;
+	}
 	if ($state == 0) {
 	    if (/$doc_start/o) {
 		$state = 1;		# next line is always the function name


