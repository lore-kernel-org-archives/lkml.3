Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaDDRon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:44:43 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34511 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaDDRol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:44:41 -0400
Date: Fri, 4 Apr 2014 19:44:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140404174437.GC25173@gmail.com>
References: <533DED74.6050202@linux.intel.com>
 <20140403194018.7c67aec7@gandalf.local.home>
 <533DF455.4040908@linux.intel.com>
 <533DF8D2.9060508@zytor.com>
 <533E0A94.5040007@linux.intel.com>
 <20140404151203.GA12370@srcf.ucam.org>
 <533ECC2C.6090505@zytor.com>
 <20140404153634.GA14519@srcf.ucam.org>
 <20140404173431.GA25173@gmail.com>
 <bca5033b-bd33-4e5e-8893-3c9dcf76be7d@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bca5033b-bd33-4e5e-8893-3c9dcf76be7d@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> The comment header is bogus... it describes what we do, not what 
> Windows does.

That comment certainly pretends to describe Windows behavior and then 
it goes to outline the differences in Linux behavior:

/*
 * Windows compatible x86 hardware expects the following on reboot:
 *
 * 1) If the FADT has the ACPI reboot register flag set, try it
 * 2) If still alive, write to the keyboard controller
 * 3) If still alive, write to the ACPI reboot register again
 * 4) If still alive, write to the keyboard controller again
 * 5) If still alive, call the EFI runtime service to reboot
 * 6) If still alive, write to the PCI IO port 0xCF9 to reboot
 * 7) If still alive, inform BIOS to do a proper reboot
 *
 * If the machine is still alive at this stage, it gives up. We default to
 * following the same pattern, except that if we're still alive after (7) we'll
 * try to force a triple fault and then cycle between hitting the keyboard
 * controller and doing that
 */

(The 'we default' means 'Linux defaults'.)

So that comment should be fixed to describe the hardware ABI (Windows 
behavior), to the extent it is known - and then outline where and why 
Linux deviates from that. (and preferably it should match Windows 
behavior and only _add_ to that behavior at the end of the reboot 
sequence.)

Before any other change is done beyond the revert of this latest 
broken commit.

Thanks,

	Ingo
