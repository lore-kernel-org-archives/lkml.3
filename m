Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782AbaABBdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 20:33:15 -0500
Received: from smtprelay0189.hostedemail.com ([216.40.44.189]:52206 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750704AbaABBdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 20:33:14 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2540:2559:2562:2740:2828:2906:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12533:12740:13019:13069:13141:13161:13229:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coast90_38e941d2f493e
X-Filterd-Recvd-Size: 2507
Message-ID: <1388626389.2259.57.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Joe Perches <joe@perches.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net, keescook@chromium.org,
        linux-kernel@vger.kernel.org
Date: Wed, 01 Jan 2014 17:33:09 -0800
In-Reply-To: <201401011902.JEF43770.FSOVFFOHOtQLJM@I-love.SAKURA.ne.jp>
References: <1388422545.26796.36.camel@joe-AO722>
	 <201312311553.IGG09071.HLJtFVSQFFOOOM@I-love.SAKURA.ne.jp>
	 <1388507067.2259.24.camel@joe-AO722>
	 <201401011434.GAF34360.FFQOVtFOHJSMLO@I-love.SAKURA.ne.jp>
	 <1388555362.2259.38.camel@joe-AO722>
	 <201401011902.JEF43770.FSOVFFOHOtQLJM@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-01 at 19:02 +0900, Tetsuo Handa wrote:
> Joe Perches wrote:
> > > This choice (i.e. reserve only '\xFF') is more resource economy than my
> > > previous choice (i.e. reserve '\x7F' to '\xFF') at the cost of wasting only
> > > one byte compared to my previous choice.
> > 
> > I supposed that's better.
> > 
> > Is there a particularly utility/reason to use 0xff
> > vs ascii SUB/PU1/PU2?
> > 
> Nothing. Is 0x1A preferable to 0xFF?

ASCII SUB seems to me to fit better for the purpose.
The "Private Use" PU1/PU2 also seemed appropriate,
but I suppose any non-printable character might be OK.

(from wikipedia)

The substitute character (SUB) was intended to request a translation of
the next character from a printable character to another value, usually
by setting bit 5 to zero. This is handy because some media (such as
sheets of paper produced by typewriters) can transmit only printable
characters. However, on MS-DOS systems with files opened in text mode,
"end of text" or "end of file" is marked by this Ctrl-Z character,
instead of the Ctrl-C or Ctrl-D, which are common on other operating
systems.

PU1/PU2:

Reserved for a function without standardized meaning for private use as
required, subject to the prior agreement of the sender and the recipient
of the data.



