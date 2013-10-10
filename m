Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab3JJRhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:37:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab3JJRhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:37:31 -0400
Date: Thu, 10 Oct 2013 13:37:10 -0400
From: Peter Jones <pjones@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
Message-ID: <20131010173710.GA18821@fenchurch.internal.datastacks.com>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
 <20131010172844.GA26430@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131010172844.GA26430@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 07:28:44PM +0200, Ingo Molnar wrote:
> 
> Is a non-32-bit framebuffer a possibility? If yes then it might be nice to 
> emit an informative printk() here, so that users who try to enable EFI 
> early-printk can at least see why it's not working. (Assuming they get to 
> look at regular printk output, on a safe/working kernel.)

Not really - the spec allows RGBx, BGRx, and for custom bit masks, but
they're define like:

typedef struct {
	UINT32 RedMask;
	UINT32 GreenMask;
	UINT32 BlueMask;
	UINT32 ReservedMask;
} EFI_PIXEL_BITMASK;

-- 
        Peter
