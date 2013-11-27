Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3K0Ncc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:32:32 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:34315 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3K0Nc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:32:28 -0500
Date: Wed, 27 Nov 2013 14:32:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Chris Wright <chrisw@sous-sol.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rob Landley <rob@landley.net>,
        systemtap@sourceware.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alok Kataria <akataria@vmware.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v3 02/23] kprobes: Introduce NOKPROBE_SYMBOL() macro
 for blacklist
Message-ID: <20131127133224.GD18422@gmail.com>
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
 <20131120042153.15296.82087.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120042153.15296.82087.stgit@kbuild-fedora.novalocal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> +#ifdef CONFIG_KPROBES
> +/*
> + * Blacklist ganerating macro. Specify functions which is not probed
> + * by using this macro.
> + */
> +#define __NOKPROBE_SYMBOL(fname)				\
> +static struct kprobe_blackpoint __used			\
> +	_kprobe_bp_##fname = {				\
> +		.name = #fname,				\
> +		.start_addr = (unsigned long)fname,	\
> +	};						\
> +static struct kprobe_blackpoint __used			\
> +	__attribute__((section("_kprobe_blacklist")))	\
> +	*_p_kprobe_bp_##fname = &_kprobe_bp_##fname;

'kprobe_blackpoint' sounds a bit weird - how about 
'kprobe_blacklist_entry' ?

also, _kprobe_blacklist probably wants to be _kprobes_blacklist, 
right?

Thanks,

	Ingo
