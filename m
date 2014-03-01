Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaCAQWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 11:22:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:49667 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025AbaCAQWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 11:22:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,568,1389772800"; 
   d="scan'208";a="492169642"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com
Subject: Re: [PATCH 4/8] perf, tools: Enable printing the srcline in the history v2
References: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
	<1393561352-23448-5-git-send-email-andi@firstfloor.org>
Date: Sat, 01 Mar 2014 08:22:10 -0800
In-Reply-To: <1393561352-23448-5-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Thu, 27 Feb 2014 20:22:28 -0800")
Message-ID: <87fvn16g99.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> For lbr-as-callgraph we need to see the line number in the history,
> because many LBR entries can be in a single function, and just
> showing the same function name many times is not useful.

This patch broke the GTK build, fixed with this followon patch:

>From fd2b85cc85534f3a3b025b36bab6c42d31edc660 Mon Sep 17 00:00:00 2001
From: Andi Kleen <ak@linux.intel.com>
Date: Fri, 28 Feb 2014 16:53:40 -0800
Subject: [PATCH] perf, tools: Fix gtk compilation with src line patch.

Convert the gtk browser code to the new shared callchain_list__sym_name
function too.

Should be folded into "perf, tools: Enable printing the srcline in the history"

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 5b95c44..cafe105 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -123,15 +123,6 @@ void perf_gtk__init_hpp(void)
 				perf_gtk__hpp_color_overhead_guest_us;
 }
 
-static void callchain_list__sym_name(struct callchain_list *cl,
-				     char *bf, size_t bfsize)
-{
-	if (cl->ms.sym)
-		scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
-	else
-		scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
-}
-
 static void perf_gtk__add_callchain(struct rb_root *root, GtkTreeStore *store,
 				    GtkTreeIter *parent, int col, u64 total)
 {
@@ -162,7 +153,7 @@ static void perf_gtk__add_callchain(struct rb_root *root, GtkTreeStore *store,
 			scnprintf(buf, sizeof(buf), "%5.2f%%", percent);
 			gtk_tree_store_set(store, &iter, 0, buf, -1);
 
-			callchain_list__sym_name(chain, buf, sizeof(buf));
+			callchain_list__sym_name(chain, buf, sizeof(buf), false);
 			gtk_tree_store_set(store, &iter, col, buf, -1);
 
 			if (need_new_parent) {



-- 
ak@linux.intel.com -- Speaking for myself only
