Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaA0QUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 11:20:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60299 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbaA0QUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:20:08 -0500
Date: Mon, 27 Jan 2014 17:19:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        crash-utility@redhat.com, linux-kernel@vger.kernel.org,
        Dave Anderson <anderson@redhat.com>, Andrew Honig <ahonig@google.com>,
        Eugene Surovegin <surovegin@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v2] x86, kaslr: export offset in VMCOREINFO ELF notes
Message-ID: <20140127161959.GD4941@twins.programming.kicks-ass.net>
References: <20140123173120.GA25474@www.outflux.net>
 <20140125074738.GB10565@gmail.com>
 <52E669F1.9080603@intel.com>
 <20140127152557.GA27792@gmail.com>
 <52E681B6.7020501@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E681B6.7020501@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 05:56:38PM +0200, Adrian Hunter wrote:
> No. In fact annotation works now with kcore.  Linus' problem was with vmlinux.
> 
> Kcore won't be used with kaslr in the case:
> 	1. record data with 'perf record'
> 	2. reboot
> 	3. use annotation on the previously recorded data
> 
> As I noted in the commit message, you can still use kcore if you made a copy
> (with perf buildid-cache) at the time the data was recorded.

Not that I care much about this particular case; but you could also save
the offset at record time and do double offset correction assuming its
still the same kernel you booted into but at a different location.


