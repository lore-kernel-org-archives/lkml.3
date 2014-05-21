Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaEUXC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:02:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36958 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaEUXC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:02:28 -0400
Date: Thu, 22 May 2014 01:02:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Luck, Tony" <tony.luck@intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
Message-ID: <20140521230202.GA28950@pd.tnic>
References: <20140521214845.GG25130@pd.tnic>
 <CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F328116D8@ORSMSX114.amr.corp.intel.com>
 <CALCETrWA1X-X7W7MZn5eYEO-hxWWYk3APORmH-1dw=5ua1dG+A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3281189E@ORSMSX114.amr.corp.intel.com>
 <CALCETrXMe_rvKBcZpGhodXO1WY44WHSyZM8OKQG-AXm=X0kMrw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3281198D@ORSMSX114.amr.corp.intel.com>
 <CALCETrXxEAwJ33bF7FeRLeCbE7BfMn==OsFsoorW_NWFLxwuew@mail.gmail.com>
 <20140521224816.GP25130@pd.tnic>
 <CALCETrV+8_p5bkeK7zQZ8r8Cq182eYdUNmh72y_vH_4SND-irw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrV+8_p5bkeK7zQZ8r8Cq182eYdUNmh72y_vH_4SND-irw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 03:52:16PM -0700, Andy Lutomirski wrote:
> I'm suggesting that you re-enable interrupts and do the work in
> do_machine_check. I think it'll just work. It might pay to set a flag
> so that you panic very loudly if do_machine_check recurses.

And that might happen very likely if we're trying to poison a page which
is shared by a couple of processes' mm's and some process on some cpu
starts touching it.

So keeping all cpus in a holding pattern is much more safe, IMO. (#MC is
broadcasted on Intel, I'm sure you know).

And even if it made sense, why go the trouble? To shorten the time we're
in the MCE handler? Well, if we spend too much time in it, then the box
is dying anyway. On a normal, healthy hw, do_machine_check doesn't run.

:-)

> I suspect that, if the hardware is generating machine checks while
> doing memory poisoning, the hardware is broken enough that even
> panicking might not work, though :)

Yeah, in such cases, they tend to escalate to fatal errors very fast so
we panic right on the spot.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
