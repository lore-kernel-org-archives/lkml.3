Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab3LDIp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:45:57 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:49809 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab3LDIpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:45:55 -0500
Date: Wed, 4 Dec 2013 09:45:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and
 fixes crash bugs
Message-ID: <20131204084551.GA31772@gmail.com>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Hi,
> Here is the version 4 of NOKPORBE_SYMBOL series.
> 
> In this version, I removed the cleanup patches and
> add bugfixes I've found, since those bugs will be
> critical.
>
> Rest of the cleanup and visible blacklists will be proposed later in 
> another series.

Ok, let me make it clear: we need _both_ the conceptual cleanups and 
the bug fixes.

Right now kprobes are restricted to root, and they are unsafe and 
buggy, and rather fundamentally so, because probing cannot be done 
safely without potentially crashing the kernel. So there's no 
'regression' to be fixed, it's mostly about pre-existing bugs - so 
there's no requirement for them to come before maintainability 
cleanups.

So we need both a maintainable and a sane/safe solution, and I'd like 
to apply the whole thing at once and be at ease that the solution is 
round. We should have done this years ago.

So could you please send a whole series that I can apply to -tip as a 
work in progress tree, and then we can see what is left to be solved?

Thanks,

	Ingo
