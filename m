Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaIBW6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:58:32 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:56279 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaIBW6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:58:30 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8:ee7:a579:9dc:4af9:4842]
In-Reply-To: <53FB9DA0.7000301@infradead.org>
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com> <53FB9DA0.7000301@infradead.org>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 2 Sep 2014 18:58:09 -0400
Message-ID: <CAOFdcFP4b0YFMuUFKm4=FoAGbCObf4u=W0UUPwf-ju_TNvuJaA@mail.gmail.com>
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 4:33 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 04/17/14 07:11, Peter Foley wrote:
> Hi Peter,
>
> Sorry about the delay and thanks for the patches.
>
> I have now applied all 4 of these patches, with a few small changes in
> Documentation/laptops/ to account for hpfall.c being renamed to freefall.c
> and the problems with it having already been fixed by other patches.
>
> [testing]
>
> Documentation/vDSO/* does not build for me:
>
>   HOSTCC  Documentation/vDSO/parse_vdso.o
>   HOSTCC  Documentation/vDSO/vdso_test.o
>   LD      Documentation/video4linux/built-in.o
>   HOSTLD  Documentation/vDSO/vdso_test
>   CC [M]  Documentation/video4linux/v4l2-pci-skeleton.o
> /usr/lib64/gcc/x86_64-suse-linux/4.8/../../../../x86_64-suse-linux/bin/ld: warning: cannot find entry symbol _start; defaulting to 000000000040017c
> Documentation/vDSO/parse_vdso.o: In function `vdso_match_version':
> parse_vdso.c:(.text+0x48e): undefined reference to `strcmp'
> Documentation/vDSO/parse_vdso.o: In function `vdso_sym':
> parse_vdso.c:(.text+0x59c): undefined reference to `strcmp'
> Documentation/vDSO/vdso_test.o: In function `main':
> vdso_test.c:(.text+0x15): undefined reference to `getauxval'
> vdso_test.c:(.text+0x2a): undefined reference to `puts'
> vdso_test.c:(.text+0x3e): undefined reference to `getauxval'
> vdso_test.c:(.text+0x6a): undefined reference to `puts'
> vdso_test.c:(.text+0xa8): undefined reference to `printf'
> vdso_test.c:(.text+0xb4): undefined reference to `puts'
> collect2: error: ld returned 1 exit status
> make[3]: *** [Documentation/vDSO/vdso_test] Error 1
>
> I have all of the others building and vDSO commented out for now.
>
> Any suggestions, ideas, or fixes?
>
>
> Also, I haven't checked each source file individually, but I expect that
> many of these are tools that could (should) be moved to $srctree/tools,
> if you or anyone else is interested in that.
>
> Thanks,
> --
> ~Randy

So I finally found the time to look at the vDSO test and figure out
what the issue was.
However, the commits no longer seem to be in linux-next.
Is there some other tree I should be looking at?

Thanks,

Peter
