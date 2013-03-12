Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab3CLQEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:04:05 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:38633 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab3CLQED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:04:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130311142233.19885.10567.stgit@mhiramat-M0-7522>
References: <20130311142233.19885.10567.stgit@mhiramat-M0-7522>
Date: Tue, 12 Mar 2013 09:04:01 -0700
X-Google-Sender-Auth: 9Lil1z3ba-NnX9N91Oe8kQLjzmg
Message-ID: <CA+55aFz28CvntOMF-Te0x=gn=XQcU8Zzi6E0iAhZb9mG5J-Ppg@mail.gmail.com>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Move hash_64() into .text.kprobe section
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 7:22 AM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> Beacuse hash_64() is called from the get_kprobe() inside
> int3 handler, kernel causes int3 recursion and crashes if
> kprobes user puts a probe on it.
>
> Usually hash_64() is inlined into caller function, but in
> some cases, it has instances by gcc's interprocedural
> constant propagation.
>
> This patch adds __kprobes tag on the hash_64()

NAK. Don't do this. Just force inlining. There's absolutely no way we
want to start adding __kprobe to random helper functions like this.

This isn't even about where "__kprobes" exists and whether we want to
include the header file. This is about the fact that hash64 has
absolutely *nothing* to do with kprobes, and we simply shouldn't do
crap like this regardless of whether we need a new #include or not.

                  Linus
