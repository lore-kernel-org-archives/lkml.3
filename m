Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3K2Ivs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:51:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab3K2Ivq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:51:46 -0500
Date: Fri, 29 Nov 2013 16:50:50 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 08/12] efi: only print saved efi runtime maps instead
 of all memmap ranges for kexec
Message-ID: <20131129085050.GF4186@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-9-git-send-email-dyoung@redhat.com>
 <20131127102701.GD18170@console-pimps.org>
 <20131127142726.GE32267@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127142726.GE32267@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/13 at 03:27pm, Borislav Petkov wrote:
> On Wed, Nov 27, 2013 at 10:27:01AM +0000, Matt Fleming wrote:
> > Heh, you can probably already guess what I'm going to say here...
> 
> I guessed :-)
> 
> > How about using a single function to dump the memory ranges irrespective
> > of whether the memory map comes from 'memmap' or 'esdata'? e.g.
> > something along the lines of,
> > 
> > 	if (esdata)
> > 		print_efi_memmap(esdata->map, nr_efi_runtime_map,
> > 				 sizeof(esdata->map[0]));
> > 	else
> > 		print_efi_memmap(memmap.map, memmap.nr_map,
> > 				 memmap.desc_size);
> 
> And while you're at it:
> 
> WARNING: quoted string split across lines
> #19: FILE: arch/x86/platform/efi/efi.c:443:
> +               pr_info("mem%02u: type=%u, attr=0x%llx, "
> +                       "range=[0x%016llx-0x%016llx) (%lluMB)\n",

I see the warnings, because it's originally in print_efi_memmap so I just keep
new function same. Anyway after switching to use one function there will be
no such warning.

> 
> 
> Btw, do we really want to dump the same map again in the second kernel?

It's for debugging purpose, I think it's helpful.

Thanks for review
Dave
