Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3K0O1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:27:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40133 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab3K0O1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:27:33 -0500
Date: Wed, 27 Nov 2013 15:27:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 08/12] efi: only print saved efi runtime maps instead
 of all memmap ranges for kexec
Message-ID: <20131127142726.GE32267@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-9-git-send-email-dyoung@redhat.com>
 <20131127102701.GD18170@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131127102701.GD18170@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 10:27:01AM +0000, Matt Fleming wrote:
> Heh, you can probably already guess what I'm going to say here...

I guessed :-)

> How about using a single function to dump the memory ranges irrespective
> of whether the memory map comes from 'memmap' or 'esdata'? e.g.
> something along the lines of,
> 
> 	if (esdata)
> 		print_efi_memmap(esdata->map, nr_efi_runtime_map,
> 				 sizeof(esdata->map[0]));
> 	else
> 		print_efi_memmap(memmap.map, memmap.nr_map,
> 				 memmap.desc_size);

And while you're at it:

WARNING: quoted string split across lines
#19: FILE: arch/x86/platform/efi/efi.c:443:
+               pr_info("mem%02u: type=%u, attr=0x%llx, "
+                       "range=[0x%016llx-0x%016llx) (%lluMB)\n",


Btw, do we really want to dump the same map again in the second kernel?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
