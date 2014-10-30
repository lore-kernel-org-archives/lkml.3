Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760440AbaJ3SPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:15:07 -0400
Received: from smtprelay0148.hostedemail.com ([216.40.44.148]:34429 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757832AbaJ3SPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:15:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2899:3138:3139:3140:3141:3142:3167:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6119:6261:7875:7903:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13095:13311:13357:13618:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rod69_838509d83052f
X-Filterd-Recvd-Size: 2208
Message-ID: <1414692902.22099.1.camel@perches.com>
Subject: Re: [PATCH 4/8] x86, microcode, intel: add error logging to early
 update driver
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
        H Peter Anvin <hpa@zytor.com>
Date: Thu, 30 Oct 2014 11:15:02 -0700
In-Reply-To: <20141030174134.GE11178@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
	 <1410197875-19252-5-git-send-email-hmh@hmh.eng.br>
	 <20141020150801.GE3524@pd.tnic>
	 <20141021141015.GD22528@khazad-dum.debian.net>
	 <20141030174134.GE11178@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-30 at 18:41 +0100, Borislav Petkov wrote:
> On Tue, Oct 21, 2014 at 12:10:15PM -0200, Henrique de Moraes Holschuh wrote:
> > In fact, I have a patch somewhere that needs to add a new failure message:
> > we have several failure cases which we want to differentiate, at the very
> > least "processor didn't like it" and "it looks corrupt, so we didn't even
> > try to install it".
> 
> Actually, I don't want to be too chatty with the loader: if the
> microcode blob passes checks but it is not for the current processor
> we're running, not saying anything is what I want to do.
> 
> Why? Because I don't want to disturb people unnecessarily - if the
> microcode doesn't apply and everything else checks out, you simply don't
> need it.
> 
> If one really wants to know, one can always check /proc/cpuinfo and read
> out the microcode revision from the blob. But that is for the 1% of the
> curious ones - everyone else should simply install microcode blob and
> boot machine. Fire and forget.
> 
> Only the abnormal error cases should be vocal in saying what's wrong so
> that we can actually address those.

Maybe make it emit at KERN_DEBUG

