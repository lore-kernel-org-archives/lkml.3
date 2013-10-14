Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112Ab3JNFI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 01:08:27 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39395 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761Ab3JNFIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 01:08:25 -0400
Date: Mon, 14 Oct 2013 06:08:20 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH v2 2/2] x86/efi: Add EFI framebuffer earlyprintk support
Message-ID: <20131014050820.GK12321@console-pimps.org>
References: <1381502037-22225-1-git-send-email-matt@console-pimps.org>
 <1381502037-22225-3-git-send-email-matt@console-pimps.org>
 <20131012175615.GB18849@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131012175615.GB18849@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Oct, at 07:56:15PM, Ingo Molnar wrote:
> > +static void early_efi_write_char(u32 *dst, unsigned char c, unsigned int h)
> > +{
> > +	const u32 color_black = 0x00000000;
> > +	const u32 color_grey = 0x00aaaaaa;
> 
> I still think this should be white - that should be more visible than 
> grey, especially in brightly lit places. (And I'm really sorry about nerds 
> in the basement getting eye damage.)
> 
> Also, what is the highest byte typically, can that ever be part of 
> multiple framebuffers and can it mean an alpha channel? If yes then '0x00' 
> (read: fully translucent) might not be the best of choices for console 
> output. In that case -1 (0xffffffff) would work in a natural way.
> 
> (If it's reserved bits then it has to be all zeroes.)

The GOP part of the spec says that the top byte is reserved, and must be
set to zero, and looking at the efifb driver it disables transparency
support when allocating the color map,

int fb_alloc_cmap(struct fb_cmap *cmap, int len, int transp)

[...]

	if ((err = fb_alloc_cmap(&info->cmap, 256, 0)) < 0) {
		printk(KERN_ERR "efifb: cannot allocate colormap\n");
		goto err_unmap;
	}


-- 
Matt Fleming, Intel Open Source Technology Center
