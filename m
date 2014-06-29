Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaF2QeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 12:34:20 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:38253 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbaF2QeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 12:34:18 -0400
X-IronPort-AV: E=Sophos;i="5.01,571,1400018400"; 
   d="scan'208";a="82791420"
Date: Sun, 29 Jun 2014 18:34:14 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: Himangi Saraogi <himangi774@gmail.com>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: Drop cast
In-Reply-To: <1403848366.7977.92.camel@joe-AO725>
Message-ID: <alpine.DEB.2.02.1406291832430.2036@localhost6.localdomain6>
References: <20140626172852.GA2878@himangi-Dell>  <1403804286.7977.58.camel@joe-AO725>  <alpine.DEB.2.02.1406270729110.2016@localhost6.localdomain6> <1403848366.7977.92.camel@joe-AO725>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jun 2014, Joe Perches wrote:

> On Fri, 2014-06-27 at 07:29 +0200, Julia Lawall wrote:
> > On Thu, 26 Jun 2014, Joe Perches wrote:
> > > The cast of a const void * to a void * was odd.
> > > 
> > > Maybe a mechanism to verify appropriateness of
> > > loss of constness for any pointer might be useful.
> > 
> > I tried the following, but didn't find anything interesting:
> > 
> > @disable drop_cast@
> > type T;
> > const T e;
> > @@
> > 
> > * (T)e
> 
> What code does this match?
> Do you have an example match?
> 
> This doesn't find a cast of a void type like:
> 
> void func(const void * const p)
> {
> 	char *p2 = p;
> 
> 	p2[0] = 1;
> }

Is this a real example?  Because gcc complains about this sort of problem.  
I made a semantic patch that detects this, but since gcc does the same 
thing, it doesn't seem very interesting.  Coccinelle gives a few false 
positives due to lack of type information.

julia
