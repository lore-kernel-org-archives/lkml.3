Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaBXSQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:16:29 -0500
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:53795 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752579AbaBXSQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:16:28 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:965:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2110:2196:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3873:4321:4385:4390:4395:4605:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tooth24_726e53e312c0e
X-Filterd-Recvd-Size: 2064
Message-ID: <1393265785.11020.40.camel@joe-AO722>
Subject: Re: [PATCH] pinctrl: Avoid kasprintf/kfree
From: Joe Perches <joe@perches.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Mark Brown <broonie@linaro.org>
Date: Mon, 24 Feb 2014 10:16:25 -0800
In-Reply-To: <CACRpkdYxDu-vZLpc3Ef-2q1B3wpHqnuJofRwhA332Qw4pw39vg@mail.gmail.com>
References: <1391108240-16161-1-git-send-email-broonie@kernel.org>
	 <1391108694.2422.59.camel@joe-AO722> <1391114256.2422.71.camel@joe-AO722>
	 <CACRpkdYxDu-vZLpc3Ef-2q1B3wpHqnuJofRwhA332Qw4pw39vg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 10:49 +0100, Linus Walleij wrote:
> On Thu, Jan 30, 2014 at 9:37 PM, Joe Perches <joe@perches.com> wrote:
> > Avoid an unnecessary allocation/free by using stack instead.
> >
> > Signed-off-by; Joe Perches <joe@perches.com>
> 
> Hm.
> 
> > +       char propname[9 + sizeof(int) * 2 + 4] = "pinctrl-";
> 
> If you absolutely want to do this you have to
> 
> #define PINCTRL_PREFIX "pinctrl-"
> 
> char propname[strlen(PINCTRL_PREFIX) + sizeof(int)*2 + 4] = PINCTRL_PREFIX;
> 
> Then add a comment above stating why you add 4.

No, I don't really.

> > This allocation seems unnecessary and the kasprintf isn't
> > checked for non-null, so maybe this is better.
> 
> Another option would be to just add a NULL-check? This is
> definately not on a performance-critical path.

It's a defect not to check the kasprintf return before
writing through it.

I submitted what I think appropriate.

Fix it as you choose.  Or not.

cheers, Joe

