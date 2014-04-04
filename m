Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaDDQJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 12:09:40 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:50778 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaDDQJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 12:09:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140404154520.GA14980@srcf.ucam.org>
References: <20140403113921.23dceb75@gandalf.local.home>
	<533D8516.1040803@zytor.com>
	<20140403121314.246b03a7@gandalf.local.home>
	<533DED74.6050202@linux.intel.com>
	<20140403194018.7c67aec7@gandalf.local.home>
	<533DF455.4040908@linux.intel.com>
	<533DF8D2.9060508@zytor.com>
	<533E0A94.5040007@linux.intel.com>
	<20140404151203.GA12370@srcf.ucam.org>
	<CA+55aFx+6ODkyueA2iHLhO8-eo95QYCBybhR63owxUMbhXh8wQ@mail.gmail.com>
	<20140404154520.GA14980@srcf.ucam.org>
Date: Fri, 4 Apr 2014 09:09:32 -0700
X-Google-Sender-Auth: aJcKJ2hXA203If8tlL__p2ZxZf0
Message-ID: <CA+55aFwiO2kcNF4=ph9UWhPB7Vd6sRZ5B6g7qFV2yAwKBLP+2Q@mail.gmail.com>
Subject: Re: [BUG] x86: reboot doesn't reboot
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 8:45 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> Which is almost certainly because the other reboot methods are trapping
> into SMI and hitting some hardware that we've left in a different state
> to Windows.

Why are you making up these completely invalid arguments? Because you
are making them up.

Our default reboot type is REBOOT_ACPI. That's the one we try *first*.
There are no "other reboot methods" playing games.

And it fails on tons of machines. It shouldn't be failing, but it is.
We are doing something sufficiently different from Windows that it
doesn't work. At some point there was some talk about having enabled
VT-d at boot but not disabled it before reboot, but that's just one
theory.

And given this *fact*, your denial that "PCI reboot should never be
used" is counterfactual. It may be true in some theoretical "this is
how the world should work" universe, but in the real world it is just
BS.

Why are you so deep in denial about this?

I'd love to fix whatever environment issue it is that causes this.
Last time people came up with situations, I offered to test patches,
because I have access to one of the failing Dell machines. Crickets.

                Linus
