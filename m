Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaFIVgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:36:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbaFIVgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:36:19 -0400
Message-ID: <539628D0.2090702@suse.cz>
Date: Mon, 09 Jun 2014 23:36:16 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Behan Webster <behanw@converseincode.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Makefile: Fix unrecognized cross-compiler command line
 options
References: <1401177252-11919-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1401177252-11919-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 27.5.2014 09:54, Geert Uytterhoeven napsal(a):
> On architectures that setup CROSS_COMPILE in their arch/*/Makefile
> (arc, blackfin, m68k, mips, parisc, score, sh, tile, unicore32, xtensa),
> cc-option and cc-disable-warning may check against the wrong compiler,
> causing errors like
> 
>     cc1: error: unrecognized command line option "-Wno-maybe-uninitialized"
> 
> if the host gcc supports a compiler option, while the cross compiler
> doesn't support that option.
> 
> Move all logic using cc-option or cc-disable-warning below the inclusion
> of the arch's Makefile to fix this.
> 
> Introduced by
>   - commit e74fc973b6e531fef1fce8b101ffff05ecfb774c ("Turn off
>     -Wmaybe-uninitialized when building with -Os"),
>   - commit 61163efae02040f66a95c8ed17f4407951ba58fa ("kbuild: LLVMLinux:
>     Add Kbuild support for building kernel with Clang").
> 
> As -Wno-maybe-uninitialized requires a quite recent gcc (gcc 4.6.3 on
> Ubuntu 12.04 LTS doesn't support it), this only showed up recently (gcc
> 4.8.2 on Ubuntu 14.04 LTS does support it).
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied to kbuild.git#kbuild, thanks.

Michal

