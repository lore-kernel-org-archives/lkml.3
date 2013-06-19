Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934928Ab3FSRhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:37:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36775 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717Ab3FSRh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:37:29 -0400
Date: Wed, 19 Jun 2013 19:37:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130619173721.GI28300@pd.tnic>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <51C1E996.9070209@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51C1E996.9070209@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 12:25:42PM -0500, H. Peter Anvin wrote:
> On 06/19/2013 08:02 AM, Borislav Petkov wrote:
> > 
> > And yet there are the Macs which reportedly cannot stomach this.
> > 
> No, the reports are that if you use the 1:1 map as the primary address
> on Macs the drivers fail... not that you can't have a 1:1 map.

That's what I meant: ... cannot stomach when the 1:1 map is shoved down
SetVirtualAddressMap.

The thing is, if we want to have both the 1:1 map and the high map
during an EFI runtime call, we would need to *always* switch the
pagetable for an EFI runtime call and establish both mappings in
->trampoline_pgd beforehand.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
