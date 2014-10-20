Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaJTMpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:45:35 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:52459 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbaJTMpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:45:33 -0400
Message-ID: <1413809129.17703.13.camel@x41>
Subject: Re: [GIT PULL] doc for 3.18 merge window
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 20 Oct 2014 14:45:29 +0200
In-Reply-To: <alpine.LNX.2.00.1410070008540.31343@pobox.suse.cz>
References: <alpine.LNX.2.00.1410070008540.31343@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2014 12:45:30.0138 (UTC) FILETIME=[BB109FA0:01CFEC63]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina schreef op di 07-10-2014 om 00:22 [+0200]:
> [...]
>
> Peter Foley (12):
>       Documentation: use subdir-y to avoid unnecessary built-in.o files
>       Documentation: add makefiles for more targets
>       Documentation: make functions static to avoid prototype warnings
>       Documentation: fix misc. warnings
>       Documentation: support glibc versions without htole macros
>       Documentation: update .gitignore files
>       Documentation: update vDSO makefile to build portable examples
>       Documentation: disable vdso_test to avoid breakage with old glibc
>       Make Documenation depend on headers_install
>       tools: add more endian.h macros
>       Documentation: remove networking/.gitignore
>       Documentation: update include path for mpssd

This series is included in v3.18-rc1. It broke the build of 32 bit x86
(if CONFIG_BUILD_DOCSRC is set):
    Documentation/vDSO/vdso_standalone_test_x86.o: In function `to_base10':
    vdso_standalone_test_x86.c:(.text+0x101): undefined reference to `__umoddi3'
    vdso_standalone_test_x86.c:(.text+0x12d): undefined reference to `__udivdi3'
    collect2: error: ld returned 1 exit status
    make[2]: *** [Documentation/vDSO/vdso_standalone_test_x86] Error 1
    make[1]: *** [Documentation/vDSO] Error 2
    make[1]: *** Waiting for unfinished jobs....
    make: *** [vmlinux] Error 2

A possible fix is discussed in https://lkml.org/lkml/2014/10/8/538 .


Paul Bolle

