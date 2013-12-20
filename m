Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3LTIVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:21:01 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:52475 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab3LTIVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:21:00 -0500
Date: Fri, 20 Dec 2013 09:20:56 +0100
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
Message-ID: <20131220082056.GA15934@gmail.com>
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
 <y0m38loefhx.fsf@fche.csb>
 <52B3C5E6.2040802@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B3C5E6.2040802@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> >  But a closer look indicates that the insertion of kprobes is 
> > taking about three (!!) orders of magnitude longer than before, as 
> > judged by the rate of increase of 'wc -l 
> > /sys/kernel/debug/kprobes/list'.
> 
> Right, because kprobes are not designed for thousands of probes.

Then this needs to be fixed, because right now this bug is making it 
near impossible to properly test kprobes robustness.

For example a hash table (hashed by probe address) could be used in 
addition to the list, to speed up basic operations.

Thanks,

	Ingo
