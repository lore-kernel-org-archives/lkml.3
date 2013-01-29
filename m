Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3A2Q3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:29:52 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:38041
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069Ab3A2Q3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:29:49 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2013 11:29:49 EST
X-IronPort-AV: E=Sophos;i="4.84,561,1355094000"; 
   d="scan'208";a="391971"
Date: Tue, 29 Jan 2013 17:19:43 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Joe Perches <joe@perches.com>
cc: Valdis.Kletnieks@vt.edu, cocci@systeme.lip6.fr,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: coccinelle and bitmask arithmetic (was: Re: [patch] TTY: synclink,
 small cleanup in dtr_rts())
In-Reply-To: <1359475998.4196.26.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1301291717530.3339@hadrien>
References: <20130127194039.GA18787@elgon.mountain>  <1359317078.14406.12.camel@joe-AO722> <20130127201947.GO16282@mwanda>  <9561.1359474916@turing-police.cc.vt.edu> <1359475998.4196.26.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Jan 2013, Joe Perches wrote:

> On Tue, 2013-01-29 at 10:55 -0500, Valdis.Kletnieks@vt.edu wrote:
> > On Sun, 27 Jan 2013 23:19:47 +0300, Dan Carpenter said:
> >
> > > Yeah.  I think it would be, but adding bitflags together instead of
> > > doing bitwise ORs is very common as well.
> >
> > The fact it's common doesn't mean it's good programming practice,
> > or even correct.  Consider:
> >
> > #define F_FOO 0x01
> > #define F_BAR 0x02
> > #define F_BAZ 0x04
> >
> > unsigned int flags = F_FOO;
> > ...
> >       flags |= F_BAR;
> >
> > Now some time later, another code path does this:
> >
> >       flags += F_FOO;
> >
> > If it was another |, it would be a no harm no foul class of bug.
> > But how long is it going to take you to figure out who set F_BAZ?
> >
> > I wonder if there's a way to write a coccinelle patch to find places
> > where we do arithmetic operations on bitmasks....
>
> Not so far as I know, but maybe someone on the
> cocci lists does. (cc'd)
>
> I could imagine a test for variables that have
> uses of both arithmetic and bit operations but
> not a discriminator for when one type is
> appropriate and the other is not.

If the definition of a bitmask is an identifier in all capital letters,
that would be easy.  Another possibility is such an identifier that is
defined to a value expressed beginning with 0x.  Another possibility is
such an identifier that is sometimes used with & and | and sometimes used
with an arithmetic operation.  I will give them a try.

julia
