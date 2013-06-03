Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab3FCOc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:32:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40722 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab3FCOcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:32:54 -0400
Date: Mon, 3 Jun 2013 15:32:52 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Message-ID: <20130603143252.GB20252@srcf.ucam.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <20130602225620.GA5496@srcf.ucam.org>
 <20130603081148.GB13607@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603081148.GB13607@nazgul.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 10:11:48AM +0200, Borislav Petkov wrote:
> On Sun, Jun 02, 2013 at 11:56:20PM +0100, Matthew Garrett wrote:
> > I've just run Windows 8 under a hacked up copy of OVMF that dumps
> > the data passed to SetVirtualAddressMap. It seems that Windows *is*
> > mapping the runtime services to higher addresses - so presumably the
> > 1:1 mapping is in addition to the virtual mapping.
> 
> But but, once we call SetVirtualAddressMap with the set of addresses of
> the runtime services, only those can be used after, right? If so, we
> can't have both (this is at least my understanding)...

We can only pass one set of addresses to SetVirtualAddressMap(), but it 
doesn't seem like there's any intrinsic reason we can't the runtime 
regions mapped to multiple virtual addresses.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
