Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaJHTpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:45:00 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:47198 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbaJHTo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:44:59 -0400
MIME-Version: 1.0
X-Originating-IP: [129.2.129.149]
In-Reply-To: <CALCETrUDkHH-FLwq9ZJ0wFeOkQVWUjTh-cJPL4Jq28sHCqhfFA@mail.gmail.com>
References: <CA+5PVA5BeRMd28CUZPj+G2VbcwT0pG7gERk65xdMLXSp_59-RA@mail.gmail.com>
 <CALCETrUDkHH-FLwq9ZJ0wFeOkQVWUjTh-cJPL4Jq28sHCqhfFA@mail.gmail.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Wed, 8 Oct 2014 15:44:37 -0400
Message-ID: <CAOFdcFP=z4Tn-Zt6cuujGABWPDQrCy4=LzXHndB5rzFnEdyvXw@mail.gmail.com>
Subject: Re: vdso_standalone_test_x86.c build failure on Linus' tree
To: Andy Lutomirski <luto@amacapital.net>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Randy Dunlap <rdunlap@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 3:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> It should build and work on 32-bit.
>
> Except that the makefile is totally bogus.  vdso_standalone_test isn't
> a hostprog at all.  It's a target prog.  But kbuild doesn't understand
> that, so I have no idea what, if anything, that makefile is supposed
> to do.
The idea is to increase build testing for targets in Documentation,
but I didn't really consider cross-compiling those targets.

>
> I would argue that the whole documentation build system should be
> fixed to cross-compile or should just be disabled for cross-builds if
> glibc isn't available.
It might make sense to just completely disable CONFIG_BUILD_DOCSRC if
we're cross-compiling.

>
> FWIW, the comment at the top of vdso_standalone_test_x86.c documents
> *exactly* how to build it, and it works if you build it like that.

So, it looks like 32bit needs -lgcc_s
I'll whip up a patch to add that.
