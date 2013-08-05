Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3HEPdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 11:33:23 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55372 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3HEPdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 11:33:21 -0400
Date: Mon, 5 Aug 2013 17:33:19 +0200
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        matt.fleming@intel.com, linux@arm.linux.org.uk
Subject: Re: [PATCH 6/7] Add EFI stub for ARM
Message-ID: <20130805153318.GL18151@rocoto.smurfnet.nu>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
 <1375478948-22562-7-git-send-email-roy.franz@linaro.org>
 <20130805141149.GB2755@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805141149.GB2755@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 03:11:49PM +0100, Dave Martin wrote:
> > diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> > index 75189f1..4c70b9e 100644
> > --- a/arch/arm/boot/compressed/head.S
> > +++ b/arch/arm/boot/compressed/head.S
> > @@ -122,19 +122,106 @@
> >  		.arm				@ Always enter in ARM state
> >  start:
> >  		.type	start,#function
> > -		.rept	7
> > +#ifdef CONFIG_EFI_STUB
> > +		@ Magic MSDOS signature for PE/COFF + ADD opcode
> > +		.word	0x62805a4d
> 
> What about BE32?
 
The ARM bindings for UEFI specify that the processor must be in
little-endian mode.

> In that case, the instruction is a coprocessor load, that loads from a
> random address to a coprocessor that almost certainly doesn't exist.
> This will probably fault.
> 
> Since BE32 is only for older platforms (<v6) and this is not easily
> solvable, it might be sensible to make the EFI stub support depend on
> !CPU_ENDIAN_BE32.
 
Well, it would make more sense to make EFI_STUB depend on EFI and
EFI depend on !CPU_ENDIAN_BE32. Which is something I can add to
my next set of general ARM UEFI patches. Thanks.

/
    Leif
