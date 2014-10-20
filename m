Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaJTTIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:08:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaJTTIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:08:34 -0400
Date: Mon, 20 Oct 2014 21:08:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [GIT PULL] doc for 3.18 merge window
In-Reply-To: <1413809129.17703.13.camel@x41>
Message-ID: <alpine.LNX.2.00.1410202106330.24255@pobox.suse.cz>
References: <alpine.LNX.2.00.1410070008540.31343@pobox.suse.cz> <1413809129.17703.13.camel@x41>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding Jonathan to CC ]

On Mon, 20 Oct 2014, Paul Bolle wrote:

> > Peter Foley (12):
> >       Documentation: use subdir-y to avoid unnecessary built-in.o files
> >       Documentation: add makefiles for more targets
> >       Documentation: make functions static to avoid prototype warnings
> >       Documentation: fix misc. warnings
> >       Documentation: support glibc versions without htole macros
> >       Documentation: update .gitignore files
> >       Documentation: update vDSO makefile to build portable examples
> >       Documentation: disable vdso_test to avoid breakage with old glibc
> >       Make Documenation depend on headers_install
> >       tools: add more endian.h macros
> >       Documentation: remove networking/.gitignore
> >       Documentation: update include path for mpssd
> 
> This series is included in v3.18-rc1. It broke the build of 32 bit x86
> (if CONFIG_BUILD_DOCSRC is set):
>     Documentation/vDSO/vdso_standalone_test_x86.o: In function `to_base10':
>     vdso_standalone_test_x86.c:(.text+0x101): undefined reference to `__umoddi3'
>     vdso_standalone_test_x86.c:(.text+0x12d): undefined reference to `__udivdi3'
>     collect2: error: ld returned 1 exit status
>     make[2]: *** [Documentation/vDSO/vdso_standalone_test_x86] Error 1
>     make[1]: *** [Documentation/vDSO] Error 2
>     make[1]: *** Waiting for unfinished jobs....
>     make: *** [vmlinux] Error 2
> 
> A possible fix is discussed in https://lkml.org/lkml/2014/10/8/538 .

Jonathan, will you take care of this (now that ad3118b9861 is in)?

BTW, I am not sure whether vdso_standalone_test_x86.c wouldn't fit better 
in samples/ anyway ...

-- 
Jiri Kosina
SUSE Labs
