Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaEUWwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:52:41 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:55048 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaEUWwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:52:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140521224816.GP25130@pd.tnic>
References: <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
 <CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com>
 <20140521214845.GG25130@pd.tnic> <CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F328116D8@ORSMSX114.amr.corp.intel.com>
 <CALCETrWA1X-X7W7MZn5eYEO-hxWWYk3APORmH-1dw=5ua1dG+A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3281189E@ORSMSX114.amr.corp.intel.com>
 <CALCETrXMe_rvKBcZpGhodXO1WY44WHSyZM8OKQG-AXm=X0kMrw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3281198D@ORSMSX114.amr.corp.intel.com>
 <CALCETrXxEAwJ33bF7FeRLeCbE7BfMn==OsFsoorW_NWFLxwuew@mail.gmail.com> <20140521224816.GP25130@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 15:52:16 -0700
Message-ID: <CALCETrV+8_p5bkeK7zQZ8r8Cq182eYdUNmh72y_vH_4SND-irw@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 3:48 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, May 21, 2014 at 03:39:11PM -0700, Andy Lutomirski wrote:
>> But if we get a new MCE in here, it will be an MCE from kernel context
>> and it's fatal. So, yes, we'll clobber the stack, but we'll never
>> return (unless tolerant is set to something insane), so who cares?
>
> Ok, but we still have to do the work before returning to the process. So
> if not mce_notify_process() how else are you suggesting we do this?

I'm suggesting that you re-enable interrupts and do the work in
do_machine_check.  I think it'll just work.  It might pay to set a
flag so that you panic very loudly if do_machine_check recurses.

I suspect that, if the hardware is generating machine checks while
doing memory poisoning, the hardware is broken enough that even
panicking might not work, though :)

--Andy
