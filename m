Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab3FDIQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:16:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33021 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3FDIP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:15:56 -0400
Date: Tue, 4 Jun 2013 10:15:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Linux EFI <linux-efi@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Message-ID: <20130604081544.GA23640@pd.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <20130602225620.GA5496@srcf.ucam.org>
 <20130603081148.GB13607@nazgul.tnic>
 <20130603143252.GB20252@srcf.ucam.org>
 <20130603145412.GJ2004@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130603145412.GJ2004@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 03:54:12PM +0100, Matt Fleming wrote:
> On Mon, 03 Jun, at 03:32:52PM, Matthew Garrett wrote:
> > We can only pass one set of addresses to SetVirtualAddressMap(), but it 
> > doesn't seem like there's any intrinsic reason we can't the runtime 
> > regions mapped to multiple virtual addresses.
> 
> Indeed. That's the approach I took with my 1:1 series from last year. If
> Windows is mapping things at higher addresses like you said, then
> they're probably doing the same.

Right, the way I've done it now is to do the virtual mapping
unconditionally, then do the 1:1 mapping and call SetVirtualAddressMap
(f*cking camelcase is so nasty to type - that's why they need whole IDEs
to program :-)) with that map, if "efi=1:1_map" has been passed on the
cmd line.

After the call, we use *only* the 1:1 map but the virtual mapping is
still there.

The initial approach to addressing the b0rked Macs would then be to
never use the 1:1 map on them.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
