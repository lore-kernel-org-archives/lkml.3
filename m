Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbaFPGkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 02:40:13 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:57791 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaFPGkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 02:40:12 -0400
Date: Mon, 16 Jun 2014 02:39:08 -0400
From: Rich Felker <dalias@libc.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Mikael Pettersson <mikpelinux@gmail.com>,
        Russ Cox <rsc@golang.org>, Linux API <linux-api@vger.kernel.org>,
        Ian Taylor <iant@golang.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Message-ID: <20140616063907.GX179@brightrain.aerifal.cx>
References: <cover.1402769596.git.luto@amacapital.net>
 <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx>
 <539DD26B.3060709@zytor.com>
 <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
 <f420daee-9a06-414b-911f-5db7b7b37abe@email.android.com>
 <CALCETrXxG3_wxRAPF9CNk+2yv7t2Hw5Z4R-UdNKSZtU+pSe9og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXxG3_wxRAPF9CNk+2yv7t2Hw5Z4R-UdNKSZtU+pSe9og@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 11:22:48AM -0700, Andy Lutomirski wrote:
> >>[1] The only comprehensible description of the GNU hash extension that
> >>I could find is on Oracle's blog (!)
> >>
> >
> > Curious about this blog.  We do have a GNU hash implementation in Syslinux, too, for another reference.
> >
> 
> https://blogs.oracle.com/ali/entry/gnu_hash_elf_sections
> 
> FWIW, I bet that __vdso_findsym could be smaller if it used the GNU
> hash.  Maybe it would save about the same amount of space that turning
> on the GNU hash would take up.

How so? My implementation of gnu hash lookup in musl's dynamic linker
is somewhat larger than the sysv hash lookup, and that's even with
skipping the bloom filter (which did not seem to yield any benefit,
though we may revisit this issue later). The actual hash function is
_slightly_ smaller for gnu, but the lookup function has a lot more
work to do.

Of course for the size of vdso's symbol table, a pure linear search
with no hash table would suffice...

Rich
