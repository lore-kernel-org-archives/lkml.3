Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbaFKRcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:32:36 -0400
Received: from relay2.sgi.com ([192.48.180.65]:53258 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751220AbaFKRce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:32:34 -0400
Date: Wed, 11 Jun 2014 12:32:33 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Borislav Petkov <bp@suse.de>
Cc: Alex Thorlton <athorlton@sgi.com>, Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, Russ Anderson <rja@sgi.com>
Subject: Re: efi_call on SGI
Message-ID: <20140611173233.GE3275@sgi.com>
References: <20140609200017.GD2700@sgi.com>
 <20140610080300.GA28607@pd.tnic>
 <20140610204414.GB29302@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610204414.GB29302@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 10:44:14PM +0200, Borislav Petkov wrote:
> Btw,
> 
> while we're at it, I see uv_bios_call is sometimes done with preemption
> disabled around it and sometimes it is not (at least I don't see it)...
> 
> In any case, if SGI uses the EFI pagetable now too, you probably would
> want to do the efi calls like the rest of x86 does them - see the 64-bit
> version of efi_call_virt() in arch/x86/include/asm/efi.h for an example
> what I mean.
> 
> Now, you could either copy that macro or you could accomodate it to
> serve everyone's needs - depends on what you'd prefer.
> 
> I'm just saying - I had stumbled across this while the debugging session
> was going on and wanted to point that out but it wasn't too important at
> the time so...

Thanks, Boris.  I'll take a look at that.  I'm not sure why we would've
chosen to do things differently there; wouldn't have been around for
that, but I'll see if we can fix things up so that we're doing
everything the way that everyone else is.

- Alex
