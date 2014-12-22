Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaLVXTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:19:10 -0500
Received: from p3plsmtpa07-05.prod.phx3.secureserver.net ([173.201.192.234]:60646
	"EHLO p3plsmtpa07-05.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbaLVXTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:19:08 -0500
Message-ID: <5498A6E8.8000600@lurklurk.org>
Date: Mon, 22 Dec 2014 18:19:04 -0500
From: David Drysdale <dmd@lurklurk.org>
Reply-To: David Drysdale <drysdale@google.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Drysdale <drysdale@google.com>, torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, nab@linux-iscsi.org,
        linux-kernel@vger.kernel.org, mmarek@suse.cz, jkosina@suse.cz
Subject: Re: Linux 3.19-rc1 - merge window closed
References: <CAHse=S-CGRrXPZXooHsnqO6BJytBKE4t=V_ESHL1m6Gjzeg9GQ@mail.gmail.com>
In-Reply-To: <CAHse=S-CGRrXPZXooHsnqO6BJytBKE4t=V_ESHL1m6Gjzeg9GQ@mail.gmail.com>
X-Forwarded-Message-Id: <CAHse=S-CGRrXPZXooHsnqO6BJytBKE4t=V_ESHL1m6Gjzeg9GQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 Dec 2014 18:02, "Linus Torvalds" <torvalds@linux-foundation.org> 
wrote:
  >
  > On Mon, Dec 22, 2014 at 2:43 PM, Nicholas A. Bellinger
  > <nab@linux-iscsi.org> wrote:
  > > On Mon, 2014-12-22 at 21:56 +0100, Jiri Kosina wrote:
  > >> On Mon, 22 Dec 2014, Andrew Morton wrote:
  > >>
  > >> > On Sat, 20 Dec 2014 23:11:39 -0800 "Nicholas A. Bellinger"
<nab@linux-iscsi.org> wrote:
  > >> >
  > >> > > Just hit the following build failure with CONFIG_AUDIT=y:
  > >> > >
  > >> > > arch/x86/ia32/audit.c: In function ‘ia32_classify_syscall’:
  > >> > > arch/x86/ia32/audit.c:38:7: error: ‘__NR_execveat’ undeclared
(first use in this function)
  > >> > > arch/x86/ia32/audit.c:38:7: note: each undeclared identifier
is reported only once for each function it appears in
  > >> > > make[2]: *** [arch/x86/ia32/audit.o] Error 1
  > >> > > make[1]: *** [arch/x86/ia32] Error 2
  > >> > > make: *** [arch/x86] Error 2
  > >> > > make: *** Waiting for unfinished jobs....
  > >> >
  > >
  > > Yep, post 'make mrproper' builds with CONFIG_AUDIT=y don't hit this
  > > failure.
  > >
  > > The previous build was with v3.18-rc2 btw.
  >
  > Hmm. So it seems that there is something wrong with the dependency
  > generation for the generated header files. Possibly limited to just
  > the uapi files.
  >
  > But I can't seem to recreate it even by trying to first build 3.18-rc2
  > and then switching to 3.19-rc1. So there's something
  > not-very-straightforward going on, possibly including some nasty race
  > in the Makefiles.
  >
  >                          Linus

When this occurred previously, I also failed to reproduce it.  However, 
it appeared (https://lkml.org/lkml/2014/11/25/542) to specifically 
involve a stale copy of arch/x86/include/generated/asm/unistd_32.h.

David
