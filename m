Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3KTAeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:34:17 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:6668 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751561Ab3KTAeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:34:16 -0500
Date: Tue, 19 Nov 2013 19:34:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Yang Bai <hamo.by@gmail.com>
Subject: Re: [PATCH] scripts: Have make TAGS not include structure members
Message-ID: <20131119193414.48912cbd@gandalf.local.home>
In-Reply-To: <528BFFBF.4050807@codeaurora.org>
References: <20131115093645.6dc03918@gandalf.local.home>
	<CAMuHMdXSBSOkfd2MGbn=rpXQRZYw5TKLsR=3SoeSyrcD2CzunA@mail.gmail.com>
	<20131119155907.11fbdecea0aa40764a3d927a@linux-foundation.org>
	<20131119190426.27b010e4@gandalf.local.home>
	<20131119160855.2527630f87d060801d9ee3bb@linux-foundation.org>
	<20131119191435.4dce1499@gandalf.local.home>
	<528BFFBF.4050807@codeaurora.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013 16:18:07 -0800
Stephen Boyd <sboyd@codeaurora.org> wrote:
 
> I didn't have exuberant-ctags installed so 'make tags' was building the
> emacs tag file as 'tags' and vim was using it just fine. Please note
> that you may be affecting vim users with this change if they haven't
> installed exuberant-ctags.

I'm aware of that, as one of my boxes I tested this on also doesn't have
exuberant-ctags either.

I wasn't going to use this change, but instead add this change:


---
 scripts/tags.sh |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-trace.git/scripts/tags.sh
===================================================================
--- linux-trace.git.orig/scripts/tags.sh	2013-11-19 19:29:34.352371615 -0500
+++ linux-trace.git/scripts/tags.sh	2013-11-19 19:32:37.821152204 -0500
@@ -218,7 +218,7 @@ exuberant()
 
 emacs()
 {
-	all_target_sources | xargs $1 -a                        \
+	all_target_sources | xargs $@ -a                        \
 	--regex='/^\(ENTRY\|_GLOBAL\)(\([^)]*\)).*/\2/'         \
 	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
 	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
@@ -263,7 +263,7 @@ xtags()
 	if $1 --version 2>&1 | grep -iq exuberant; then
 		exuberant $1
 	elif $1 --version 2>&1 | grep -iq emacs; then
-		emacs $1
+		emacs $@
 	else
 		all_target_sources | xargs $1 -a
         fi
@@ -313,7 +313,7 @@ case "$1" in
 
 	"TAGS")
 		rm -f TAGS
-		xtags etags
+		xtags etags --no-members
 		remove_structs=y
 		;;
 esac



-- Steve
