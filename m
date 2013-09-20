Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab3ITJt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:49:29 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60719 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754275Ab3ITJt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:49:28 -0400
Date: Fri, 20 Sep 2013 10:49:13 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Young <dyoung@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH 00/11] EFI runtime services virtual mapping
Message-ID: <20130920094913.GG4785@console-pimps.org>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20130920072904.GA21922@dhcp-16-126.nay.redhat.com>
 <20130920090544.GA9574@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130920090544.GA9574@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Sep, at 11:05:44AM, Borislav Petkov wrote:
> > Another concern is that is it safe for i386 efi boot?
> 
> That's why I didn't put a git tree on k.org - I wanted to run tests
> myself before Fengguang's robot :)
> 
> But no, 32-bit is not addressed here. Which just dawned on me: Matt, I
> probably should keep the ioremapping code for 32-bit, doh. I completely
> went 64-bit only here :-)

/home/build/git/efi/arch/x86/platform/efi/efi.c: In function ‘__map_region’:
/home/build/git/efi/arch/x86/platform/efi/efi.c:753:24: error: ‘struct real_mode_header’ has no member named ‘trampoline_pgd’
/home/build/git/efi/arch/x86/platform/efi/efi.c: In function ‘efi_enter_virtual_mode’:
/home/build/git/efi/arch/x86/platform/efi/efi.c:863:64: error: ‘struct real_mode_header’ has no member named ‘trampoline_pgd’
/home/build/git/efi/arch/x86/platform/efi/efi.c:867:2: error: implicit declaration of function ‘efi_sync_low_kernel_mappings’
[-Werror=implicit-function-declaration]

-- 
Matt Fleming, Intel Open Source Technology Center
