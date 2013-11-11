Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3KKRZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:25:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:40248 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753984Ab3KKRZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:25:42 -0500
Date: Mon, 11 Nov 2013 12:25:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, x86@kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip RFC 0/2] kprobes: introduce NOKPROBE_SYMBOL() and
 prohibit probing on .entry.text
Message-ID: <20131111122537.5c3192d2@gandalf.local.home>
In-Reply-To: <5281117D.3010202@hitachi.com>
References: <20131108125213.19972.49271.stgit@kbuild-fedora.novalocal>
	<20131111111618.GA15810@gmail.com>
	<5281117D.3010202@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Nov 2013 02:18:53 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> > After that we can convert all the rest, probably as part of this series.
> 
> OK, I'll do. :)
> BTW, converting all the __kprobes involves many archs, which
> kprobes ported. In that case, which mailing-list would better me
> to post the series, linux-arch?

I would add linux-arch.

Note, you may need to support both ways for the current time being, as
new __kprobes are being added (I've seen several in patches flying by
in LKML).

But perhaps at a later -rc we convert the rest and discontinue them.
That way, linux-next will break all new __kprobes, and that should get
them fixed before we enter 3.14-rc.

-- Steve


