Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab3FSQuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:50:44 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52103 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756817Ab3FSQum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:50:42 -0400
Message-ID: <1371660640.2409.44.camel@dabdike>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Date: Wed, 19 Jun 2013 09:50:40 -0700
In-Reply-To: <20130619163804.GG28300@pd.tnic>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
	 <20130619125243.GD11209@gmail.com> <20130619130225.GA28311@pd.tnic>
	 <20130619130434.GB24957@gmail.com> <20130619160804.GB27832@srcf.ucam.org>
	 <20130619161827.GF28300@pd.tnic> <20130619162115.GA28119@srcf.ucam.org>
	 <20130619163804.GG28300@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 18:38 +0200, Borislav Petkov wrote:
> On Wed, Jun 19, 2013 at 05:21:15PM +0100, Matthew Garrett wrote:
> > Yes, kexec needs a different solution.
> 
> No need. If we say, "efi=use_11_map", the 1:1 map will be shoved down
> SetVirtualAddressMap. Otherwise the high mappings.
> 
> > Because firmware images don't always update all of the pointers, and
> > so will crash if the 1:1 mappings aren't present.
> 
> Ok, so it sounds like we want to *always* create both mappings but,
> depending on what we want, to shove down SetVirtualAddressMap a
> different set. And the 1:1 map will be the optional one which we give
> SetVirtualAddressMap only when user wants it, i.e. when booting with
> "efi=1:1_map".
> 
> Makes sense?

I think it will work.  The only thing I'd worry about is aliasing.  This
scheme clearly won't work for any virtually indexed processor (so it's
basically x86 only) but even on Physically Indexed, you do have to make
sure the cache attributes of any given page are the same for all virtual
address aliases.  As long as the 1:1 mapping is writeback, I think this
is satisfied.

James


