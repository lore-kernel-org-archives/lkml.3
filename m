Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaFPPno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:43:44 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:57818 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaFPPnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:43:43 -0400
Date: Mon, 16 Jun 2014 11:42:28 -0400
From: Rich Felker <dalias@libc.org>
To: Ian Lance Taylor <iant@golang.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mikael Pettersson <mikpelinux@gmail.com>, Russ Cox <rsc@golang.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Message-ID: <20140616154228.GB179@brightrain.aerifal.cx>
References: <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx>
 <539DD26B.3060709@zytor.com>
 <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
 <539DDE9C.3010903@zytor.com>
 <CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com>
 <20140616023604.GI5714@two.firstfloor.org>
 <CAKOQZ8wwKcDAXq0BnHwvL01LQNFeOGwgA9x8kCLWeFaP6USF4A@mail.gmail.com>
 <20140616143801.GJ5714@two.firstfloor.org>
 <CAKOQZ8zk8KfkObSZg8fmhZXm9nXQSneOywvV-NBj=N-tNWjNPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOQZ8zk8KfkObSZg8fmhZXm9nXQSneOywvV-NBj=N-tNWjNPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 08:31:39AM -0700, Ian Lance Taylor wrote:
> On Mon, Jun 16, 2014 at 7:38 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >> I think this issue started when some of the Go developers questioned
> >> why the kernel needed to provide a very complex interface--parsing an
> >> ELF shared shared library--for very simple functionality--looking up
> >> the address of a magic function.  This approach has required special
> >> support not just in Go, but also in the dynamic linker and gdb, and
> >> does not work well for statically linked binaries.  The support in gdb
> >> is perhaps a good idea, but elsewhere it does not make sense.
> >>
> >> So why not provide a simple interface?
> >
> > What good would it do now that everyone already supports it?
> 
> Do statically linked binaries use the vDSO calls?

Under glibc, I believe so (not checked). Under musl, yes, and even in
the dynamic-linked case we use the same code that's used for static
linking rather than trying to get the dynamic linker to do them
correctly. I still have some cruft lying around from where (in the
past) we tried to do it via the dynamic linker, but I'm probably going
to remove that and make the vdso behave as RTLD_LOCAL so that there's
no risk of weird symbols it exports interfering with the application
(applications could still make it global via an explicit dlopen). The
only reason for keeping it around at all in the dynamic linker is for
the sake of gdb.

Rich
