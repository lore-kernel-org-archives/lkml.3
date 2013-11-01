Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab3KACDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 22:03:39 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52077 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3KACDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 22:03:37 -0400
Message-ID: <52730BF5.10701@hitachi.com>
Date: Fri, 01 Nov 2013 11:03:33 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -tip 1/2] [BUGFIX] kprobes/x86: Prohibit probing on debug_stack_*
References: <20131030105334.7997.750.stgit@kbuild-fedora.novalocal> <20131030105341.7997.48258.stgit@kbuild-fedora.novalocal> <20131031082230.GA8944@gmail.com>
In-Reply-To: <20131031082230.GA8944@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/31 17:22), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> -int is_debug_stack(unsigned long addr)
>> +int __kprobes is_debug_stack(unsigned long addr)
> 
> _Please_ add a __noprobes method, for new annotations.

Ah, OK. I'll send new series.

> Naming it '__kprobes' is actively confusing, as it suggests that the 
> function is somehow positively involved with kprobes support. 
> Instead it should the noinline/notrace pattern.
> 
> I complained about this before and not much happened on this front. 
> We might not want to convert the whole kernel straight away, but for 
> _new_ annotations there's no excuse not to name them properly. Lets 
> phase out __kprobes, and use __noprobe from now on, okay?

I see it. :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


