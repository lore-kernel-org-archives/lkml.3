Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3DXPUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:20:09 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43609 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab3DXPUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:20:07 -0400
Message-ID: <5177F824.3080506@intel.com>
Date: Wed, 24 Apr 2013 16:20:04 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] efi: Check EFI revision in setup_efi_vars
References: <20130424143738.GB15272@hansolo.jdub.homelinux.org> <5177EFCE.80104@intel.com> <20130424145449.GC15272@hansolo.jdub.homelinux.org> <5177F2C3.5080907@intel.com> <1366815685.9976.0.camel@x230> <20130424151652.GD15272@hansolo.jdub.homelinux.org>
In-Reply-To: <20130424151652.GD15272@hansolo.jdub.homelinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/04/13 16:16, Josh Boyer wrote:
> We need to check the runtime sys_table for the EFI version the firmware
> specifies instead of just checking for a NULL QueryVariableInfo.  Older
> implementations of EFI don't have QueryVariableInfo but the runtime is
> a smaller structure, so the pointer to it may be pointing off into garbage.
> 
> This is apparently the case with several Apple firmwares that support EFI
> 1.10, and the current check causes them to no longer boot.  Fix based on
> a suggestion from Matthew Garrett.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> ---
>  v2: Drop the unnecessary NULL check
> 
>  arch/x86/boot/compressed/eboot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, applied.
