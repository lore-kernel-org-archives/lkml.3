Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbaDDPiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:38:46 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:52859 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbaDDPio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:38:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140404151203.GA12370@srcf.ucam.org>
References: <533D7C4F.4010504@zytor.com>
	<533D7C93.7080105@zytor.com>
	<20140403113921.23dceb75@gandalf.local.home>
	<533D8516.1040803@zytor.com>
	<20140403121314.246b03a7@gandalf.local.home>
	<533DED74.6050202@linux.intel.com>
	<20140403194018.7c67aec7@gandalf.local.home>
	<533DF455.4040908@linux.intel.com>
	<533DF8D2.9060508@zytor.com>
	<533E0A94.5040007@linux.intel.com>
	<20140404151203.GA12370@srcf.ucam.org>
Date: Fri, 4 Apr 2014 08:38:42 -0700
X-Google-Sender-Auth: mp9_8Ex-7p9K_hDt_odmvU45ZnE
Message-ID: <CA+55aFx+6ODkyueA2iHLhO8-eo95QYCBybhR63owxUMbhXh8wQ@mail.gmail.com>
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

On Fri, Apr 4, 2014 at 8:12 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> Production hardware should never require CF9.

That's total BS.

The fact is, we may be doing something wrong, but ACPI fails on a
*lot* of systems. A huge swath of Dell machines in particular for some
reason (laptops, desktops, _and_ now there's tablet reports).

And EFI isn't even in the running.

The keyboard controller is sadly unreliable too, although I really
don't understand why. Even when a legacy keyboard controller exists
(which isn't as universal as you'd think, even though the *hardware*
is pretty much guaranteed to be there in the chipset, it can be
disabled) there seem to be machines where the reset line isn't hooked
up. Don't ask me why. Same goes for the triple fault failure case.

End result: there's a *lot* of machines that seem to want the PCI or
legacy BIOS reboot. And it has absolutely _zero_ to do with
"production hardware".

It would be interesting if somebody can figure out *exactly* what
Windows does, because the fact that a lot of Dell machines need quirks
almost certainly means that it's _us_ doing something wrong. Dell
doesn't generally do lots of fancy odd things. I pretty much guarantee
it's because we've done something odd that Windows doesn't do.

Anyway, claiming that the PCI method shouldn't be needed is living in
some kind of dream-land. The fact is, all the other methods are
equally broken, or more so.

                 Linus
