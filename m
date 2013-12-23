Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab3LWNEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 08:04:45 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:51614 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab3LWNEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 08:04:43 -0500
Date: Mon, 23 Dec 2013 14:04:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v6 00/22] kprobes: introduce NOKPROBE_SYMBOL(),
 cleanup and fixes crash bugs
Message-ID: <20131223130438.GA5076@gmail.com>
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
 <y0m38loefhx.fsf@fche.csb>
 <52B3C5E6.2040802@hitachi.com>
 <20131220082056.GA15934@gmail.com>
 <52B40E79.8040701@hitachi.com>
 <20131220104615.GA22609@gmail.com>
 <52B75542.7040600@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B75542.7040600@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> > I can reproduce one weirdness, with just 13 probes added, 'perf probe 
> > -l' [which should really be 'perf probe list'!] executes very slowly:
> > 
> >  # perf stat --null --repeat 3 perf probe -l
> > 
> >  Performance counter stats for 'perf probe -l' (3 runs):
> > 
> >        0.763640098 seconds time elapsed                                          ( +-  1.61% )
> > 
> > 0.7 seconds is ridiculously long.
> 
> This comes from the perf-probe's internal issue. It tries to get 
> actual lines and files by using debuginfo. I guess most of the time 
> consumed when processing huge kernel debuginfo.

No, I don't have any debuginfo, I never use it.

Thanks,

	Ingo
