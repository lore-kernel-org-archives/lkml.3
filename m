Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab3DZVsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 17:48:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43675 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149Ab3DZVsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 17:48:06 -0400
Message-ID: <517AF5F2.50404@zytor.com>
Date: Fri, 26 Apr 2013 14:47:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 3/6] x86: kaslr: return location from decompress_kernel
References: <1367003005-5560-1-git-send-email-keescook@chromium.org> <1367003005-5560-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1367003005-5560-4-git-send-email-keescook@chromium.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2013 12:03 PM, Kees Cook wrote:
> This allows decompress_kernel to return a new location for the kernel to
> be relocated to. With CONFIG_RANDOMIZE_BASE, the choose_kernel_location
> routine will select a new location to decompress the kernel, and is
> presently a no-op. The logic for bypassing this routine with "noaslr"
> on the kernel command line is handled.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Documentation/kernel-parameters.txt |    4 ++++
>  arch/x86/boot/compressed/Makefile   |    2 +-
>  arch/x86/boot/compressed/aslr.c     |   21 +++++++++++++++++++++
>  arch/x86/boot/compressed/cmdline.c  |    2 +-
>  arch/x86/boot/compressed/head_32.S  |    2 +-
>  arch/x86/boot/compressed/head_64.S  |    2 +-
>  arch/x86/boot/compressed/misc.c     |    7 +++++--
>  arch/x86/boot/compressed/misc.h     |   22 ++++++++++++++++------
>  8 files changed, 50 insertions(+), 12 deletions(-)
>  create mode 100644 arch/x86/boot/compressed/aslr.c
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 8ccbf27..eb1c62c 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1862,6 +1862,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	noapic		[SMP,APIC] Tells the kernel to not make use of any
>  			IOAPICs that may be present in the system.
>  
> +	noaslr		[X86]
> +			Disable kernel base offset ASLR (Address Space
> +			Layout Randomization) if built into the kernel.
> +
>  	noautogroup	Disable scheduler automatic task group creation.
>  
>  	nobats		[PPC] Do not use BATs for mapping kernel lowmem

Calling it "nokaslr" might be useful to note that it is specifically
about the kernel.

	-hpa


