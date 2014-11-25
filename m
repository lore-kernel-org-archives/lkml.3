Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaKYT3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:29:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaKYT33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:29:29 -0500
Date: Tue, 25 Nov 2014 20:29:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Petr Mladek <pmladek@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Seth Jennings <sjenning@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
In-Reply-To: <20141125121606.547031b4@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1411252027040.23174@pobox.suse.cz>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com> <1416522580-5593-3-git-send-email-sjenning@redhat.com> <546EA5DC.6000207@hitachi.com> <20141125163942.GD22487@pathway.suse.cz> <20141125115210.4d7cfca3@gandalf.local.home>
 <20141125170431.GE22487@pathway.suse.cz> <20141125121606.547031b4@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014, Steven Rostedt wrote:

> It is not guaranteed from ftrace's stand point. What happens if we have
> a kprobe handler that modifies it for someplace else? Changing the ip
> address may not be a kpatch/kGraft privilege only.

This brings me back to the RFC patch I sent back then in october ... what 
we really want to do is to at least warn about situations when we are 
going to redirect code flow (through IPMODIFY) for function that has a 
kprobe installed anywhere inside it. Otherwise the probe will silently 
vanish (there is no way how to migrate it to the new function 
automatically), which might be very confusing for uses (cosider systemtap, 
for example).

I'll resurect my patch if noone beats me doing it. It should go in 
together with the live patching framework I believe.

Thanks,

-- 
Jiri Kosina
SUSE Labs
