Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaKIJLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 04:11:12 -0500
Received: from smtprelay0148.hostedemail.com ([216.40.44.148]:39605 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751177AbaKIJLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 04:11:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3870:3871:3872:4321:5007:6119:6261:7903:10004:10400:10848:11026:11232:11473:11658:11914:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: price55_2648bcdb7451c
X-Filterd-Recvd-Size: 1494
Message-ID: <1415524261.23530.37.camel@perches.com>
Subject: Re: [PATCH] lib: mpi: Use "static inline" instead of "extern
 inline" in header file for __GNUC__
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: dmitry.kasatkin@intel.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 09 Nov 2014 01:11:01 -0800
In-Reply-To: <545F2C99.4080607@gmail.com>
References: <545F2C99.4080607@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-09 at 16:58 +0800, Chen Gang wrote:
> In header file, "extern inline" may cause multiple definition, so need
> change it to "static inline". And also need be quoted  by __GNUC__ for
> they are as inline functions only for __GNUC__.
[]
> diff --git a/lib/mpi/mpi-inline.h b/lib/mpi/mpi-inline.h
[]
> @@ -30,7 +30,7 @@
>  #define G10_MPI_INLINE_H
>  
>  #ifndef G10_MPI_INLINE_DECL
> -#define G10_MPI_INLINE_DECL  extern inline
> +#define G10_MPI_INLINE_DECL  static inline

Why not remove the #define and use static inline
in the 4 places the #define is currently used?


