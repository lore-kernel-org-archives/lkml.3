Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab3FCQYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:24:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42510 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880Ab3FCQYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:24:41 -0400
Date: Mon, 3 Jun 2013 17:24:35 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Message-ID: <20130603162435.GA22563@srcf.ucam.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <20130602225620.GA5496@srcf.ucam.org>
 <20130603081148.GB13607@nazgul.tnic>
 <1370269642.2910.4.camel@dabdike>
 <20130603143010.GA20252@srcf.ucam.org>
 <1370270282.2910.9.camel@dabdike>
 <20130603152122.GA21312@srcf.ucam.org>
 <1370276286.2910.29.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370276286.2910.29.camel@dabdike>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 09:18:06AM -0700, James Bottomley wrote:

> I don't entirely buy that.  All EFI programs run with the physical
> address map, therefore every API an EFI program uses is also tested, at
> boot time only, obviously.

That seems optimistic. Windows never calls QueryVariableInfo() during 
boot services, so what makes you think doing so has ever been tested?

> However, the ExitBootServices() code seems to be much simpler, so I 
> don't think it will cause too many bugs.  The UEFI test suites also 
> seem to try UEFI calls before and after ExitBootServices(), so I think 
> relying on a 1:1 mapping looks safer to me.

I have no expectation that the majority of system vendors run the test 
suite, but I have every expectation that every system vendor runs 
Windows. We should behave as close to the tested mechanism as possible, 
ie do what Windows does - and that includes calling 
SetVirtualAddressMap().

-- 
Matthew Garrett | mjg59@srcf.ucam.org
