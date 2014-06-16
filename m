Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbaFPO5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:57:38 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:57804 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaFPO5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:57:36 -0400
Date: Mon, 16 Jun 2014 10:56:19 -0400
From: Rich Felker <dalias@libc.org>
To: Ian Lance Taylor <iant@golang.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mikael Pettersson <mikpelinux@gmail.com>, Russ Cox <rsc@golang.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Message-ID: <20140616145618.GZ179@brightrain.aerifal.cx>
References: <cover.1402769596.git.luto@amacapital.net>
 <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx>
 <539DD26B.3060709@zytor.com>
 <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
 <539DDE9C.3010903@zytor.com>
 <CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com>
 <20140616023604.GI5714@two.firstfloor.org>
 <CAKOQZ8wwKcDAXq0BnHwvL01LQNFeOGwgA9x8kCLWeFaP6USF4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOQZ8wwKcDAXq0BnHwvL01LQNFeOGwgA9x8kCLWeFaP6USF4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 07:08:50AM -0700, Ian Lance Taylor wrote:
> On Sun, Jun 15, 2014 at 7:36 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > I haven't looked into this in detail, but my initial assumption would
> > be that it wouldn't be useful to add new vdso interfaces just for Go.
> > After all would you really want to force ever Go user to upgrade their
> > kernel just to get fast fime? So it has to work with whatever is already
> > there anyways.
> 
> Go works fine with the current interface.  There was, arguably, a bug
> in Go's old implementation in that it assumed that the vDSO would have
> a normal symbol table.  That bug has already been fixed.
> 
> I think this issue started when some of the Go developers questioned
> why the kernel needed to provide a very complex interface--parsing an
> ELF shared shared library--for very simple functionality--looking up
> the address of a magic function.  This approach has required special
> support not just in Go, but also in the dynamic linker and gdb, and
> does not work well for statically linked binaries.  The support in gdb
> is perhaps a good idea, but elsewhere it does not make sense.
> 
> So why not provide a simple interface?

This is my sentiment as well, but I think you've stated it better than
I have.

Also note that, if the vdso is providing a "lookup the address of a
magic function by name" function, it need not be a full ELF parser,
i.e. it doesn't need to be able to deal with any ELF files except the
vdso provided by the current kernel. This probably allows the parser
to be considerably smaller; for example, all the version stuff can be
omitted unless the actual kernel in use provides multiple symbol
versions.

Rich
