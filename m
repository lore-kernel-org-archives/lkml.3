Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3GCGTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 02:19:36 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:53391 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab3GCGTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 02:19:35 -0400
Subject: Re: [PATCH -v2 4/4] x86, efi: Map runtime services 1:1
From: joeyli <jlee@suse.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
In-Reply-To: <1371491416-11037-5-git-send-email-bp@alien8.de>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
	 <1371491416-11037-5-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Jul 2013 14:19:03 +0800
Message-ID: <1372832343.26878.6.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 一，2013-06-17 於 19:50 +0200，Borislav Petkov 提到：
> +#ifdef CONFIG_X86_64
> +               efi_scratch.pgt11 = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;
> +#endif
> +               efi_use_11_map = true;
> + 

I think "efi_use_11_map = true" should moved to before "#endif",
otherwise kernel will build fail on i586 architecture.

I got build error:
arch/x86/platform/efi/efi.c:1074: error: ‘efi_use_11_map’ undeclared (first use in this function)
arch/x86/platform/efi/efi.c:1074: error: (Each undeclared identifier is reported only once
arch/x86/platform/efi/efi.c:1074: error: for each function it appears in.)


Thanks a lot!
Joey Lee

