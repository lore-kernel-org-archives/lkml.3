Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3HERPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:15:18 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:38226 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3HERPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:15:16 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
	<CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
Date: Mon, 5 Aug 2013 10:15:15 -0700
X-Google-Sender-Auth: jWqoqVwEMOBkQ8B6b2sxTyN-DVQ
Message-ID: <CA+55aFwsw2DuyhTGxxhjN-odE+xTC1yTjd26hH6xkQi0hnuzDQ@mail.gmail.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 10:12 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Secondly, you don't want a separate section anyway for any normal
> kernel code, since you want short jumps if possible

Just to clarify: the short jump is important regardless of how
unlikely the code you're jumping is, since even if you'd be jumping to
very unlikely ("never executed") code, the branch to that code is
itself in the hot path.

And the difference between a two-byte short jump to the end of a short
function, and a five-byte long jump (to pick the x86 case) is quite
noticeable.

Other cases do long jumps by jumping to a thunk, and so the "hot case"
is unaffected, but at least one common architecture very much sees the
difference in the likely code.

              Linus
