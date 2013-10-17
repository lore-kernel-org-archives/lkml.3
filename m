Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207Ab3JQC7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 22:59:16 -0400
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:39300 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762180Ab3JQC7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 22:59:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1978:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:4250:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,M
X-HE-Tag: land24_6d5880bb4b938
X-Filterd-Recvd-Size: 2078
Message-ID: <1381978749.22110.76.camel@joe-AO722>
Subject: Re: [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
From: Joe Perches <joe@perches.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, bp@alien8.de, naveen.n.rao@linux.vnet.ibm.com,
        m.chehab@samsung.com, arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Date: Wed, 16 Oct 2013 19:59:09 -0700
In-Reply-To: <1381935366-11731-4-git-send-email-gong.chen@linux.intel.com>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
	 <1381935366-11731-4-git-send-email-gong.chen@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 10:56 -0400, Chen, Gong wrote:
> GENMASK is used to create a contiguous bitmask([hi:lo]). It is
> implemented twice in current kernel. One is in EDAC driver, the other
> is in SiS/XGI FB driver. Move it to a more generic place for other
> usage.
[]
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
[]
> @@ -10,6 +10,14 @@
>  #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
>  #endif
>  
> +/*
> + * Create a contiguous bitmask starting at bit position @l and ending at
> + * position @h. For example
> + * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.

ull

> + */
> +#define GENMASK(h, l)		(((U32_C(1) << ((h) - (l) + 1)) - 1) << (l))
> +#define GENMASK_ULL(h, l)	(((U64_C(1) << ((h) - (l) + 1)) - 1) << (l))


Maybe add a

BUILD_BUG_ON(__builtin_constant_p(l) && __builtin_constant_p(h) && \
	     (h) < (l))

