Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab3KTXwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 18:52:15 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:40626 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab3KTXwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 18:52:09 -0500
X-Originating-IP: 173.246.103.110
Date: Wed, 20 Nov 2013 15:51:59 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Joe Perches <joe@perches.com>, Erico Nunes <nunes.erico@gmail.com>,
        linux-sparse@vger.kernel.org, dwmw2 <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] jffs2: fix sparse errors: directive in argument list
Message-ID: <20131120235159.GA25026@jtriplet-mobl1>
References: <1384719513-27386-1-git-send-email-nunes.erico@gmail.com>
 <1384724403.2727.22.camel@joe-AO722>
 <CAK4VdL2nKEE+xb=HtMGNsMGNR_ivUn_WnLi7X-rrXT0fpGbSTw@mail.gmail.com>
 <1384728305.14335.4.camel@joe-AO722>
 <20131118013349.GM13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118013349.GM13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 01:33:49AM +0000, Al Viro wrote:
> On Sun, Nov 17, 2013 at 02:45:05PM -0800, Joe Perches wrote:
> > On Sun, 2013-11-17 at 20:34 -0200, Erico Nunes wrote:
> > > Do you mean it as an error in the sparse tool?
> > 
> > Yes.  I think it's a defect in how sparse
> > treats string concatenation.
> > 
> > That style:
> > 
> > 	printk("%s\n",
> > #ifdef FOO
> > 	"foo"
> > #endif
> > #ifdef BAR
> > 	"bar"
> > #endif
> > 	"string");
> > 
> > is pretty common in the kernel sources.
> 
> ... and it's perfectly fine, until somebody starts playing in nasal
> daemon country and do that in *macro* arguments.  And a nasal daemon
> country it is - it's an undefined behaviour.  See 6.10.3p11 in C99.
> And trying to define a semantics for that gets real ugly real fast.
> sparse matches gcc behaviour (I hope), but it warns about such abuses.
> It's a defect, all right - one being reported by sparse.
> 
> Folks, please, RTFStandard if you decide to play clever games with
> preprocessing.  Chapter 6.10 is not particulary long or complicated.
> C99 has improved the preprocessor semantics a whole lot compared to
> the earlier horrible mess (mostly by defining it in terms of token
> stream transformations rather then text ones), but it's still very
> easy to abuse...

And since pr_foo (and the underlying pr_fmt) are already macros, that's
exactly the problem.

- Josh Triplett
