Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbaFSO7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:59:22 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:49078 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932443AbaFSO7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:59:21 -0400
Date: Thu, 19 Jun 2014 09:59:18 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: percpu: micro-optimize round-to-even
In-Reply-To: <20140619143458.GF26904@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1406190957030.2785@gentwo.org>
References: <1403172149-25353-1-git-send-email-linux@rasmusvillemoes.dk> <20140619132536.GF11042@htj.dyndns.org> <alpine.DEB.2.11.1406190925430.2785@gentwo.org> <20140619143458.GF26904@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Tejun Heo wrote:

> Indeed, a patch?

Subject: percpu: Use ALIGN macro instead of hand coding alignment calculation

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/percpu.c
===================================================================
--- linux.orig/mm/percpu.c	2014-06-04 13:43:12.541466633 -0500
+++ linux/mm/percpu.c	2014-06-19 09:56:10.458023912 -0500
@@ -720,8 +720,7 @@ static void __percpu *pcpu_alloc(size_t
 	if (unlikely(align < 2))
 		align = 2;

-	if (unlikely(size & 1))
-		size++;
+	size = ALIGN(size, 2);

 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
 		WARN(true, "illegal size (%zu) or align (%zu) for "
