Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab3FSQs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:48:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38898 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3FSQs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:48:27 -0400
Date: Wed, 19 Jun 2013 17:48:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130619164822.GA28240@srcf.ucam.org>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <20130619130434.GB24957@gmail.com>
 <20130619160804.GB27832@srcf.ucam.org>
 <20130619161827.GF28300@pd.tnic>
 <20130619162115.GA28119@srcf.ucam.org>
 <20130619163804.GG28300@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619163804.GG28300@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 06:38:04PM +0200, Borislav Petkov wrote:
> On Wed, Jun 19, 2013 at 05:21:15PM +0100, Matthew Garrett wrote:
> > Yes, kexec needs a different solution.
> 
> No need. If we say, "efi=use_11_map", the 1:1 map will be shoved down
> SetVirtualAddressMap. Otherwise the high mappings.

Ah, sure - if we're willing to take an argument then we can leave it at 
that. But having a stable set of high addresses for UEFI is also an 
option.

> > Because firmware images don't always update all of the pointers, and
> > so will crash if the 1:1 mappings aren't present.
> 
> Ok, so it sounds like we want to *always* create both mappings but,
> depending on what we want, to shove down SetVirtualAddressMap a
> different set. And the 1:1 map will be the optional one which we give
> SetVirtualAddressMap only when user wants it, i.e. when booting with
> "efi=1:1_map".

Yup, I think that sounds ideal.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
