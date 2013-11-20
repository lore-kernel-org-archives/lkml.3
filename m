Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3KTPiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:38:08 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:40722 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3KTPiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:38:06 -0500
Date: Wed, 20 Nov 2013 16:38:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, systemtap@sourceware.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v3 00/23] kprobes: introduce NOKPROBE_SYMBOL() and
 general cleaning of kprobe blacklist
Message-ID: <20131120153801.GA9743@gmail.com>
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
 <y0mvbznxi6k.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mvbznxi6k.fsf@fche.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> masami.hiramatsu.pt wrote:
> 
> > [...]  This series also includes a change which prohibits probing 
> > on the address in .entry.text because the code is used for very 
> > low-level sensitive interrupt/syscall entries. Probing such code 
> > may cause unexpected result (actually most of that area is already 
> > in the kprobe blacklist).  So I've decide to prohibit probing all 
> > of them. [...]
> 
> Does this new blacklist cover enough that the kernel now survives a 
> broadly wildcarded perf-probe, e.g. over e.g. all of its kallsyms?

That's generally the purpose of the annotations - if it doesn't then 
that's a bug.

Thanks,

	Ingo
