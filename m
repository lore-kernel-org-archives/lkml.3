Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab3EBMua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:50:30 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23133 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab3EBMu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:50:28 -0400
Date: Thu, 2 May 2013 08:50:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, rjw@sisk.pl,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH] x86, x86-64, gdt, hibernate: Store/load GDT for
 hibernate path.
Message-ID: <20130502125000.GA5824@konrad-lan.dumpdata.com>
References: <1367459610-9656-1-git-send-email-konrad.wilk@oracle.com>
 <1367459610-9656-2-git-send-email-konrad.wilk@oracle.com>
 <20130502123438.GD22618@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502123438.GD22618@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 02:34:38PM +0200, Pavel Machek wrote:
> Hi!
> 
> > The git commite7a5cd063c7b4c58417f674821d63f5eb6747e37
> > ("x86-64, gdt: Store/load GDT for ACPI S3 or hibernate/resume path
> > is not needed.") assumes that for the hibernate path the booting
> > kernel and the resuming kernel MUST be the same. That is certainly
> > the case for a 32-bit kernel (see check_image_kernel and
> > CONFIG_ARCH_HIBERNATION_HEADER config option).
> > 
> > However for 64-bit kernels it is OK to have a different kernel
> > version (and size of the image) of the booting and resuming kernels.
> > Hence the above mentioned git commit introduces an regression.
> 
> Ok.
> 
> > This patch fixes it by introducing a 'struct desc_ptr gdt_desc'
> > back in the 'struct saved_context'. However instead of having in the
> > 'save_processor_state' and 'restore_processor_state' the
> > store/load_gdt calls, we are only saving the GDT in the
> > save_processor_state.
> > 
> > For the restore path the lgdt operation is done in
> > hibernate_asm_[32|64].S in the 'restore_registers' path.
> 
> So the on-disk format changed and we need to bump the version number
> somewhere?

Fortunatly not. The patch (7a5cd063c7b4c58417f674821d63f5eb6747e37) that
just just landed in Linus a couple of days ago did change it a bit
(as the 'saved_context' struct shrunk), but this patch brings it back
to what it was before. But I don't know if the 'saved_context' structure
is actually somewhere specifically mentioned as 'on-disk' or in the
kernel.

Looking at the code, I think the on-disk structure you are referring to
is the 'struct restore_data_record' (please correct me if I am
incorrect) which has not been affected by any of these patches.

> 
> I guess we should add big fat warning to the affected structures.

We certainly can. I can prep a patch to that affect on Friday or Monday.
> 
> 								Pavel
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
