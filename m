Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568Ab3FCSLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:11:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44043 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273Ab3FCSLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:11:16 -0400
Date: Mon, 3 Jun 2013 19:11:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Message-ID: <20130603181110.GA25060@srcf.ucam.org>
References: <20130603081148.GB13607@nazgul.tnic>
 <1370269642.2910.4.camel@dabdike>
 <20130603143010.GA20252@srcf.ucam.org>
 <1370270282.2910.9.camel@dabdike>
 <20130603152122.GA21312@srcf.ucam.org>
 <1370276286.2910.29.camel@dabdike>
 <20130603162435.GA22563@srcf.ucam.org>
 <1370277307.2910.39.camel@dabdike>
 <20130603164237.GA23146@srcf.ucam.org>
 <1370282703.9888.5.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370282703.9888.5.camel@dabdike>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 11:05:03AM -0700, James Bottomley wrote:
> On Mon, 2013-06-03 at 17:42 +0100, Matthew Garrett wrote:
> > Why do you persist in this belief that all system vendors are going to 
> > have run a shell, let alone any kind of test suite? That runs counter to 
> > everything we've learned about x86 firmware. People verify that it runs 
> > Windows and then ship it.
> 
> I don't, but I find it hard to believe no vendor ever runs an EFI shell
> on their systems.  The feedback I got from a couple of OEMs is that they
> use the shell mostly for internal testing.

There are vendors that do, and I expect that there are vendors who 
don't. There are vendors who will make changes to firmware and run the 
EFI test suite, and there are vendors who will make changes to firmware 
and run Windows.

> > The problem there is that you're saying "In theory". We know that 
> > Windows doesn't behave this way, so we have no legitimate expectation 
> > that it'll work. We know that it doesn't on some Apple hardware.
> 
> Fine, you say we need to call SetVirtualAddressMap because windows does,
> I agree, I'm just saying we get additional safety from calling it with
> the 1:1 map ... I don't see what the problem is.

No. I'm saying that calling it with the 1:1 map is something very 
different to the behaviour of Windows, and I'm saying that doing so is 
known to cause variable writes on some Apple hardware to stop working. 
If we're aiming for maximum compatibility, we need to call 
SetVirtualAddressMap() with addresses above the canonicalisation hole.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
