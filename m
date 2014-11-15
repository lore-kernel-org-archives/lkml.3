Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaKOGL0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 01:11:26 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:58476
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbaKOGLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 01:11:23 -0500
X-IronPort-AV: E=Sophos;i="5.07,390,1413237600"; 
   d="scan'208";a="88317913"
Date: Sat, 15 Nov 2014 07:11:20 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: cocci <cocci@systeme.lip6.fr>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Cocci] spatch for trivial pointer comparison style?
In-Reply-To: <1415982122.5912.14.camel@perches.com>
Message-ID: <alpine.DEB.2.02.1411150708500.2049@localhost6.localdomain6>
References: <1415908529.4223.11.camel@perches.com>  <alpine.DEB.2.02.1411140700010.2035@localhost6.localdomain6>  <1415945558.5912.10.camel@perches.com>  <alpine.DEB.2.10.1411140938400.2443@hadrien> <1415982122.5912.14.camel@perches.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014, Joe Perches wrote:

> On Fri, 2014-11-14 at 10:18 +0100, Julia Lawall wrote:
> > On Thu, 13 Nov 2014, Joe Perches wrote:
> []
> > > Yes, I agree with some of the things Al Viro said
> > > there, but isn't 'type t; t *p;' a subset of
> > > "expression *e"?
> 
> > No.  How would you expect it to be different.
> 
> []

No. [] and * are treated completely differently.

> >   type t means that the type
> > is known.  expression *e means that there is a * in the type.
> 
> I had thought "expression *" could be r-value and
> "type t; t *p;" could be l-value.

No, you made that one up :)  As we considered that it would be common to 
want to specify the type of an expression, we thought it would be tiresome 
to have to put eg expression int x.  So you can just say int x.

The downside is that people write

identifer x;

and then don't understand the error message, because any misspelled 
metavariable kind is considered to be a type name.

julia

> But then I don't find (or maybe don't parse too well)
> the coccinelle documentation that specifies these
> type relationships.
> 
> cheers, Joe
> 
> 
> 
