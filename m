Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbaFPPwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:52:20 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:57922 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaFPPwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:52:19 -0400
Date: Mon, 16 Jun 2014 17:52:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH -tip ] [Bugfix] x86/kprobes: Fix build errors and
 blacklist context_track_user
Message-ID: <20140616155213.GG32264@localhost.localdomain>
References: <539BE132.2080008@hitachi.com>
 <20140614064711.7865.45957.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140614064711.7865.45957.stgit@kbuild-fedora.novalocal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 06:47:12AM +0000, Masami Hiramatsu wrote:
> This reverts commit ecd50f714c421c759354632dd00f70c718c95b10
> since it causes build errors with CONFIG_CONTEXT_TRACKING and
> that has been made from misunderstandings; context_track_user_*()
> don't involve much in interrupt context, it just returns
> if in_interrupt() is true.
> 
> Instead of changing the do_debug/int3(), this just adds
> context_track_user_*() to kprobes blacklist, since those are
> still can be called right before kprobes handles int3 and debug
> exceptions, and probing those will cause infinit loop.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Reported-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks a lot!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
