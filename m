Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaIJHA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:00:56 -0400
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:44258 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750970AbaIJHAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:00:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:146:355:379:541:599:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2911:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4362:4425:4470:5007:6248:7652:7808:7875:7903:8828:9025:10004:10400:10848:11026:11232:11473:11658:11914:12043:12050:12438:12485:12517:12519:12663:12740:13071:13161:13229:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: salt53_415667c2f5562
X-Filterd-Recvd-Size: 3273
Message-ID: <1410332446.24028.26.camel@joe-AO725>
Subject: Re: [PATCH v2] checkpatch: look for common misspellings
From: Joe Perches <joe@perches.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-doc <linux-doc@vger.kernel.org>
Date: Wed, 10 Sep 2014 00:00:46 -0700
In-Reply-To: <CALLJCT3syNafyj-y+1osLCMabszJbyZhmmKWLO8k8-y4Nkmpzg@mail.gmail.com>
References: <20140908181524.GA11839@www.outflux.net>
	 <1410202114.12560.16.camel@joe-AO725>
	 <CALLJCT3syNafyj-y+1osLCMabszJbyZhmmKWLO8k8-y4Nkmpzg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 13:37 +0900, Masanari Iida wrote:
> Hello Joe, Kees,

Hello Masanari-san.

> Sorry for late reply.
> I was on holiday when the version 1 patch discussions were posted.

No worries, holidays are far more important
than patches like this...

These patches are simple niceties, not fixes
for bugs, so review and acceptance timing is
not urgent.

> I am using codespell ( https://github.com/lucasdemarchi/codespell/ ).
> The codespell has its own typo dictionary.
> The dictionary format is
> 
> typo->good   (1 candidate)
> typo->good1,good2,  (multiple candidates)
> typo->good, comment  (1 candidate with special remark)
> 
> Its similar to your  typo||good  format.
> 
> The license of the codespell is GPLv2 according to COPYING file in tar ball.
> 
> Compare number of typo samples in dictionary.
> Your dictionary :  1033
> codespell-1.4 :     4261
> codespell-1.4 + my adding 5245
> Your dictionary + codespell-1.4 + my adding - remove duplicate:  5742
> 
> Latest version of codespell is 1.7.
> My dictionary is based on codespell-1.4. So I use the number as of 1.4.
> 
> I can provide my typo samples under GPLv2 license.

Thanks.

Any additions you have to the dictionary would be
gladly welcomed.

Using a common format for the dictionary and any
suggested corrections would be good too.

Maybe the dictionary and code should be changed to
use the codespell format.  It seems a bit more
flexible than the lintian form.

I do not know if one project is more active than
the other, but perhaps that should be the deciding
factor.  Or maybe just Kees' preference...

Merging all these together might not be a good
solution though.

Right now, the checkpatch spelling code uses word
boundaries that include an underscore.

checkpatch spelling tests are done on 4 segments of
a #define like "PREFIX_PREFERED_SEG_ABC" finding the
misspelling of PREFERED.

Some sifting of the dictionary is still necessary to
eliminate some common prefixes to avoid too many false
positives.

For example, "ths" was dropped because it's a prefix
used by several modules even though it's a somewhat
frequent typo.


