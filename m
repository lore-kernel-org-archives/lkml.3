Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaDDReh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:34:37 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56559 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbaDDRef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:34:35 -0400
Date: Fri, 4 Apr 2014 19:34:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140404173431.GA25173@gmail.com>
References: <533D8516.1040803@zytor.com>
 <20140403121314.246b03a7@gandalf.local.home>
 <533DED74.6050202@linux.intel.com>
 <20140403194018.7c67aec7@gandalf.local.home>
 <533DF455.4040908@linux.intel.com>
 <533DF8D2.9060508@zytor.com>
 <533E0A94.5040007@linux.intel.com>
 <20140404151203.GA12370@srcf.ucam.org>
 <533ECC2C.6090505@zytor.com>
 <20140404153634.GA14519@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140404153634.GA14519@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Fri, Apr 04, 2014 at 08:13:48AM -0700, H. Peter Anvin wrote:
> > On 04/04/2014 08:12 AM, Matthew Garrett wrote:
> > > On Fri, Apr 04, 2014 at 09:27:48AM +0800, Li, Aubrey wrote:
> > > 
> > >> The current situation is,
> > >> - we have one(do we know more?) preproduction machine hangs by CF9.
> > >> - We have more than one(could be thousand known) production machine
> > >> works by CF9.
> > > 
> > > Production hardware should never require CF9.
> > > 
> > 
> > There are a lot of things that shouldn't be.
> 
> Windows doesn't hit CF9, and production hardware is always tested with 
> Windows, so. [...]

So why the hell does the reboot function comment claim that the 
Windows reboot sequence (which is the de facto hardware standard)
uses 0xcf9:

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

??

Thanks,

	Ingo
