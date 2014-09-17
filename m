Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbaIQQLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:11:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34565 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbaIQQLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:11:21 -0400
Message-ID: <1410970272.15235.32.camel@fourier>
Subject: Re: [PATCH 3.13 044/187] x86_64/entry/xen: Do not invoke espfix64
 on Xen
From: Kamal Mostafa <kamal@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, 17 Sep 2014 09:11:12 -0700
In-Reply-To: <1410953151.3040.101.camel@decadent.org.uk>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
	 <1410818997-9432-45-git-send-email-kamal@canonical.com>
	 <1410953151.3040.101.camel@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-17 at 12:25 +0100, Ben Hutchings wrote:
> On Mon, 2014-09-15 at 15:07 -0700, Kamal Mostafa wrote:
> > 3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Andy Lutomirski <luto@amacapital.net>
> > 
> > commit 7209a75d2009dbf7745e2fd354abf25c3deb3ca3 upstream.
> > 
> > This moves the espfix64 logic into native_iret.  To make this work,
> > it gets rid of the native patch for INTERRUPT_RETURN:
> > INTERRUPT_RETURN on native kernels is now 'jmp native_iret'.
> > 
> > This changes the 16-bit SS behavior on Xen from OOPSing to leaking
> > some bits of the Xen hypervisor's RSP (I think).
> > 
> > [ hpa: this is a nonzero cost on native, but probably not enough to
> >   measure. Xen needs to fix this in their own code, probably doing
> >   something equivalent to espfix64. ]
> > 
> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> > Link: http://lkml.kernel.org/r/7b8f1d8ef6597cb16ae004a43c56980a7de3cf94.1406129132.git.luto@amacapital.net
> > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> [...]
> 
> There's another fix related to espfix on Xen, commit 8762e5092828
> ("x86/espfix/xen: Fix allocation of pages for paravirt page tables").
> But I'm not sure whether it's actually needed after this.
> 
> Ben.
> 

I have now queued that one up for 3.13.11.7 also.  Thanks yet again,
Ben!

 -Kamal


