Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab3LSQmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:42:08 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:60219 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669Ab3LSQmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:42:06 -0500
Date: Thu, 19 Dec 2013 16:41:44 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com,
        leif.lindholm@linaro.org
Subject: Re: [PATCH v6 10/14] efi: only print saved efi runtime maps instead
 of all memmap ranges for kexec
Message-ID: <20131219164144.GG3145@console-pimps.org>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
 <1387186235-15972-11-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387186235-15972-11-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Dec, at 05:30:31PM, Dave Young wrote:
> For kexec/kdump kernel efi runtime mappings are saved, printing original whole
> memmap ranges does not make sense anymore. So introduce a new function to only
> print runtime maps in case kexec/kdump kernel is used.
> 
> changelog:
> Matt: use efi_setup instead of esdata
>       share function print_efi_memmap for both normal and kexec boot.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)

Thinking about this a bit more, I'm not at all sure why this patch
exists.

Why do we not want to print the entire memory map range like we did in
the first kernel? The e820 map is printed exactly like it was in the
first kernel, why should the EFI memmap be special?

-- 
Matt Fleming, Intel Open Source Technology Center
