Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786AbaDCGOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 02:14:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:8553 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933607AbaDCGOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 02:14:14 -0400
Date: Thu, 3 Apr 2014 02:14:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Aubrey Li <aubrey.li@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [BUG] x86: reboot doesn't reboot
Message-ID: <20140403021411.6236996f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that one of my test boxes no longer does a reboot with the
latest kernel. It goes down and shows:

[   51.589896] reboot: Restarting system
[   51.593567] reboot: machine restart


And the system sounds like it turns off (the fans stop), but then I
just sit there and wait, and wait and wait. The system never starts up
again.

I did a bisect and it landed on: a4f1987e4c54 "x86, reboot: Add EFI and
CF9 reboot methods into the default list" which looks like a very
likely suspect. I removed that and fb3bd7b19b2b, as the second commit
was just a fix up of the first, recompiled, installed and rebooted to
that kernel. I tried to reboot again and sure enough after posting the
"machine restart" I started getting those "Press any key to continue."
messages again. That's a good sign.

Linus mentioned to me to use "reboot=pci" on the kernel command line,
but no dice. That doesn't seem to make a difference.

I see in the merge commit:

    Pull x86 reboot changes from Ingo Molnar:
     "Refine the reboot logic around the CF9 and EFI reboot methods, to make
      it more robust.  The expectation is for no working system to break,
      and for a couple of reboot-force systems to start rebooting
      automatically again"

Unfortunately, the expectation of no working system to break, didn't
quite stand up to expectations :-/

-- Steve
