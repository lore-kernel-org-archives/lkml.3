Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3LEKVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:21:34 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:50826 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3LEKVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:21:32 -0500
Date: Thu, 5 Dec 2013 11:21:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and
 fixes crash bugs
Message-ID: <20131205102127.GA19923@gmail.com>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
 <20131204084551.GA31772@gmail.com>
 <529FBA71.6070107@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529FBA71.6070107@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> > So we need both a maintainable and a sane/safe solution, and I'd 
> > like to apply the whole thing at once and be at ease that the 
> > solution is round. We should have done this years ago.
> 
> For the safeness of kprobes, I have an idea; introduce a whitelist 
> for dynamic events. AFAICS, the biggest unstable issue of kprobes 
> comes from putting *many* probes on the functions called from 
> tracers.

If the number of 'noprobe' annotations is expected to explode then 
maybe another approach should be considered.

For example in perf we detect recursion. Could kprobes do that and 
detect hitting a probe while running kprobes code, and ignore it [do 
an early return]?

That way most of the annotations could be removed and kprobes would 
become inherently safe. Is there any complication I'm missing?

Thanks,

	Ingo
