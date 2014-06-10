Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287AbaFJIGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:06:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502AbaFJIGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:06:19 -0400
Date: Tue, 10 Jun 2014 10:03:00 +0200
From: Borislav Petkov <bp@suse.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, Russ Anderson <rja@sgi.com>
Subject: Re: [RFC] Best place/method to determine BIOS version?
Message-ID: <20140610080300.GA28607@pd.tnic>
References: <20140609200017.GD2700@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140609200017.GD2700@sgi.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 03:00:17PM -0500, Alex Thorlton wrote:
> Hi guys,
> 
> We recently ran into/corrected a bug in our BIOS that was exposed by the
> recent updates to the way that the EFI code maps in memory during boot.
> Discussion here:
> 
> http://comments.gmane.org/gmane.linux.kernel/1638074
> 
> Anyways, we now need to find a way to determine the BIOS version before
> efi_apply_memmap_quirks is called, so that we know whether or not the
> BIOS we're running requires the quirk.  We have a function in one of our
> EFI runtime services that provides this information, but I'm having a
> lot of trouble calling this function early enough in boot.
> 
> It seems that all the necessary function pointers are available well
> before efi_apply_memmap_quirks is called, but when trying to use
> efi_call_phys6 to call our function,

Why not use DMI instead of EFI for getting the BIOS version? I see
dmi_scan_machine() called earlier than efi_apply_memmap_quirks() in
setup_arch()...?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
