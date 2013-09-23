Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab3IWJBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:01:08 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44527 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3IWJBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:01:06 -0400
Date: Mon, 23 Sep 2013 12:01:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: checkpatch guide for newbies
Message-ID: <20130923090100.GE6192@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've written a checkpatch guide for newbies because it seems like they
make the same mistakes over and over.  I intend to put it under
Documentation/.  Could you look it over?


		Introduction

This document is aimed at new kernel contributors using "checkpatch.pl --file".

The first thing to remember is that the aim is not to get rid of every
checkpatch.pl warning; the aim is to make the code cleaner and more readable.
The other thing to remember is that checkpatch.pl is not a very smart tool and
there are mistakes that it misses so keep your eyes open for those as well.

For example, checkpatch.pl could warn about a badly formatted warning message.
Ask yourself, is the warning message is clear?  Is it needed?  Could a
non-privileged user trigger the warning and flood the syslog?  Are there
spelling mistakes?  Since Checkpatch.pl has flagged the line as sloppy code,
there may be multiple mistakes.

In the Linux kernel, we take an enormous pride in our work and we want clean
code.  But the one major drawback to cleanup patches is that they break
"git blame" so it's not a good idea for newbies to send very trivial cleanup
patches to the kernel/ directory.  It's better to get a little experience in the
drivers/ directory first.  The drivers/staging/ directory in particular always
needs cleanup patches.


		General Hints

1)  Don't put too many things in one patch because it makes it hard to review.
Break the patch up into a patch series like this made up example:

[PATCH 1/4] subsystem: driver: Use tabs to indent instead of spaces
[PATCH 2/4] subsystem: driver: Add spaces around math operations
[PATCH 3/4] subsystem: driver: Remove extra braces
[PATCH 4/4] subsystem: driver: Delete LINUX_VERSION_CODE related code


		Long Lines

Historically screens were 80 characters wide and it was annoying when code went
over the edge.  These days we have larger screens, but we keep the 80 character
limit because it forces us to write simpler code.

One way to remove indent levels is using functions.  If you find yourself
writing a loop or a switch statement and you're already indented several tabs
then probably it should be a new function instead.

Whenever possible return immediately.
Bad:
-	foo = kmalloc();
-	if (foo) {
-		/* code indent 2 tabs */
-	}
-	return foo;
Good:
+	foo = kmalloc();
+	if (!foo)
+		return NULL;
+	/* code indented 1 tab */
+	return foo;

Choose shorter names.
Bad:
-	for(uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords;
-	    uiIpv6AddIndex++) {
Good:
+	for (i = 0; i < long_words; i++) {

Use temporary variable names:
Bad:
-	dev->backdev[count]->bitlistsize =
-		dev->backdev[count]->devmagic->bitlistsize;
Good:
+	back = dev->backdev[count];
+	back->bitlistsize = back->devmagic->bitlistsize;

Don't do complicated things in the initializer:
Bad:
-	struct binder_ref_death *tmp_death = container_of(w,
-						struct binder_ref_death, work);
Good:
+	struct binder_ref_death *tmp_death;
+
+	tmp_death = container_of(w, struct binder_ref_death, work);

If you must break up a long line then align it nicely.  Use spaces if needed.
Bad:
-	if (adapter->flowcontrol == FLOW_RXONLY ||
-			adapter->flowcontrol == FLOW_BOTH) {
Good:
+	if (adapter->flowcontrol == FLOW_RXONLY ||
+	    adapter->flowcontrol == FLOW_BOTH) {

It's preferred if the operator goes at the end of the first line instead of at
the start of the second line:
Bad:
-	PowerData = (1 << 31) | (0 << 30) | (24 << 24)
-		    | BitReverse(w89rf242_txvga_data[i][0], 24);
Good:
+	PowerData = (1 << 31) | (0 << 30) | (24 << 24) |
+		    BitReverse(w89rf242_txvga_data[i][0], 24);


		Writing the Changelog

Use the word "cleanup" instead of "fix".  "Fix" implies the runtime changed and
it fixes a bug.  "Cleanup" implies that runtime stayed exactly the same.



