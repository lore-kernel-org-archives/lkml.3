Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab3A2BoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:44:22 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:43941 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3A2BoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:44:20 -0500
Date: Mon, 28 Jan 2013 17:44:23 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Petr Holasek <pholasek@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/11] ksm: trivial tidyups
In-Reply-To: <20130128151119.b74d0150.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1301281738570.4947@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <alpine.LNX.2.00.1301251757020.29196@eggly.anvils> <20130128151119.b74d0150.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Andrew Morton wrote:
> On Fri, 25 Jan 2013 17:58:11 -0800 (PST)
> Hugh Dickins <hughd@google.com> wrote:
> 
> > +#ifdef CONFIG_NUMA
> > +#define NUMA(x)		(x)
> > +#define DO_NUMA(x)	(x)
> 
> Did we consider
> 
> 	#define DO_NUMA do { (x) } while (0)
> 
> ?

It didn't occur to me at all.  I like that it makes more sense of
the DO_NUMA variant.  Is it okay that, to work with the way I was
using it, we need "(x);" in there rather than just "(x)"?

> 
> That could avoid some nasty config-dependent compilation issues.
> 
> > +#else
> > +#define NUMA(x)		(0)

[PATCH] ksm: trivial tidyups fix

Suggested by akpm: make DO_NUMA(x) do { (x); } while (0) more like the #else.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm.org/mm/ksm.c	2013-01-27 09:55:45.000000000 -0800
+++ mmotm/mm/ksm.c	2013-01-28 16:50:25.772026446 -0800
@@ -43,7 +43,7 @@
 
 #ifdef CONFIG_NUMA
 #define NUMA(x)		(x)
-#define DO_NUMA(x)	(x)
+#define DO_NUMA(x)	do { (x); } while (0)
 #else
 #define NUMA(x)		(0)
 #define DO_NUMA(x)	do { } while (0)
