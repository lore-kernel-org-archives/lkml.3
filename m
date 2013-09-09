Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab3IIPtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:49:25 -0400
Received: from smtprelay0021.hostedemail.com ([216.40.44.21]:44539 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750873Ab3IIPtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:49:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2525:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6691:7652:7875:7901:7903:8599:9025:9388:10004:10400:10848:11232:11658:11914:12043:12438:12517:12519:12533:12555:12700:12737:12740:12933:13069:13071:13095:13161:13181:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wool61_6ec4002bbf444
X-Filterd-Recvd-Size: 2406
Message-ID: <1378741760.15812.2.camel@joe-AO722>
Subject: Re: [checkpatch.pl] runtime error by version dependency.
From: Joe Perches <joe@perches.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc: bruce.w.allan@intel.com, linux-kernel@vger.kernel.org
Date: Mon, 09 Sep 2013 08:49:20 -0700
In-Reply-To: <201309092116.GAG52609.LQJOHFFtOSOMFV@I-love.SAKURA.ne.jp>
References: <201309092116.GAG52609.LQJOHFFtOSOMFV@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-09 at 21:16 +0900, Tetsuo Handa wrote:
> Hello.
> 
> Commit d1fe9c09 "checkpatch: add some --strict coding style checks"
> introduced dependency on perl >= 5.10.0 .
> 
> While the comment says that "Any use must be runtime checked with $^V",
> it is not runtime checked when running with perl == v5.8.4 , failing with
> 
>   Nested quantifiers in regex; marked by <-- HERE in m/(\((?:[^\(\)]++ <-- HERE |(?-1))*\))/ at ./scripts/checkpatch.pl line 340.
> 
> error.

Hello.

See Dave Hansen's commit fab4a18a0d2bb0b90e51a945886397f1de9cb6d4
("enforce sane perl version")

[PATCH] checkpatch: enforce sane perl version

I got a bug report from a couple of users who said checkpatch.pl was
broken for them.  It was erroring out on fairly random lines most commonly
with messages like:

        Nested quantifiers in regex; marked by <--HERE in m/(\((?:[^\(\)]++ <-- HERE |(?-1))*\))/ at ./checkpatch.pl line 340.

The bug reporter was running a version of perl 5.8 which was end-of-lifed
in 2008: http://www.cpan.org/src/.  Versions of perl this old are at
_best_ quite untested.  At worst, they are crusty and known to be
completely broken.

If folks have a system _that_ old, then we should have mercy on them and
give them a half-decent error message rather than fail with nutty error
messages.

This patch enforces that checkpatch.pl is run with perl 5.10, which was
end-of-lifed in 2009.  The new --ignore-perl-version command-line switch
will let folks override this if they want.


