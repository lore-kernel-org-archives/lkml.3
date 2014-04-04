Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaDDRkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:40:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62165 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaDDRkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:40:33 -0400
Date: Fri, 4 Apr 2014 19:40:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140404174029.GB25173@gmail.com>
References: <20140403194018.7c67aec7@gandalf.local.home>
 <533DF455.4040908@linux.intel.com>
 <533DF8D2.9060508@zytor.com>
 <533E0A94.5040007@linux.intel.com>
 <20140404151203.GA12370@srcf.ucam.org>
 <CA+55aFx+6ODkyueA2iHLhO8-eo95QYCBybhR63owxUMbhXh8wQ@mail.gmail.com>
 <20140404154520.GA14980@srcf.ucam.org>
 <533EDE6A.1050804@zytor.com>
 <cbb97256-9323-4d67-8523-061972e07ecc@email.android.com>
 <bc180094-55f6-426b-a8a8-f77efc581045@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc180094-55f6-426b-a8a8-f77efc581045@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On April 4, 2014 9:32:58 AM PDT, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> > Windows does ACPI first, so no. And the Dells were broken even 
> > before we moved ACPI up the list.
> 
> That's not what you said a few posts ago.

Exactly, the claim ws:

  "Windows hits the keyboard controller and then tries the ACPI vector."

Which is obviously not the same as 'Windows does ACPI first'.

So the first step _has_ to be to document exactly what Windows does, 
because that's the hardware ABI that we cannot deviate from much. Or 
if we don't know a detail, document the specific uncertainties, don't 
pretend we know it!

The current documented sequence lists 0xcf9, which seems to be a lie:

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

Thanks,

	Ingo
