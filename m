Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab3IPRxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 13:53:51 -0400
Received: from smtprelay0073.hostedemail.com ([216.40.44.73]:35023 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751148Ab3IPRxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:53:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2892:2901:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: badge40_3f2660fe9243
X-Filterd-Recvd-Size: 1614
Message-ID: <1379354025.1934.19.camel@joe-AO722>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Joe Perches <joe@perches.com>
To: George Spelvin <linux@horizon.com>
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, JBeulich@suse.com,
        keescook@chromium.org, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        viro@zeniv.linux.org.uk
Date: Mon, 16 Sep 2013 10:53:45 -0700
In-Reply-To: <20130916163919.17829.qmail@science.horizon.com>
References: <20130916163919.17829.qmail@science.horizon.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 12:39 -0400, George Spelvin wrote:
> > %*p<new_type><pad_char> (space assumed if not existing)
> 
> Yes, that's the fallback, but it requires an ugly dummy pointer argument.
> And some extra kludgery in the code because pointer() doesn't have access
> to the start-of-buffer address.
>
> I'd prefer something that could be detected with the information available
> in the switch(spec.type) in vsnprintf() itself.

Bad argument I think.

It'd be consistent with all the other %p<foo> types.

vsnprintf is already weird enough with %p uses,
there's absolutely no reason to stretch it further
with yet another odd access/format style.


