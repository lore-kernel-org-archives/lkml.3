Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161176Ab3FTWgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 18:36:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51333 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161077Ab3FTWgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 18:36:04 -0400
Message-ID: <51C383AC.4060706@zytor.com>
Date: Thu, 20 Jun 2013 15:35:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
References: <1371740019.2372.3.camel@dabdike> <20130620162916.GA25727@srcf.ucam.org> <1371746775.2372.11.camel@dabdike> <20130620165426.GB26214@srcf.ucam.org> <20130620170124.GA19877@pd.tnic> <20130620171210.GA26593@srcf.ucam.org> <20130620180808.GB19877@pd.tnic> <20130620181015.GA27833@srcf.ucam.org> <20130620181445.GA791@pd.tnic> <20130620181731.GA27960@srcf.ucam.org> <20130620184736.GC19877@pd.tnic>
In-Reply-To: <20130620184736.GC19877@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 11:47 AM, Borislav Petkov wrote:
> 
> I guess we can do a top-down allocation, starting from the highest
> virtual addresses:
> 
> EFI_HIGHEST_ADDRESS
> |
> | size1
> |
> --> region1
> |
> | size2
> |
> --> region2
> 
> ...
> 
> and we make EFI_HIGHEST_ADDRESS be the same absolute number on every
> system.
> 
> hpa, is this close to what you had in mind? It would be prudent to
> verify whether this will suit well with the kexec virtual space layout
> though...
> 

This would work really well, I think.  The tricky part here is to pick a
safe EFI_HIGHEST_ADDRESS as it is an ABI.

My preference would be to make EFI_HIGHEST_ADDRESS = -4 GB, which is
*not* what Windows uses, but will leave the high negative range clear,
and allows a range where we can grow down without much risk of
interfering with anything else.

	-hpa


