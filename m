Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab3JaIWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:22:38 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35530 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab3JaIWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:22:35 -0400
Date: Thu, 31 Oct 2013 09:22:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -tip 1/2] [BUGFIX] kprobes/x86: Prohibit probing on
 debug_stack_*
Message-ID: <20131031082230.GA8944@gmail.com>
References: <20131030105334.7997.750.stgit@kbuild-fedora.novalocal>
 <20131030105341.7997.48258.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030105341.7997.48258.stgit@kbuild-fedora.novalocal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> -int is_debug_stack(unsigned long addr)
> +int __kprobes is_debug_stack(unsigned long addr)

_Please_ add a __noprobes method, for new annotations.

Naming it '__kprobes' is actively confusing, as it suggests that the 
function is somehow positively involved with kprobes support. 
Instead it should the noinline/notrace pattern.

I complained about this before and not much happened on this front. 
We might not want to convert the whole kernel straight away, but for 
_new_ annotations there's no excuse not to name them properly. Lets 
phase out __kprobes, and use __noprobe from now on, okay?

Thanks,

	Ingo
