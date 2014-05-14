Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaENW1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:27:10 -0400
Received: from smtprelay0252.hostedemail.com ([216.40.44.252]:35132 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751473AbaENW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:27:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3866:3867:3868:3873:3874:4321:4605:5007:6691:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12555:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pan16_3e0bf69f7fd29
X-Filterd-Recvd-Size: 2546
Message-ID: <1400106425.12666.6.camel@joe-AO725>
Subject: Re: [PATCH V2] fs/reiserfs/stree.c: remove obsolete __constant
From: Joe Perches <joe@perches.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Date: Wed, 14 May 2014 15:27:05 -0700
In-Reply-To: <CAFLxGvzp_8Qgg0wN2v0SncAB+eDEn4s-p86ZW9+DzosBKb53yw@mail.gmail.com>
References: <20140503223324.4357f591dc8994b74f456440@skynet.be>
	 <20140514220143.GA20841@quack.suse.cz>
	 <CAFLxGvzp_8Qgg0wN2v0SncAB+eDEn4s-p86ZW9+DzosBKb53yw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-15 at 00:08 +0200, Richard Weinberger wrote:
> On Thu, May 15, 2014 at 12:01 AM, Jan Kara <jack@suse.cz> wrote:
> > On Sat 03-05-14 22:33:24, Fabian Frederick wrote:
> >> __constant_cpu_to_le32 converted to cpu_to_le32
> >>
> >> Cc: reiserfs-devel@vger.kernel.org
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> >   Just for my education, where have you learned that __constant_...
> > functions are obsolete?
> 
> IIRC checkpatch.pl barks if you use __constant_... outside of include/uapi/

I'd use not preferred and unnecessarily verbose more than obsolete.

These conversions are all tested with __builtin_constant_p
via indirection to macros like __swab32

include/uapi/linux/swab.h:#define __swab32(x)                           \
include/uapi/linux/swab.h-      (__builtin_constant_p((__u32)(x)) ?     \
include/uapi/linux/swab.h-      ___constant_swab32(x) :                 \
include/uapi/linux/swab.h-      __fswab32(x))

include/uapi/linux/swab.h:#define ___constant_swab32(x) ((__u32)(                               \
include/uapi/linux/swab.h-      (((__u32)(x) & (__u32)0x000000ffUL) << 24) |            \
include/uapi/linux/swab.h-      (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) |            \
include/uapi/linux/swab.h-      (((__u32)(x) & (__u32)0x00ff0000UL) >>  8) |            \
include/uapi/linux/swab.h-      (((__u32)(x) & (__u32)0xff000000UL) >> 24)))


