Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbbALIlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:41:01 -0500
Received: from smtprelay0238.hostedemail.com ([216.40.44.238]:44334 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752299AbbALIk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:40:57 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:2911:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4362:4425:5007:6119:6261:6742:6743:7576:7903:10004:10400:10848:10967:11232:11473:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fan23_7a7bdf492457
X-Filterd-Recvd-Size: 2566
Message-ID: <1421052051.9233.11.camel@perches.com>
Subject: Re: [PATCH 3/3] x_tables: Factor out 16bit aligment ifname_compare()
From: Joe Perches <joe@perches.com>
To: Richard Weinberger <richard@nod.at>
Cc: David Miller <davem@davemloft.net>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bhutchings@solarflare.com,
        john.fastabend@gmail.com, herbert@gondor.apana.org.au,
        vyasevic@redhat.com, jiri@resnulli.us, vfalico@gmail.com,
        therbert@google.com, edumazet@google.com, yoshfuji@linux-ipv6.org,
        jmorris@namei.org, kuznet@ms2.inr.ac.ru, kadlec@blackhole.kfki.hu,
        kaber@trash.net, pablo@netfilter.org, kay@vrfy.org,
        stephen@networkplumber.org
Date: Mon, 12 Jan 2015 00:40:51 -0800
In-Reply-To: <54B3834D.6090602@nod.at>
References: <54B2EB81.5050604@nod.at>	<1421012376.9233.9.camel@perches.com>
	 <54B2EE4D.2080802@nod.at>
	 <20150111.215050.458358747958425038.davem@davemloft.net>
	 <54B3834D.6090602@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-12 at 09:18 +0100, Richard Weinberger wrote:
> Am 12.01.2015 um 03:50 schrieb David Miller:
> > From: Richard Weinberger <richard@nod.at>
> > Date: Sun, 11 Jan 2015 22:42:37 +0100
> > 
> >> Joe, I really don't care. This is the least significant
> >> patch of the series.
> >> I'll no longer waste my time with that.
> > 
> > If you're not willing to fix stylistic issues now, then nobody should
> > bother wasting their time on the high level issues of your patch.
> > 
> > Just fix these things now rather than being difficult, this is a part
> > of patch review that everyone has to do, not just you.
> 
> I apologize, it was not my intention to be difficult.

No worries.

The unsigned long return is kind of odd with a
compare_<foo> name as those are generally, as Jan
mentioned, signed comparison style return values.

I'd probably use a different function name too

bool ifname_equal(const char *a, const char *b, const char *mask)
{
}

to try to make the return value more obvious too.

> If you and netfilter folks now prefer bool
> for such string compare functions I'll happily address this in
> v2 of my series.

Thanks


