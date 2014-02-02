Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaBBLQD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 06:16:03 -0500
Received: from mout.gmx.net ([212.227.15.18]:53238 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaBBLQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 06:16:00 -0500
Date: Sun, 2 Feb 2014 12:15:52 +0100
From: Helge Deller <deller@gmx.de>
To: Richard Weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org
Cc: Helge Deller <deller@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] parisc updates for v3.14
Message-ID: <20140202111552.GA2221@ls3530.box>
References: <20140201202320.GA1313@p100.box>
 <CAFLxGvy7vbKmQzyNvTbk35DX5cFGS99CE=nYE_Q0c=LVuD1x9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvy7vbKmQzyNvTbk35DX5cFGS99CE=nYE_Q0c=LVuD1x9A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:2j1ToopxvFcRBdDfKRz3HppbOtB6Lgf+G/snH265DuiKAnNVXno
 9fplVUYeaC1qvmn8yQzb1MDIC6Xk5YxmEFaycaLbbuOaKurfXi2YOl3OfpmfI6airIsapfj
 T2FY63ulLwKtGgJsa4r3Ewb9LUuQhH8raVDaWa9LqVw52QBnDLhFQad2LleMFfIpph6ZlIs
 mHx44qFSZhTz3dsstbpIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Richard Weinberger <richard.weinberger@gmail.com>:
> On Sat, Feb 1, 2014 at 9:23 PM, Helge Deller <deller@gmx.de> wrote:
> > please pull the latest updates for the parisc architecture from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-for-3.14
> >
> > The three major changes in this patchset is a implementation for flexible
> > userspace memory maps, ....
> >
> > The change to fs/exec.c only touches code which affects parisc since it's
> > inside a #ifdef CONFIG_STACK_GROWSUP section (and parisc is the only platform
> > where the stack grows upwards).
> 
> What about metag?

Great! I didn't know that we now have another platform where the stack
grows upwards! Now we are not alone in this regard!

Anyway, the suggested & untested patch below should fix the metag arch
to cope which my changes to fs/exec.c  (unless the metag people want to
implement proper stack randomization too).  Either I can push it via the
parisc tree, or you can take it via the metag tree. Please let me know.


> > Helge Deller (5):
> >       parisc: add flexible mmap memory layout support
> > ...
> >  fs/exec.c                             |   3 +
(see:
http://git.kernel.org/cgit/linux/kernel/git/deller/parisc-linux.git/commit/?h=for-next&id=13de8ec38997357c9865a36a587439d9c5678932 )



[PATCH] metag: define STACK_RND_MASK as -1
 
Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/metag/include/asm/elf.h b/arch/metag/include/asm/elf.h
index d2baf69..089e37a 100644
--- a/arch/metag/include/asm/elf.h
+++ b/arch/metag/include/asm/elf.h
@@ -100,7 +100,7 @@ typedef unsigned long elf_fpregset_t;
 
 #define ELF_PLATFORM  (NULL)
 
-#define STACK_RND_MASK (0)
+#define STACK_RND_MASK (-1)
 
 #ifdef CONFIG_METAG_USER_TCM
 


