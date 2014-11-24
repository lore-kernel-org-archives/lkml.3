Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaKXN01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:26:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:39028 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaKXN0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:26:23 -0500
Date: Mon, 24 Nov 2014 14:26:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Kosina <jkosina@suse.cz>
cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
In-Reply-To: <alpine.LNX.2.00.1411241414280.23174@pobox.suse.cz>
Message-ID: <alpine.DEB.2.11.1411241423270.6439@nanos>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com> <1416522580-5593-3-git-send-email-sjenning@redhat.com> <alpine.DEB.2.11.1411241209050.6439@nanos> <alpine.LNX.2.00.1411241414280.23174@pobox.suse.cz>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Jiri Kosina wrote:
> On Mon, 24 Nov 2014, Thomas Gleixner wrote:
> > How is determined whether a change can be applied w/o a consistency
> > mechanism or not?
> 
> By a human being producing the "live patch" code.
> 
> If the semantics of the patch requires consistency mechanism to be applied 
> (such as "old and new function must not run in parallel, because locking 
> rules would be violated", or "return value from a function that is being 
> called in a loop is changing its meaning", etc.), then this first naive 
> implementation simply can't be used.
> 
> For simple things though, such as "add a missing bounds check to sys_foo() 
> prologue and return -EINVAL if out-of-bounds", this is sufficient.
> 
> It's being designed in a way that more advanced consistency models (such 
> as the ones kgraft and kpatch are currently implementing) can be built on 
> top of it.
> 
> The person writing the patch would always need to understand what he is 
> doing to be able to pick correct consistency model to be used. I 
> personally think this is a good thing -- this is nothing where we should 
> be relying on any kinds of tools.

But why want we to provide a mechanism which has no consistency
enforcement at all?

Surely you can argue that the person who is doing that is supposed to
know what he's doing, but what's the downside of enforcing consistency
mechanisms on all live code changes?

Thanks,

	tglx
