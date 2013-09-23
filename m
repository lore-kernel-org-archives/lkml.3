Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3IWIp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:45:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55035 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3IWIpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:45:24 -0400
Date: Mon, 23 Sep 2013 10:45:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20130923084514.GC2527@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-12-git-send-email-bp@alien8.de>
 <20130921113929.GB1587@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130921113929.GB1587@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 01:39:29PM +0200, Borislav Petkov wrote:
> -void __init efi_call_phys_prelog(void)
> +/*
> + * We allocate runtime services regions top-down, starting from -4G, i.e.
> + * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
> + */
> +static u64 efi_va	 = -4 * (1UL << 30);
> +#define EFI_VA_END	 (-68 * (1UL << 30))

Note to self: add this range to Documentation/x86/x86_64/mm.txt

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
