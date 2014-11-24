Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbaKXNbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:31:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbaKXNbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:31:50 -0500
Date: Mon, 24 Nov 2014 14:31:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
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
In-Reply-To: <alpine.DEB.2.11.1411241423270.6439@nanos>
Message-ID: <alpine.LNX.2.00.1411241427281.23174@pobox.suse.cz>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com> <1416522580-5593-3-git-send-email-sjenning@redhat.com> <alpine.DEB.2.11.1411241209050.6439@nanos> <alpine.LNX.2.00.1411241414280.23174@pobox.suse.cz>
 <alpine.DEB.2.11.1411241423270.6439@nanos>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Thomas Gleixner wrote:

> > The person writing the patch would always need to understand what he is 
> > doing to be able to pick correct consistency model to be used. I 
> > personally think this is a good thing -- this is nothing where we should 
> > be relying on any kinds of tools.
> 
> But why want we to provide a mechanism which has no consistency
> enforcement at all?

"No consistency model needed" is also a consistency model in a sense that 
there is a (large) group of patches that can be applied that way. We've 
done some very rough analysis, and vast majority patches for CVE bugs with 
severity 6+ (which is in some sense the main motivation for all this) are 
applicable without any need of extra consistency model.

The "add bounds checking to syscall entry" is a prime example of that.

> Surely you can argue that the person who is doing that is supposed to 
> know what he's doing, but what's the downside of enforcing consistency 
> mechanisms on all live code changes?

The implementation of the consistency models (the ones that kgraft and 
kpatch have at least) is not really super-trivial and it's sometimes 
tricky to get it right and cover all the corner cases.

So the agreement was to do cover "no consistency model needed" group of 
live patches first, and design the API and data structures in such way 
that more sophisticated consistency models can be added on top as needed 
in the future.

-- 
Jiri Kosina
SUSE Labs
