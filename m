Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaEUWZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:25:44 -0400
Received: from one.firstfloor.org ([193.170.194.197]:58429 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaEUWZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:25:43 -0400
Date: Thu, 22 May 2014 00:25:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
Message-ID: <20140521222541.GO1873@two.firstfloor.org>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Seems like a lot of effort and risk to essentially only optimize in kernel
interrupt handlers.

AFAIK the most interesting cases (like user page faults) are not
affected at all. Usually most workloads don't spend all that much time
in the kernel, so it won't help most interrupts.

I suspect the only case that's really interesting here is interrupting
idle. Maybe it would be possible to do some fast path in this case only.

However idle currently has so much overhead that I suspect that there 
are lower hanging fruit elsewhere.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
