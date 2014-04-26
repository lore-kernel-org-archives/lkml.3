Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaDZHMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 03:12:21 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:59327 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaDZHMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 03:12:20 -0400
Date: Sat, 26 Apr 2014 09:12:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [PATCH -tip v9 25/26] kprobes: Introduce kprobe cache to
 reduce cache misshits
Message-ID: <20140426071214.GA2374@gmail.com>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140417081931.26341.47154.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140424090134.GC7768@gmail.com>
 <5358F7A3.1000108@hitachi.com>
 <20140425082056.GB24829@gmail.com>
 <535A2E41.40005@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535A2E41.40005@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2014/04/25 17:20), Ingo Molnar wrote:
> > 
> > * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > 
> >>> So I don't think this should be a Kconfig entry, just enable it 
> >>> unconditionally. That will further simplify the code.
> >>
> >> Hmm, it consumes some amount of memory (36KB/core) just for the 
> >> case of several thousand of kprobes. On enterprise servers and 
> >> desktop it's OK, no problem. But I think, some embedded systems 
> >> with small resources will not want that. [...]
> > 
> > They'll just disable kprobes in general.
> 
> No, I'd like to provide kprobes (and dynamic events) to them 
> (including me) for debugging and dynamic monitoring, instead of 
> modifying code for adding events on their kernel. To solve some 
> specific issues, specific events (not generic events) are required. 
> Making local patches to add such events is an option, but it 
> increases maintenance cost for rebasing. It is better to pay cost to 
> maintain this kconfig on upstream as the maintainer for me instead 
> of paying such ugly local cost. :(
> 
> Anyway, this option is not easy for beginners, I think it should be 
> defined with "if EXPERT" option and make it enabled by default.
> 
> > Really, at this point complexity is our main concern.
> 
> Agreed about complexity issue. However, even if we remove the 
> Kconfig, we can just save 6 lines of the code, and one #ifdef block. 
> Can that really solve the complexity problem?

It's more about the mental picture about how kprobes works. The fewer 
binary state flags, the better.

Thanks,

	Ingo
