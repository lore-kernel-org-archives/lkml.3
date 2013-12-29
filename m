Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab3L2RSz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 12:18:55 -0500
Received: from mail.wdtv.com ([66.118.69.84]:34560 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab3L2RSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 12:18:54 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org
Subject: {BUG BISECT]
Date: Sun, 29 Dec 2013 12:18:44 -0500
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312291218.44269.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the copy/paste of the final git bisect bad report:

First, the reason for the bisect:
gene@coyote:~/linux-stable$ dmesg | grep -A2 microcode
[    0.518304] microcode: CPU0: patch_level=0x01000065
[    0.518396] microcode: CPU1: patch_level=0x01000065
[    0.518498] microcode: CPU2: patch_level=0x01000065
[    0.518593] microcode: CPU3: patch_level=0x01000065
[    0.518745] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba

The output above should have in each cpu case, a second, or final line 
showing a patch level 0x0100083 in all cases.
This failure is on an AMD phenom 9550 equipt machine.

I can and have built from the tarball pull, a 3.8.2 which does work 
correctly.  The tarball build of 3.8.3 fails as above, and a tarball build 
of 3.12.6 still fails.

gene@coyote:~/linux-stable$ git bisect bad
908e88f285b909011dc7dbce5abaacf123f2f68d is the first bad commit
commit 908e88f285b909011dc7dbce5abaacf123f2f68d
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Mon Feb 25 16:09:12 2013 +0000

I'll next do a "git checkout v3.8.2" to double check that it works.

Cheers, Gene
