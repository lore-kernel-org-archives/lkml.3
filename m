Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbaJXJb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:31:57 -0400
Received: from smtprelay0169.hostedemail.com ([216.40.44.169]:45187 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751510AbaJXJbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:31:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3871:3872:3874:4321:5007:6261:6299:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: aunt65_107c05256bd14
X-Filterd-Recvd-Size: 1600
Message-ID: <1414143110.15751.13.camel@perches.com>
Subject: Re: [PATCH] checkpatch: fix use via symlink, make missing spelling
 file non-fatal
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jani Nikula <jani.nikula@intel.com>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 24 Oct 2014 02:31:50 -0700
In-Reply-To: <20141024090252.GC2910@bark>
References: <874muwv0ym.fsf@intel.com>
	 <1413980418.18654.8.camel@perches.com> <87ppdktewn.fsf@intel.com>
	 <1414085351.15751.10.camel@perches.com> <20141024090252.GC2910@bark>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-24 at 10:02 +0100, Andy Whitcroft wrote:
> On Thu, Oct 23, 2014 at 10:29:11AM -0700, Joe Perches wrote:
> 
> [...]
> >  my $P = $0;
> > -$P =~ s@(.*)/@@g;
> > -my $D = $1;
> > +my $D = dirname(abs_path($P));
> 
> That changes the value of $P, I don't know if that is intended:
> 
>   my $D = dirname(abs_path($0));
> 
> or
> 
>   my $D = abs_path($1);
> 
> perhaps to keep $P as it was.

I did it to show the executable passed on the cmdline better.

It changes --help and some warn/die messages.

It's not particularly important either way.

