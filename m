Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3FFNOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:14:44 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41353 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910Ab3FFNOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:14:43 -0400
Date: Thu, 6 Jun 2013 14:14:39 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 4/4] x86, efi: Map runtime services 1:1
Message-ID: <20130606131439.GI30420@console-pimps.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-5-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370177770-26661-5-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Jun, at 02:56:10PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Due to the braindead design of EFI, we cannot map runtime services more
> than once for the duration of a booted system. Thus, if we want to use
> EFI runtime services in a kexec'ed kernel, maybe the only possible and
> sensible approach would be to map them 1:1 so that when the kexec kernel
> loads, it can simply call those addresses without the need for remapping
> (which doesn't work anyway).
> 
> Furthermore, this mapping approach could be of help with b0rked EFI
> implementations for a different set of reasons.
> 
> This implementation is 64-bit only for now and it boots fine in kvm with
> OVMF BIOS.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/include/asm/efi.h          |   2 +
>  arch/x86/platform/efi/efi.c         | 161 +++++++++++++++++++++++++++++-------
>  arch/x86/platform/efi/efi_stub_64.S |  48 +++++++++++
>  3 files changed, 180 insertions(+), 31 deletions(-)
 
This patch makes my TunnelMountain machine spin in handle_pte_fault()
when triggering one of the "firmware makes references to physical
addresses" code paths.

I'll try and dig into this tomorrow to figure out what's going on.

-- 
Matt Fleming, Intel Open Source Technology Center
