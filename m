Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaEUXXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:23:23 -0400
Received: from one.firstfloor.org ([193.170.194.197]:58795 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaEUXXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:23:20 -0400
Date: Thu, 22 May 2014 01:23:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
Message-ID: <20140521232318.GP1873@two.firstfloor.org>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <20140521222541.GO1873@two.firstfloor.org>
 <CA+55aFzx82y5xDa3-6aLm6fCvaf23FH1E14PvmXXUFngwpkdgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzx82y5xDa3-6aLm6fCvaf23FH1E14PvmXXUFngwpkdgw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hardware-interrupts during kernel are actually fairly common under
> network-intensive loads, even outside of idle (but idle is admittedly
> likely *the* most common one). Many network loads are fairly
> kernel-intensive.

For network workloads we can arbitarily coalesce interrupts or just use NAPI
to lower the costs.  No need to optimize network interrupts too much.

-Andi

