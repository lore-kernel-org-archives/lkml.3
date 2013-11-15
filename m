Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3KOQnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:43:20 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:18812 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751848Ab3KOQnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:43:12 -0500
Date: Fri, 15 Nov 2013 11:43:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip RFC v2 01/22] kprobes: Prohibit probing on
 .entry.text code
Message-ID: <20131115114306.5d14db66@gandalf.local.home>
In-Reply-To: <20131115045318.27580.69554.stgit@kbuild-fedora.novalocal>
References: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
	<20131115045318.27580.69554.stgit@kbuild-fedora.novalocal>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Nov 2013 04:53:18 +0000
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> .entry.text is a code area which is used for interrupt/syscall
> entries, and there are many sensitive codes.
> Thus, it is better to prohibit probing on all of such codes
> instead of a part of that.
> Since some symbols are already registered on kprobe blacklist,
> this also removes them from the blacklist.

This change only works with x86. On other archs, I get this:

kernel/built-in.o: In function `register_kprobe':
(.kprobes.text+0x9f4): undefined reference to `__entry_text_start'
kernel/built-in.o: In function `register_kprobe':
(.kprobes.text+0x9f8): undefined reference to `__entry_text_end'
make[1]: *** [vmlinux] Error 1
make: *** [sub-make] Error 2

-- Steve
