Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaLPUOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 15:14:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaLPUOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 15:14:41 -0500
Date: Tue, 16 Dec 2014 21:14:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Balbir Singh <bsingharora@gmail.com>
cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv7 0/3] Kernel Live Patching
In-Reply-To: <CAKTCnzk6Kn=dngyY944k_DRyTV8dssYKhBThmdfGEm6vAPBPHg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1412162111320.1680@pobox.suse.cz>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com> <CAKTCnzk6Kn=dngyY944k_DRyTV8dssYKhBThmdfGEm6vAPBPHg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Balbir Singh wrote:

> Could you describe what this does to signing? I presume the patched
> module should cause a taint on module signing?

Hmm, why should it?

- if module signatures are enforced on the system in question, the module 
  with the patch itself has to be signed as well, otherwise it will not be 
  loaded by the kernel at all in the first place

- after the trusted (signed) module with the patch is loaded, this is in 
  principle no way different than other self-modifications the kernel is 
  performing all the time (static keys, alternatives, kprobes, ...)

Yes, we are tainting a kernel, but for reasons completely unrelated to 
module signing.

I actually think that module signing doesn't play any role whatsoever in 
what this patchset is doing.

Thanks,

-- 
Jiri Kosina
SUSE Labs
