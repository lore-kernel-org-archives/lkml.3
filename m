Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaIRX0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 19:26:47 -0400
Received: from ozlabs.org ([103.22.144.67]:35009 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaIRX0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:26:45 -0400
Message-ID: <1411082804.12154.26.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH 01/15] powerpc/cell: Move spu_handle_mm_fault() out of
 cell platform
From: Michael Neuling <mikey@neuling.org>
To: Jeremy Kerr <jk@ozlabs.org>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, anton@samba.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        imunsie@au.ibm.com, cbe-oss-dev@lists.ozlabs.org
Date: Fri, 19 Sep 2014 09:26:44 +1000
In-Reply-To: <541AAD26.1040607@ozlabs.org>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
	 <1411028820-29933-2-git-send-email-mikey@neuling.org>
	 <541AAD26.1040607@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -58,12 +56,12 @@ int spu_handle_mm_fault(struct mm_struct *mm, unsigned long ea,
> >  			goto out_unlock;
> >  	}
> >  
> > -	is_write = dsisr & MFC_DSISR_ACCESS_PUT;
> > +	is_write = dsisr & DSISR_ISSTORE;
> >  	if (is_write) {
> >  		if (!(vma->vm_flags & VM_WRITE))
> >  			goto out_unlock;
> >  	} else {
> > -		if (dsisr & MFC_DSISR_ACCESS_DENIED)
> > +		if (dsisr & DSISR_PROTFAULT)
> >  			goto out_unlock;
> >  		if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
> >  			goto out_unlock;
> 
> Consistent DSISR encodings? woot! :)

Yep!

arch/powerpc/include/asm/spu.h:605:#define MFC_DSISR_ACCESS_PUT         (1 << 25)
arch/powerpc/include/asm/reg.h:255:#define   DSISR_ISSTORE              0x02000000      /* access was a store */

and 

arch/powerpc/include/asm/spu.h:603:#define MFC_DSISR_ACCESS_DENIED              (1 << 27)
arch/powerpc/include/asm/reg.h:254:#define   DSISR_PROTFAULT    0x08000000      /* protection fault */

Mikey
