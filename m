Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaFJUrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:47:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41426 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbaFJUre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:47:34 -0400
Date: Tue, 10 Jun 2014 22:44:14 +0200
From: Borislav Petkov <bp@suse.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, Russ Anderson <rja@sgi.com>
Subject: efi_call on SGI
Message-ID: <20140610204414.GB29302@pd.tnic>
References: <20140609200017.GD2700@sgi.com>
 <20140610080300.GA28607@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140610080300.GA28607@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw,

while we're at it, I see uv_bios_call is sometimes done with preemption
disabled around it and sometimes it is not (at least I don't see it)...

In any case, if SGI uses the EFI pagetable now too, you probably would
want to do the efi calls like the rest of x86 does them - see the 64-bit
version of efi_call_virt() in arch/x86/include/asm/efi.h for an example
what I mean.

Now, you could either copy that macro or you could accomodate it to
serve everyone's needs - depends on what you'd prefer.

I'm just saying - I had stumbled across this while the debugging session
was going on and wanted to point that out but it wasn't too important at
the time so...

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
