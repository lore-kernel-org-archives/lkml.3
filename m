Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaEUWhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:37:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:32820 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbaEUWhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:37:13 -0400
Date: Thu, 22 May 2014 00:36:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Luck, Tony" <tony.luck@intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
Message-ID: <20140521223647.GO25130@pd.tnic>
References: <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com>
 <20140521163315.GJ21205@pd.tnic>
 <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
 <CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com>
 <20140521214845.GG25130@pd.tnic>
 <CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F328116D8@ORSMSX114.amr.corp.intel.com>
 <CALCETrWA1X-X7W7MZn5eYEO-hxWWYk3APORmH-1dw=5ua1dG+A@mail.gmail.com>
 <20140521221728.GM25130@pd.tnic>
 <CALCETrWY4OW0FF3vsS+ntALU_kmmcEB9wf0RMg-H5kSO7jQ-wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrWY4OW0FF3vsS+ntALU_kmmcEB9wf0RMg-H5kSO7jQ-wQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 03:20:50PM -0700, Andy Lutomirski wrote:
> It's not even scheduled out, right?

Right.

> This should be just like a signal from a failed page fault, I think.

Right, but there this additional work it needs to be done
(mce_notify_process()) before sending the signal. So you want to do this
after the MCE handler is done but before you return to the process.

> What switch_to?

Nevermind, that was bollocks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
