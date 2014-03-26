Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaCZJAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 05:00:06 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34150 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953AbaCZI77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 04:59:59 -0400
Date: Wed, 26 Mar 2014 08:59:53 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, leif.lindholm@linaro.org, hpa@zytor.com,
        bp@alien8.de, alan@lxorguk.ukuu.org.uk, mjg59@srcf.ucam.org
Subject: Re: [PATCH] Add efi_early_call() macro
Message-ID: <20140326085953.GA2958@console-pimps.org>
References: <20140322110515.GF2815@console-pimps.org>
 <1395787231-14298-1-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395787231-14298-1-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar, at 03:40:30PM, Roy Franz wrote:
> Add the efi_early_call() macro to invoke functions in the efi_early
> structure. Using a macro for these invocations allows the arm32/arm64
> architectures to define the macro differently so that they can directly
> invoke the boot services functions that are exposed in the efi_early
> structure on x86. Prior to the introduction of the efi_early structure
> the efi_call_physN macros were used on all architectures and allowed
> for this differentiation.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  arch/x86/boot/compressed/eboot.c       |    5 +++++
>  drivers/firmware/efi/efi-stub-helper.c |   26 +++++++++++++-------------
>  2 files changed, 18 insertions(+), 13 deletions(-)

Confused.

Why have you rewritten the patch that I sent Satuday morning?

  https://lkml.org/lkml/2014/3/22/61

I don't think your version goes far enough because you've left all the
efi_early->call() stuff in eboot.c. So now there's two ways to invoke
EFI functions in the x86 boot stub.

What's wrong with the patch that I sent?

-- 
Matt Fleming, Intel Open Source Technology Center
