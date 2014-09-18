Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbaIRKAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 06:00:11 -0400
Received: from ozlabs.org ([103.22.144.67]:58314 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935AbaIRKAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 06:00:09 -0400
Message-ID: <541AAD26.1040607@ozlabs.org>
Date: Thu, 18 Sep 2014 18:00:06 +0800
From: Jeremy Kerr <jk@ozlabs.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>, greg@kroah.com, arnd@arndb.de,
        mpe@ellerman.id.au, benh@kernel.crashing.org
CC: anton@samba.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        imunsie@au.ibm.com, cbe-oss-dev@lists.ozlabs.org
Subject: Re: [PATCH 01/15] powerpc/cell: Move spu_handle_mm_fault() out of
 cell platform
References: <1411028820-29933-1-git-send-email-mikey@neuling.org> <1411028820-29933-2-git-send-email-mikey@neuling.org>
In-Reply-To: <1411028820-29933-2-git-send-email-mikey@neuling.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikey & Ian,

> Currently spu_handle_mm_fault() is in the cell platform.
> 
> This code is generically useful for other non-cell co-processors on powerpc.
> 
> This patch moves this function out of the cell platform into arch/powerpc/mm so
> that others may use it.

Makes sense.

Acked-by: Jeremy Kerr <jk@ozlabs.org>

> @@ -58,12 +56,12 @@ int spu_handle_mm_fault(struct mm_struct *mm, unsigned long ea,
>  			goto out_unlock;
>  	}
>  
> -	is_write = dsisr & MFC_DSISR_ACCESS_PUT;
> +	is_write = dsisr & DSISR_ISSTORE;
>  	if (is_write) {
>  		if (!(vma->vm_flags & VM_WRITE))
>  			goto out_unlock;
>  	} else {
> -		if (dsisr & MFC_DSISR_ACCESS_DENIED)
> +		if (dsisr & DSISR_PROTFAULT)
>  			goto out_unlock;
>  		if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
>  			goto out_unlock;

Consistent DSISR encodings? woot! :)

Cheers,


Jeremy
