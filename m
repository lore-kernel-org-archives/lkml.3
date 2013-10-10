Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3JJRp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:45:28 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:55797 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab3JJRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:45:25 -0400
Date: Thu, 10 Oct 2013 19:45:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Jones <pjones@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
Message-ID: <20131010174521.GA27218@gmail.com>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
 <20131010172844.GA26430@gmail.com>
 <20131010173710.GA18821@fenchurch.internal.datastacks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010173710.GA18821@fenchurch.internal.datastacks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Jones <pjones@redhat.com> wrote:

> On Thu, Oct 10, 2013 at 07:28:44PM +0200, Ingo Molnar wrote:
> > 
> > Is a non-32-bit framebuffer a possibility? If yes then it might be nice to 
> > emit an informative printk() here, so that users who try to enable EFI 
> > early-printk can at least see why it's not working. (Assuming they get to 
> > look at regular printk output, on a safe/working kernel.)
> 
> Not really - the spec allows RGBx, BGRx, and for custom bit masks, but
> they're define like:
> 
> typedef struct {
> 	UINT32 RedMask;
> 	UINT32 GreenMask;
> 	UINT32 BlueMask;
> 	UINT32 ReservedMask;
> } EFI_PIXEL_BITMASK;

Hm, that structure does not show up anywhere in the kernel that I can see.

How are those mask values to be interpreted? As regular bitmasks? Are bits 
in the masks set to 1 consecutively, starting from bit 0?

Also, the main question would be, what is the typical value for 
si->lfb_depth. 32 on almost all EFI systems? All around the map? Depends 
on what graphics state the EFI bootloader passes us?

Thanks,

	Ingo
