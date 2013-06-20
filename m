Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161201Ab3FTV1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:27:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50850 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161153Ab3FTV1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:27:13 -0400
Message-ID: <51C3738E.3070901@zytor.com>
Date: Thu, 20 Jun 2013 14:26:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
References: <1371491416-11037-1-git-send-email-bp@alien8.de> <20130619125243.GD11209@gmail.com> <20130619130225.GA28311@pd.tnic> <20130619130434.GB24957@gmail.com> <20130619160804.GB27832@srcf.ucam.org> <20130619161827.GF28300@pd.tnic> <20130619162115.GA28119@srcf.ucam.org> <20130619163804.GG28300@pd.tnic> <20130619164822.GA28240@srcf.ucam.org> <20130619165902.GH28300@pd.tnic>
In-Reply-To: <20130619165902.GH28300@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 09:59 AM, Borislav Petkov wrote:
> On Wed, Jun 19, 2013 at 05:48:22PM +0100, Matthew Garrett wrote:
>>> Ok, so it sounds like we want to *always* create both mappings but,
>>> depending on what we want, to shove down SetVirtualAddressMap a
>>> different set. And the 1:1 map will be the optional one which we give
>>> SetVirtualAddressMap only when user wants it, i.e. when booting with
>>> "efi=1:1_map".
>>
>> Yup, I think that sounds ideal.
> 
> Crap, I got completely sidetracked. The 1:1 mappings go in a different
> pagetable (real_mode_header->trampoline_pgd) than the kernel one
> (i.e. init_mm.pgd). However, the ->trampoline_pgd has all mappings
> anyway, which means that if we want to do EFI runtime calls with the
> high mappings but *also* have the 1:1 mappings established, we should
> *always* switch to that pagetable when doing those calls.
> 
> hpa, MattF, agreed?
> 

Yes.

	-hpa

