Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaEUXaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:30:35 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:36218 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaEUXae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:30:34 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F32811C5F@ORSMSX114.amr.corp.intel.com>
References: <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
	<CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com>
	<20140521214845.GG25130@pd.tnic>
	<CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F328116D8@ORSMSX114.amr.corp.intel.com>
	<CALCETrWA1X-X7W7MZn5eYEO-hxWWYk3APORmH-1dw=5ua1dG+A@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F3281189E@ORSMSX114.amr.corp.intel.com>
	<CALCETrXMe_rvKBcZpGhodXO1WY44WHSyZM8OKQG-AXm=X0kMrw@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F3281198D@ORSMSX114.amr.corp.intel.com>
	<CALCETrXxEAwJ33bF7FeRLeCbE7BfMn==OsFsoorW_NWFLxwuew@mail.gmail.com>
	<20140521224816.GP25130@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F32811B92@ORSMSX114.amr.corp.intel.com>
	<CALCETrVfas7s_F1bFnJou=ymra5zmc3DTeiEm+DDjKJg+J=0qg@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F32811C5F@ORSMSX114.amr.corp.intel.com>
Date: Thu, 22 May 2014 08:30:33 +0900
X-Google-Sender-Auth: xgLx2TgdRAOqRWjJ_D6BjIsx9Hg
Message-ID: <CA+55aFwXTME_Ge53xKjyM35mVQ+gmvDPwTLa5kR5zAMnNTFSbQ@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 8:19 AM, Luck, Tony <tony.luck@intel.com> wrote:
>
> Yes. Bystander broadcast machine checks can and will hit processors
> that are in NMI context ... and we must not make that fatal.

.. and this, btw, is just another example of why MCE hardware
designers are f*cking morons that should be given extensive education
about birth control and how not to procreate.

MCE is frankly misdesigned. It's a piece of shit, and any of the
hardware designers that claim that what they do is for system
stability are out to lunch. This is a prime example of what *NOT* to
do, and how you can actually spread what was potentially a localized
and recoverable error, and make it global and unrecoverable.

Can we please get these designers either fired, or re-educated?
Because this shit has been going on too long. I complained about this
to Tony many years ago, and nothing was ever fixed.

Synchronous MCE's are fine for synchronous errors, but then trying to
turn them "synchronous" for other CPU's (where they *weren't*
synchronous errors) is a major mistake. External errors punching
through irq context is wrong, punching through NMI is just
inexcusable.

If the OS then decides to take down the whole machine, the OS - not
the hardware - can choose to do something that will punch through
other CPU's NMI blocking (notably, init/reset), but the hardware doing
this on its own is just broken if true.

Anyway, I repeat: I refuse to fix hardware bugs. As far as we are
concerned, this is "best effort", and the hardware designers should
take a long deep look at their idiotic schemes. If something punches
through NMI, it's deadly. It's that simple.

                 Linus
