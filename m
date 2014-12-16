Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaLPXuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:50:18 -0500
Received: from ozlabs.org ([103.22.144.67]:55110 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaLPXuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:50:14 -0500
Message-ID: <1418773782.6400.5.camel@ellerman.id.au>
Subject: Re: [PATCH 00/18] uaccess: fix sparse warning on get_user for
 bitwise types
From: Michael Ellerman <mpe@ellerman.id.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Date: Wed, 17 Dec 2014 10:49:42 +1100
In-Reply-To: <20141215102227.GA26178@redhat.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
	 <1418604052.19970.6.camel@ellerman.id.au>
	 <20141215102227.GA26178@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-15 at 12:22 +0200, Michael S. Tsirkin wrote:
> On Mon, Dec 15, 2014 at 11:40:52AM +1100, Michael Ellerman wrote:
> > On Sun, 2014-12-14 at 18:51 +0200, Michael S. Tsirkin wrote:
> > > At the moment, if p and x are both tagged as bitwise types,
> > > get_user(x, p) produces a sparse warning on many architectures.
> > > This is because *p on these architectures is loaded into long
> > > (typically using asm), then cast back to typeof(*p).
> > > 
> > > When typeof(*p) is a bitwise type (which is uncommon), such a cast needs
> > > __force, otherwise sparse produces a warning.
> > 
> > What does __force actually mean? Force the cast even though it's a bitfield? Or
> > does it mean more than that?
> 
> It's not a bitfield = it's a bitwise integer.

OK. I didn't know what that meant, but Documentation/sparse.txt taught me.

So it's a sparse only thing.

> Once you tag a typedef as bitwise, casts to and from
> an untypedefed integer cause sparse warnings.
> 
> > ie. are we loosing the ability to detect any actual errors by adding force?
> > 
> > cheers
> 
> I think we aren't:
> get_user(x, p) should be equivalent to x = *p except it
> validates the pointer is to userspace memory,
> and can handle pagefaults.
> 
> Sparse warnings are triggered because these macros use
> an untyped integer internally.
> 
> Note that we are casting to typeof(*p) not typeof(x).
> Even with the cast, if x and *p are of different types we should get the
> warning, so I think we are not loosing the ability to detect any actual
> errors.

OK. Sounds good then.

cheers


