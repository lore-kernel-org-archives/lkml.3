Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbaISTPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:15:22 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:51871 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbaISTPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:15:20 -0400
Date: Fri, 19 Sep 2014 12:15:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Helge Deller <deller@gmx.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: linux-next: Tree for Sep 19
Message-ID: <20140919191514.GA5358@roeck-us.net>
References: <20140919165817.225eb8b8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919165817.225eb8b8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 04:58:17PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20140917:
> 
> The fsl tree still had its build failure so I used the version from
> next-20140917.
> 
> The v4l-dvb tree lost its build failure.
> 
> The security tree gained a conflict against the file-locks tree.
> 
> Non-merge commits (relative to Linus' tree): 6014
>  5488 files changed, 217522 insertions(+), 129375 deletions(-)
> 
> ----------------------------------------------------------------------------
> 

parisc:defconfig, parisc:generic-32bit_defconfig:

--------------
Error log:
arch/parisc/kernel/ptrace.c: In function 'do_syscall_trace_enter':
arch/parisc/kernel/ptrace.c:274:2: error: implicit declaration of function
'secure_computing' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[1]: *** [arch/parisc/kernel/ptrace.o] Error 1

Bisect points to commit 273299fb6380 ('Merge branch 'x86/seccomp') which
obviously doesn't help much. Suspected culprit is c90f06943e05 ('parisc: Wire up
seccomp, getrandom and memfd_create syscalls') which seems to be missing an
include file.

Bisect log:

# bad: [6a10bca9b608df445baa23c3bfafc510d93d425b] Add linux-next specific files for 20140919
# good: [9e82bf014195d6f0054982c463575cdce24292be] Linux 3.17-rc5
git bisect start 'HEAD' 'v3.17-rc5'
# good: [fde058e2322b9098251d7cf798cac4327a29c004] Merge remote-tracking branch 'drm/drm-next'
git bisect good fde058e2322b9098251d7cf798cac4327a29c004
# bad: [8a258c1a0f82f4d152a3b06966a4d28dac2c8bcb] Merge remote-tracking branch 'usb-serial/usb-next'
git bisect bad 8a258c1a0f82f4d152a3b06966a4d28dac2c8bcb
# good: [5a571cebb73888024182de09063db35341e61beb] Merge remote-tracking branch 'spi/for-next'
git bisect good 5a571cebb73888024182de09063db35341e61beb
# bad: [249a58bd0f355bc12549d00296684103326ac38f] Merge remote-tracking branch 'rcu/rcu/next'
git bisect bad 249a58bd0f355bc12549d00296684103326ac38f
# good: [50a919fbd52123bd30c8f788a28343bfb159f855] Merge branch 'perf/core'
git bisect good 50a919fbd52123bd30c8f788a28343bfb159f855
# bad: [1187356a4b781969c160a9c21c164f738747fc66] Merge remote-tracking branch 'tip/auto-latest'
git bisect bad 1187356a4b781969c160a9c21c164f738747fc66
# good: [20ef49c29af54140f51657961a37d6a59c80b479] Merge branch 'x86/cleanups'
git bisect good 20ef49c29af54140f51657961a37d6a59c80b479
# good: [63feeed278579155f0dff01b13167034cde470b2] Merge branch 'x86/mm'
git bisect good 63feeed278579155f0dff01b13167034cde470b2
# bad: [273299fb6380d08414b2710d007252f23b7dcc8f] Merge branch 'x86/seccomp'
git bisect bad 273299fb6380d08414b2710d007252f23b7dcc8f
# good: [e0ffbaabc46db508b8717f023c0ce03b980eefac] x86: Split syscall_trace_enter into two phases
git bisect good e0ffbaabc46db508b8717f023c0ce03b980eefac
# good: [2e151c70dfb0075ff83bec305c52a9da1ba49089] x86: HPET force enable for e6xx based systems
git bisect good 2e151c70dfb0075ff83bec305c52a9da1ba49089
# good: [1dcf74f6edfc3a9acd84d83d8865dd9e2a3b1d1e] x86_64, entry: Use split-phase syscall_trace_enter for 64-bit syscalls
git bisect good 1dcf74f6edfc3a9acd84d83d8865dd9e2a3b1d1e
# good: [aa22686f4231a72583d03882e841eba2de4b1ee6] Merge branch 'x86/platform'
git bisect good aa22686f4231a72583d03882e841eba2de4b1ee6
# first bad commit: [273299fb6380d08414b2710d007252f23b7dcc8f] Merge branch 'x86/seccomp'
