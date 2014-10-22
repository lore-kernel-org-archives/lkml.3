Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbaJVToO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:44:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161AbaJVToM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:44:12 -0400
Date: Wed, 22 Oct 2014 21:44:08 +0200
From: Michal Marek <mmarek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Peter Foley <pefoley2@pefoley.com>, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kbuild: Fix output of make kernelrelease
Message-ID: <20141022194408.GA20989@pobox.suse.cz>
References: <20141022101944.70d637cc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022101944.70d637cc@gandalf.local.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 22.10.2014 v 16:19 Steven Rostedt napsal(a):
> 
> Commit 7ff525712acf "kbuild: fake the "Entering directory ..." message
> more simply" changed the output of "make kernelrelease" such that the
> kernel release version was not the last line printed. This broke various
> tools that would find the kernel release with "make kernelrelease | tail -1".

The cleaner and recommended (see recent make help) way is to use make -s:

$ make O=build -s kernelrelease
3.18.0-rc1+

no further processing is needed.


> One of those tools that broke was ktest.pl which resides in the kernel.

Can you please apply this patch?

Thanks,
Michal

>From c660b235e25eee053337e0e6c952e87f39839c63 Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.cz>
Date: Wed, 22 Oct 2014 21:25:39 +0200
Subject: [PATCH] ktest: Use make -s kernelrelease

The previous tail -1 broke with commit 7ff525712acf ("kbuild: fake the
"Entering directory ..." message more simply")

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 tools/testing/ktest/ktest.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index bf13981..60fe020 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2005,7 +2005,7 @@ sub get_version {
     # get the release name
     return if ($have_version);
     doprint "$make kernelrelease ... ";
-    $version = `$make kernelrelease | tail -1`;
+    $version = `$make -s kernelrelease`;
     chomp($version);
     doprint "$version\n";
     $have_version = 1;
-- 
1.9.2

