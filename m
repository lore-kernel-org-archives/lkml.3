Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaCHCSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 21:18:00 -0500
Received: from smtprelay0035.hostedemail.com ([216.40.44.35]:50881 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751609AbaCHCR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 21:17:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:3872:3874:4250:4321:5007:7652:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: girl52_b1d56ada2a43
X-Filterd-Recvd-Size: 1724
Message-ID: <1394245074.6972.7.camel@joe-AO722>
Subject: Re: [PATCH v2] module: LLVMLinux: Remove unused function warning
 from __param_check macro
From: Joe Perches <joe@perches.com>
To: behanw@converseincode.com
Cc: khali@linux-fr.org, rostedt@goodmis.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        pageexec@freemail.hu, Mark Charlebois <charlebm@gmail.com>
Date: Fri, 07 Mar 2014 18:17:54 -0800
In-Reply-To: <1394244623-25623-1-git-send-email-behanw@converseincode.com>
References: <531A73EB.6060403@codeaurora.org>
	 <1394244623-25623-1-git-send-email-behanw@converseincode.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 18:10 -0800, behanw@converseincode.com wrote:
> This code makes a compile time type check that is optimized away. Clang
> complains that it generates an unused function.
[]
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
[]
> @@ -346,7 +346,7 @@ static inline void destroy_params(const struct kernel_param *params,
>  /* The macros to do compile-time type checking stolen from Jakub
>     Jelinek, who IIRC came up with this idea for the 2.4 module init code. */
>  #define __param_check(name, p, type) \
> -	static inline type *__check_##name(void) { return(p); }
> +	static inline __always_unused type *__check_##name(void) { return(p); }

Perhaps __maybe_unused ?


