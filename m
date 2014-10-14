Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaJNQwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:52:43 -0400
Received: from smtprelay0214.hostedemail.com ([216.40.44.214]:45198 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754353AbaJNQwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:52:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3868:3872:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12555:12740:13069:13101:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rate49_514dfe2875555
X-Filterd-Recvd-Size: 1828
Message-ID: <1413305557.3269.21.camel@joe-AO725>
Subject: Re: [PATCH 1/1 linux-next] fs/jffs2/nodelist.h: remove unnecessary
 __constant_ prefix
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Date: Tue, 14 Oct 2014 09:52:37 -0700
In-Reply-To: <1413305085-7318-1-git-send-email-fabf@skynet.be>
References: <1413305085-7318-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-14 at 18:44 +0200, Fabian Frederick wrote:
> See commit fbdb8138cf0c
> ("checkpatch: warn on uses of __constant_<foo> functions")

Perhaps it'd be better to use the same
__builtin_constant_p test as swab.h and use
just one pattern instead

> diff --git a/fs/jffs2/nodelist.h b/fs/jffs2/nodelist.h
> index fa35ff7..9f0d547 100644
> --- a/fs/jffs2/nodelist.h
> +++ b/fs/jffs2/nodelist.h
> @@ -48,8 +48,8 @@
>  #define cpu_to_je32(x) ((jint32_t){cpu_to_be32(x)})
>  #define cpu_to_jemode(x) ((jmode_t){cpu_to_be32(os_to_jffs2_mode(x))})
>  
> -#define constant_cpu_to_je16(x) ((jint16_t){__constant_cpu_to_be16(x)})
> -#define constant_cpu_to_je32(x) ((jint32_t){__constant_cpu_to_be32(x)})
> +#define constant_cpu_to_je16(x) ((jint16_t){cpu_to_be16(x)})
> +#define constant_cpu_to_je32(x) ((jint32_t){cpu_to_be32(x)})

So none of these constant_<foo> things would be here
at all.


