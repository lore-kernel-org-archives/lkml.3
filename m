Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab3GPOun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:50:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61616 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab3GPOum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:50:42 -0400
Date: Tue, 16 Jul 2013 16:50:36 +0200
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH] perf tools: Fix 'make tools/perf'
Message-ID: <20130716145036.GH8731@rric.localhost>
References: <1370964158-4135-1-git-send-email-rric@kernel.org>
 <tip-107de3724eff5a6fa6474a4d2aa5460b63749ebf@git.kernel.org>
 <20130712093909.GD8731@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712093909.GD8731@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.07.13 10:39:09, Robert Richter wrote:

> On 12.07.13 01:49:40, tip-bot for Robert Richter wrote:
> > Commit-ID:  107de3724eff5a6fa6474a4d2aa5460b63749ebf
> > Gitweb:     http://git.kernel.org/tip/107de3724eff5a6fa6474a4d2aa5460b63749ebf
> > Author:     Robert Richter <robert.richter@linaro.org>
> > AuthorDate: Tue, 11 Jun 2013 17:22:38 +0200
> > Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> > CommitDate: Mon, 8 Jul 2013 17:34:00 -0300
> >
> > perf tools: Fix build errors with O and DESTDIR make vars set

>  $ make tools/perf
>      LINK /home/robert/cx/linux/tools/perf/perf
>  gcc: error: ../linux/tools/lib/lk/liblk.a: No such file or directory

Fix below.

-Robert


>From ff89180092114191b1871eaa2b6f18d17124b21e Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@linaro.org>
Date: Tue, 16 Jul 2013 15:46:27 +0200
Subject: [PATCH] perf tools: Fix 'make tools/perf'

Boris just raised another variant of building perf tools which is
broken:

 $ make tools/perf
 ...
     LINK /home/robert/cx/linux/tools/perf/perf
 gcc: error: ../linux/tools/lib/lk/liblk.a: No such file or directory

The variant wasn't considered by:

 107de37 perf tools: Fix build errors with O and DESTDIR make vars set

There are other variant of building perf too:

 $ make -C tools perf
 $ make -C tools/perf

Plus variants with O= and DESTDIR set.

This patch fixes the above and was tested with the following:

 $ make O=... DESTDIR=... tools/perf
 $ make O=... DESTDIR=... -C tools/ perf
 $ make O=... DESTDIR=... -C tools/perf
 $ make tools/perf
 $ make -C tools/ perf
 $ make -C tools/perf

Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 tools/perf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 641fccd..1d718a9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -124,7 +124,7 @@ strip-libs = $(filter-out -l%,$(1))
 ifneq ($(OUTPUT),)
   TE_PATH=$(OUTPUT)
 ifneq ($(subdir),)
-  LK_PATH=$(objtree)/lib/lk/
+  LK_PATH=$(OUTPUT)/../lib/lk/
 else
   LK_PATH=$(OUTPUT)
 endif
-- 
1.8.3.2

