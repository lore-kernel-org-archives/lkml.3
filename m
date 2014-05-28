Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaE1Aod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:44:33 -0400
Received: from smtprelay0040.hostedemail.com ([216.40.44.40]:54454 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751397AbaE1Aoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:44:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:560:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:4321:5007:7652:7904:8603:10004:10400:10471:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13019:13069:13101:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: loss71_7ec8565ae4617
X-Filterd-Recvd-Size: 2890
Message-ID: <1401237869.20587.12.camel@joe-AO725>
Subject: Re: [PATCH 11/16] byteorder: provide a linux/byteorder.h with
 {be,le}_to_cpu() and cpu_to_{be,le}() macros
From: Joe Perches <joe@perches.com>
To: Cody P Schafer <dev@codyps.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Tue, 27 May 2014 17:44:29 -0700
In-Reply-To: <1401236684-10579-12-git-send-email-dev@codyps.com>
References: <1401236684-10579-1-git-send-email-dev@codyps.com>
	 <1401236684-10579-12-git-send-email-dev@codyps.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-27 at 17:22 -0700, Cody P Schafer wrote:
> Rather manually specifying the size of the integer to be converted, key
> off of the type size. Reduces duplicate size info and the occurance of
> certain types of bugs (using the wrong sized conversion).
[]
> diff --git a/include/linux/byteorder.h b/include/linux/byteorder.h
[]
> @@ -0,0 +1,34 @@
> +#ifndef LINUX_BYTEORDER_H_
> +#define LINUX_BYTEORDER_H_
> +
> +#include <asm/byteorder.h>
> +
> +#define be_to_cpu(v) \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint8_t) , v,	\
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint16_t), be16_to_cpu(v), \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint32_t), be32_to_cpu(v), \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint64_t), be64_to_cpu(v), \
> +		(void)0))))

probably better to use BUILD_BUG instead of these 0 returns

> +
> +#define le_to_cpu(v) \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint8_t) , v,	\
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint16_t), le16_to_cpu(v), \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint32_t), le32_to_cpu(v), \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint64_t), le64_to_cpu(v), \
> +		(void)0))))
> +
> +#define cpu_to_le(v) \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint8_t) , v,	\
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint16_t), cpu_to_le16(v), \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint32_t), cpu_to_le32(v), \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint64_t), cpu_to_le64(v), \
> +		(void)0))))
> +
> +#define cpu_to_be(v) \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint8_t) , v,	\
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint16_t), cpu_to_be16(v), \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint32_t), cpu_to_be32(v), \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint64_t), cpu_to_be64(v), \
> +		(void)0))))
> +
> +#endif



