Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaGIS05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:26:57 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:44439 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721AbaGIS0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:26:54 -0400
Date: Wed, 9 Jul 2014 19:26:51 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, eboot: Support initrd loaded above 4G
Message-ID: <20140709182651.GB15932@console-pimps.org>
References: <1402773821-15995-1-git-send-email-yinghai@kernel.org>
 <20140618142819.GN24049@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618142819.GN24049@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun, at 03:28:19PM, Matt Fleming wrote:
> On Sat, 14 Jun, at 12:23:41PM, Yinghai Lu wrote:
> > For boot efi kernel directly without bootloader.
> > If the kernel support XLF_CAN_BE_LOADED_ABOVE_4G, we should
> > not limit initrd under hdr->initrd_add_max.
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > ---
> >  arch/x86/boot/compressed/eboot.c |   14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> Applied, thanks!

Well, fooey. This patch breaks one of my ASUS machines. It appears some
firmware implementations exhibit issues reading directly into a buffer
above the 4GB mark.

I haven't diagnosed exactly what goes wrong with the buffer (i.e. in
what way it becomes corrupt), but I should really do that before
thinking of how to fix this.

I'll keep you posted, I just wanted to give you a heads up that things
are screwy in this area.

-- 
Matt Fleming, Intel Open Source Technology Center
