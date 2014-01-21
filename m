Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbaAUK1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:27:11 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:59388 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbaAUK1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:27:04 -0500
Date: Tue, 21 Jan 2014 11:27:00 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Cong Ding <dinggnu@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140121102700.GB2981@gmail.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
 <CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
 <CA+55aFyaf2B4Fo-dCJUJ=03aPVdLF7r4uMYNduYPMFwJQYngcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyaf2B4Fo-dCJUJ=03aPVdLF7r4uMYNduYPMFwJQYngcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Jan 20, 2014 at 2:54 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > So I pulled this, but one question:
> 
> .. oh, and since I decided to test it, and was looking for problems: 
> enabling kaslr breaks "perf". The *profile* looks fine, but the 
> disassembly doesn't work.
> 
> I'm not entirely surprised. I decided I wanted to test it for a 
> reason, after all. So it's not unexpected, but perhaps people hadn't 
> thought about it, and clearly hadn't tested it.
> 
> Kernel modules disassemble fine, so clearly perf knows about code 
> that moves around, but apparently it gets surprised when the core 
> vmlinux file disassembly doesn't match addresses.

Hm, live annotation of the kernel image is a relatively new perf 
feature, and KASLR predated that (by years) - which would at least in 
part explain why it went unnoticed. (Although it does not excuse the 
lack of testing.)

I've Cc:-ed Adrian Hunter, the author of the /proc/kcore annotation 
feature.

Adrian: enabling x86 KASLR in Linus's latestest kernel via 
CONFIG_RANDOMIZE_BASE=y [this is also present in the -tip tree] breaks 
/proc/kcore annotation, because the kernel image position is now per 
bootup randomized and perf's annotation code gets surprised by that.

Thanks,

	Ingo
