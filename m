Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab3GHRkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:40:11 -0400
Received: from plane.gmane.org ([80.91.229.3]:59962 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab3GHRkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:40:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Problem using gtags target
Date: Mon, 08 Jul 2013 18:22:18 +0100
Message-ID: <9hhtxk5nf05.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: fw-tnat.cambridge.arm.com
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Cancel-Lock: sha1:YSgEdqDVVud/bKwu3g6aV3ykyps=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to use GNU global for kernel source browsing but have run
into a problem when using "gtags" target in Makefile. The index
files(GTAGS, GSYMS, GPATH, GRTAGS) don't work and on further
investigation turned out to be 16kb each in size. My command line is - 

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j5 gtags

On some digging, I traced the relevant code to scripts/tags.sh which
produces reasonably sized indices (modulo some  missing environment
variables) when run as - 

./scripts/tags.sh gtags

I used the following patch

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 74f02e4..59b24ee 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -143,7 +143,8 @@ docscope()
 
 dogtags()
 {
-   all_target_sources | gtags -i -f -
+ all_target_sources > gtags.files
+ gtags -i -f gtags.files
 }
 
 exuberant()

to check the file list being produced and it seems correct but the
indices are still broken. Yet manually running

gtags -i -f gtags.files

does seem to do the right thing.

I was wondering if anybody has faced similar issues when using gtags and
how to fix this.

Thanks,
Punit

ps: Please include me in the cc as I am not subscribed to the list.

