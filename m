Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3LRLmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:42:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54010 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab3LRLmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:42:36 -0500
Date: Wed, 18 Dec 2013 12:42:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: Linux EFI <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 3/3] efi: Make efi virtual runtime map passing more robust
Message-ID: <20131218114229.GA12222@pd.tnic>
References: <1387236997-26975-1-git-send-email-bp@alien8.de>
 <1387236997-26975-4-git-send-email-bp@alien8.de>
 <20131218090757.GA15594@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131218090757.GA15594@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 05:07:57PM +0800, Dave Young wrote:
> How about firstly count the md numbers in the 1st loop, then
> get/roundup the total size, alloc the pages, map the mds one by one in
> another loop.

No need as most systems would never need to reallocate. Even on Toshi's
big system, the mds fit in less than one page - having a second one is
an additional safeguard, i.e. 2 pages should be more than enough in the
majority of the cases.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
