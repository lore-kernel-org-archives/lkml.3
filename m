Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab3KBPFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 11:05:30 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44993 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3KBPF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 11:05:29 -0400
X-Originating-IP: 50.43.14.201
Date: Sat, 2 Nov 2013 08:05:20 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr
Subject: Re: [PATCH] coccinelle: Add a script to find and remove unnecessary
 ifs with no body
Message-ID: <20131102150520.GV15704@leaf>
References: <20131102143236.GA18084@leaf>
 <alpine.DEB.2.02.1311021550330.2261@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311021550330.2261@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 02, 2013 at 03:51:50PM +0100, Julia Lawall wrote:
> On Sat, 2 Nov 2013, Josh Triplett wrote:
> 
> > This script matches code like:
> >
> > if (foo) {}
> >
> > and either eliminates it (if foo has no side effects) or replaces it
> > with foo (if foo has side effects).
> >
> > Works perfectly in report mode; the results of patch mode are
> > semantically correct but may still benefit from further simplification.
> 
> Actually, I would get rid of the patch mode.  Looking through some of the
> results, I don't see any where just deleting the code is the right thing
> to do.  They all look like cases where the developer wanted to remember to
> think more about the problem.

I observed several where the patch seemed entirely correct, with no
FIXME/TODO/XXX comments associated with the conditional.

Nonetheless, I don't mind removing the patch mode if you don't think
it's worthwhile.  I'll send a v2.

- Josh Triplett
