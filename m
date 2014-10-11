Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaJKTHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 15:07:39 -0400
Received: from [213.75.39.8] ([213.75.39.8]:55589 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbaJKTHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 15:07:38 -0400
Message-ID: <1413054443.11953.22.camel@x220>
Subject: Re: [PATCH v2 1/2] kconfig: fix bad syntactic transformation in
 expr.c
From: Paul Bolle <pebolle@tiscali.nl>
To: Martin Walch <walch.martin@web.de>
Cc: yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 11 Oct 2014 21:07:23 +0200
In-Reply-To: <1411405999-20212-2-git-send-email-walch.martin@web.de>
References: <3491939.FtiyjGE4Of@tacticalops>
	 <1411405999-20212-1-git-send-email-walch.martin@web.de>
	 <1411405999-20212-2-git-send-email-walch.martin@web.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Oct 2014 19:07:23.0908 (UTC) FILETIME=[9704B440:01CFE586]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-22 at 19:13 +0200, Martin Walch wrote:
> Fix it by removing expr_eliminate_dups2() and the functions that have no use
> anywhere else: expr_extract_eq_and(), expr_extract_eq_or(),
> and expr_extract_eq() from scripts/kconfig/expr.[ch]
> 
> Currently the bug is not triggered in mainline, so this patch does not modify
> the configuration space there.

Would I be whining if I'd complained about the lack of documentation for
expr_eliminate_dups(), expr_eliminate_dups1(), and
expr_eliminate_dups2()?

So, I've put in these two calls of fprintf():
@@ -579,6 +606,7 @@ static void expr_eliminate_dups2(enum expr_type type, struct expr **ep1, struct
                tmp2 = expr_copy(e2);
                tmp = expr_extract_eq_and(&tmp1, &tmp2);
                if (expr_is_yes(tmp1)) {
+                       fprintf(stderr, "%s:%d:\n", __func__, __LINE__);
                        expr_free(e1);
                        e1 = expr_alloc_symbol(&symbol_no);
                        trans_count++;
@@ -594,6 +622,7 @@ static void expr_eliminate_dups2(enum expr_type type, struct expr **ep1, struct
                tmp2 = expr_copy(e2);
                tmp = expr_extract_eq_or(&tmp1, &tmp2);
                if (expr_is_no(tmp1)) {
+                       fprintf(stderr, "%s:%d:\n", __func__, __LINE__);
                        expr_free(e1);
                        e1 = expr_alloc_symbol(&symbol_yes);
                        trans_count++;

None of the 500+ defconfig files in next-20141010 triggered those
fprintf's.

Does that means it's likely that nothing in next-20141010 actually uses
the functionality expr_eliminate_dups2() provides?


Paul Bolle

