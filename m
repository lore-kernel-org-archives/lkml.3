Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbaHYUdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 16:33:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38461 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaHYUdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 16:33:37 -0400
Message-ID: <53FB9DA0.7000301@infradead.org>
Date: Mon, 25 Aug 2014 13:33:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Foley <pefoley2@pefoley.com>, linux-kernel@vger.kernel.org
CC: linux-doc@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
In-Reply-To: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/14 07:11, Peter Foley wrote:
> Change the Documentation makefiles from obj-m to subdir-y
> to avoid generating unnecessary built-in.o files since nothing
> in Documentation/ is ever linked in to vmlinux.
> 
> Signed-off-by: Peter Foley <pefoley2@pefoley.com>
> ---
>  Documentation/Makefile                         | 6 +++---
>  Documentation/accounting/Makefile              | 3 ---
>  Documentation/auxdisplay/Makefile              | 3 ---
>  Documentation/filesystems/Makefile             | 3 ---
>  Documentation/ia64/Makefile                    | 3 ---
>  Documentation/laptops/Makefile                 | 3 ---
>  Documentation/misc-devices/Makefile            | 1 +
>  Documentation/misc-devices/mei/Makefile        | 3 ---
>  Documentation/networking/Makefile              | 8 +-------
>  Documentation/networking/timestamping/Makefile | 3 ---
>  Documentation/pcmcia/Makefile                  | 3 ---
>  Documentation/spi/Makefile                     | 3 ---
>  Documentation/timers/Makefile                  | 3 ---
>  Documentation/watchdog/Makefile                | 1 +
>  Documentation/watchdog/src/Makefile            | 3 ---
>  15 files changed, 6 insertions(+), 43 deletions(-)
>  create mode 100644 Documentation/misc-devices/Makefile
>  create mode 100644 Documentation/watchdog/Makefile

Hi Peter,

Sorry about the delay and thanks for the patches.

I have now applied all 4 of these patches, with a few small changes in
Documentation/laptops/ to account for hpfall.c being renamed to freefall.c
and the problems with it having already been fixed by other patches.

[testing]

Documentation/vDSO/* does not build for me:

  HOSTCC  Documentation/vDSO/parse_vdso.o
  HOSTCC  Documentation/vDSO/vdso_test.o
  LD      Documentation/video4linux/built-in.o
  HOSTLD  Documentation/vDSO/vdso_test
  CC [M]  Documentation/video4linux/v4l2-pci-skeleton.o
/usr/lib64/gcc/x86_64-suse-linux/4.8/../../../../x86_64-suse-linux/bin/ld: warning: cannot find entry symbol _start; defaulting to 000000000040017c
Documentation/vDSO/parse_vdso.o: In function `vdso_match_version':
parse_vdso.c:(.text+0x48e): undefined reference to `strcmp'
Documentation/vDSO/parse_vdso.o: In function `vdso_sym':
parse_vdso.c:(.text+0x59c): undefined reference to `strcmp'
Documentation/vDSO/vdso_test.o: In function `main':
vdso_test.c:(.text+0x15): undefined reference to `getauxval'
vdso_test.c:(.text+0x2a): undefined reference to `puts'
vdso_test.c:(.text+0x3e): undefined reference to `getauxval'
vdso_test.c:(.text+0x6a): undefined reference to `puts'
vdso_test.c:(.text+0xa8): undefined reference to `printf'
vdso_test.c:(.text+0xb4): undefined reference to `puts'
collect2: error: ld returned 1 exit status
make[3]: *** [Documentation/vDSO/vdso_test] Error 1

I have all of the others building and vDSO commented out for now.

Any suggestions, ideas, or fixes?


Also, I haven't checked each source file individually, but I expect that
many of these are tools that could (should) be moved to $srctree/tools,
if you or anyone else is interested in that.

Thanks,
-- 
~Randy
