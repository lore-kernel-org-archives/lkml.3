Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaFIUAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:00:21 -0400
Received: from relay2.sgi.com ([192.48.180.65]:41081 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751879AbaFIUAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:00:19 -0400
Date: Mon, 9 Jun 2014 15:00:17 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>, Borislav Petkov <bp@suse.de>,
        Russ Anderson <rja@sgi.com>
Subject: [RFC] Best place/method to determine BIOS version?
Message-ID: <20140609200017.GD2700@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

We recently ran into/corrected a bug in our BIOS that was exposed by the
recent updates to the way that the EFI code maps in memory during boot.
Discussion here:

http://comments.gmane.org/gmane.linux.kernel/1638074

Anyways, we now need to find a way to determine the BIOS version before
efi_apply_memmap_quirks is called, so that we know whether or not the
BIOS we're running requires the quirk.  We have a function in one of our
EFI runtime services that provides this information, but I'm having a
lot of trouble calling this function early enough in boot.

It seems that all the necessary function pointers are available well
before efi_apply_memmap_quirks is called, but when trying to use
efi_call_phys6 to call our function, I always hit a kernel paging error.

I think the problem is that I really need to be doing this at a point
where I can directly use physical addressing (the function pointer that
we have stored in efi.uv_systab contains the physical address of our
function) - at least that's the idea I get from our BIOS guys, but I
really don't know what I'm talking about here :)

Can anybody help me with how early in boot I need to make this call, and
possibly with an appropriate location to stick the code in?

Any advice is greatly appreciated.  Thanks!

- Alex
