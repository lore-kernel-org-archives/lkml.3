Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaEUMvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 08:51:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbaEUMvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 08:51:52 -0400
Date: Wed, 21 May 2014 14:51:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Andy Lutomirski <luto@amacapital.net>
cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
In-Reply-To: <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com> <1400639227.9759.21.camel@pippen.local.home> <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Andy Lutomirski wrote:

> So the issue here is that we can have an NMI followed immediately by
> an MCE.  The MCE code can call force_sig

This is interesting by itself. force_sig() takes siglock spinlock. This 
really looks like a deadlock sitting there waiting to happen.

-- 
Jiri Kosina
SUSE Labs

