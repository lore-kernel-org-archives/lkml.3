Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167Ab3FCSFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:05:09 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43595 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757202Ab3FCSFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:05:06 -0400
Message-ID: <1370282703.9888.5.camel@dabdike>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Date: Mon, 03 Jun 2013 11:05:03 -0700
In-Reply-To: <20130603164237.GA23146@srcf.ucam.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
	 <20130602225620.GA5496@srcf.ucam.org> <20130603081148.GB13607@nazgul.tnic>
	 <1370269642.2910.4.camel@dabdike> <20130603143010.GA20252@srcf.ucam.org>
	 <1370270282.2910.9.camel@dabdike> <20130603152122.GA21312@srcf.ucam.org>
	 <1370276286.2910.29.camel@dabdike> <20130603162435.GA22563@srcf.ucam.org>
	 <1370277307.2910.39.camel@dabdike> <20130603164237.GA23146@srcf.ucam.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 17:42 +0100, Matthew Garrett wrote:
> On Mon, Jun 03, 2013 at 09:35:07AM -0700, James Bottomley wrote:
> > On Mon, 2013-06-03 at 17:24 +0100, Matthew Garrett wrote:
> > > That seems optimistic. Windows never calls QueryVariableInfo() during 
> > > boot services, so what makes you think doing so has ever been tested?
> > 
> > It's used by the UEFI shell package ... every system which boots to the
> > shell automatically tests this.  I know no locked down UEFI system ships
> > with a shell but almost every system in test has a Shell in some form,
> > so I think its fairly safe to call it from boot services.
> 
> Why do you persist in this belief that all system vendors are going to 
> have run a shell, let alone any kind of test suite? That runs counter to 
> everything we've learned about x86 firmware. People verify that it runs 
> Windows and then ship it.

I don't, but I find it hard to believe no vendor ever runs an EFI shell
on their systems.  The feedback I got from a couple of OEMs is that they
use the shell mostly for internal testing.

> > However, what about a compromise: why don't we implement 1:1 mapping and
> > then call SetVirtualAddressMap with the 1:1 map ... in theory the
> > pointer chases should then be nops (it will be replacing the physical
> > address with the same virtual address), so everything should just work
> > and anything the UEFI vendor missed will still work because the physical
> > address will work also in this scenario.
> 
> The problem there is that you're saying "In theory". We know that 
> Windows doesn't behave this way, so we have no legitimate expectation 
> that it'll work. We know that it doesn't on some Apple hardware.

Fine, you say we need to call SetVirtualAddressMap because windows does,
I agree, I'm just saying we get additional safety from calling it with
the 1:1 map ... I don't see what the problem is.

James



