Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaBFJG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 04:06:58 -0500
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:35281 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755245AbaBFJGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 04:06:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:152:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3874:4321:4605:5007:6119:7652:7903:9036:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: order75_589b8624f4141
X-Filterd-Recvd-Size: 2341
Message-ID: <1391677607.15777.2.camel@joe-AO722>
Subject: Re: [PATCH -next 2/2] bcache: Use max_t() when comparing different
 types
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>,
        linux-bcache@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Date: Thu, 06 Feb 2014 01:06:47 -0800
In-Reply-To: <CAMuHMdVDdGBG0b2BY4PZRGWn-2ts-qz9_OdUdnAE9gMp_zP3jw@mail.gmail.com>
References: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
	 <1389776784-30825-2-git-send-email-geert@linux-m68k.org>
	 <1389783998.14001.22.camel@joe-AO722>
	 <CAMuHMdUv_xP-1A950i0U=Petaey-_VosSxh5sk44Gqti-ikY6w@mail.gmail.com>
	 <CAMuHMdVDdGBG0b2BY4PZRGWn-2ts-qz9_OdUdnAE9gMp_zP3jw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 10:00 +0100, Geert Uytterhoeven wrote:
> On Mon, Feb 3, 2014 at 2:47 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, Jan 15, 2014 at 12:06 PM, Joe Perches <joe@perches.com> wrote:
> >> On Wed, 2014-01-15 at 10:06 +0100, Geert Uytterhoeven wrote:
> >>> drivers/md/bcache/btree.c: In function ‘insert_u64s_remaining’:
> >>> drivers/md/bcache/btree.c:1816: warning: comparison of distinct pointer types lacks a cast
> >> []
> >>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> >> []
> >>> @@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(struct btree *b)
> >>>       if (b->keys.ops->is_extents)
> >>>               ret -= KEY_MAX_U64S;
> >>>
> >>> -     return max(ret, 0L);
> >>> +     return max_t(ssize_t, ret, 0L);
> >>
> >> why not
> >>         return max(ret, 0);
> >
> > Indeed, that also works, on both 32-bit and 64-bit.
> > Will resend, now all the issues moved from -next to Linus' tree.
> 
> However, sparse doesn't like it, so we'll have to go for v1?

Seems so.

