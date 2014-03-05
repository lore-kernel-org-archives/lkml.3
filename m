Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbaCEDJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:09:24 -0500
Received: from smtprelay0169.hostedemail.com ([216.40.44.169]:42417 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754396AbaCEDJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:09:23 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2901:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3874:4321:5007:7652:7903:10004:10400:10848:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ants62_8be00fae56321
X-Filterd-Recvd-Size: 1878
Message-ID: <1393988959.3271.37.camel@joe-AO722>
Subject: Re: [PATCH] gpio: clamp returned values to the boolean range
From: Joe Perches <joe@perches.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 04 Mar 2014 19:09:19 -0800
In-Reply-To: <CACRpkdbaLy+uY_fsht=Fk0qPdtAnttpOK3xrpirPbwB0mA+TPQ@mail.gmail.com>
References: <1393378800-7220-1-git-send-email-acourbot@nvidia.com>
	 <CACRpkdY-oBdxxWhsGraEU31qyu+RWJAiRA+KEip6QNW3jRwGUA@mail.gmail.com>
	 <1393985087.3271.21.camel@joe-AO722>
	 <CAAVeFuJdg-p4K1wdLpdv3byiEBUezGGUVjyScoOaZcLZxhPk7A@mail.gmail.com>
	 <1393985959.3271.25.camel@joe-AO722>
	 <CAAVeFuKwLJ5-Q1_u4e_o6tp1F-AKaVQG0ph1GdqjBqFiMCQvPQ@mail.gmail.com>
	 <CACRpkdbaLy+uY_fsht=Fk0qPdtAnttpOK3xrpirPbwB0mA+TPQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 10:33 +0800, Linus Walleij wrote:
> the local "value" variable in the function should still be
> converted to a bool as well right? And the assignment should still
> be "false" not 0. So I would still add my hunk of code...

No idea.  I don't know the code, just wanted to point
out that a bool is not an int.

Generically, I think converting an int to a bool in
any "raw" function probably isn't the right thing to do.

Especially if any of these GPIOs are ever used as ports
(aggregates) in any access.

