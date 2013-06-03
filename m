Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab3FCV3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 17:29:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46716 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3FCV3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 17:29:34 -0400
Date: Mon, 3 Jun 2013 22:29:30 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Message-ID: <20130603212930.GA28955@srcf.ucam.org>
References: <20130603143010.GA20252@srcf.ucam.org>
 <1370270282.2910.9.camel@dabdike>
 <20130603152122.GA21312@srcf.ucam.org>
 <1370276286.2910.29.camel@dabdike>
 <20130603162435.GA22563@srcf.ucam.org>
 <1370277307.2910.39.camel@dabdike>
 <20130603164237.GA23146@srcf.ucam.org>
 <1370282703.9888.5.camel@dabdike>
 <20130603181110.GA25060@srcf.ucam.org>
 <1370294345.9888.12.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370294345.9888.12.camel@dabdike>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 02:19:05PM -0700, James Bottomley wrote:
> On Mon, 2013-06-03 at 19:11 +0100, Matthew Garrett wrote:
> > No. I'm saying that calling it with the 1:1 map is something very 
> > different to the behaviour of Windows, and I'm saying that doing so is 
> > known to cause variable writes on some Apple hardware to stop working. 
> > If we're aiming for maximum compatibility, we need to call 
> > SetVirtualAddressMap() with addresses above the canonicalisation hole.
> 
> OK, so tell me this problem: it's a new one one me.  I think you're
> saying if we don't call SetVirtualAddressMap with a mapping above a
> certain value, some Apple system breaks somehow? (how?).

SetVariable() returns an error. Digging through disassembly of the code 
generating the error got me to the point of realising it was doing some 
sort of pointer arithmetic and then giving up.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
