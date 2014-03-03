Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaCCHHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:07:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:9222 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaCCHHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:07:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,576,1389772800"; 
   d="scan'208";a="492679098"
Message-ID: <53142A31.2010209@linux.intel.com>
Date: Mon, 03 Mar 2014 15:07:29 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "David E. Box" <david.e.box@linux.intel.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 2/2] x86: IOSF: Change IOSF_MBI Kconfig to default
 y
References: <1393641652-7222-1-git-send-email-david.e.box@linux.intel.com> <1393641652-7222-3-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1393641652-7222-3-git-send-email-david.e.box@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/1 10:40, David E. Box wrote:
> From: "David E. Box" <david.e.box@linux.intel.com>
> 
> Make the IOSF Mailbox driver built in as it provides core functionality needed
> for new Intel SOC platforms to access the device registers on the SOC.
> 
> Signed-off-by: David E. Box <david.e.box@linux.intel.com>
> ---
>  arch/x86/Kconfig |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d3b1f8b..e34b252 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2385,12 +2385,9 @@ config X86_DMA_REMAP
>  	depends on STA2X11
>  
>  config IOSF_MBI
> -	bool
> +	bool "Intel IOSF Mailbox Driver support"

One concern here is, IOSF is not architectural for all of X86, can we
change this as "Intel Atom IOSF Mailbox Driver support"? Or if you can
confirm we'll use IOSF in the future onchip product, can we change this
as "Intel SOC IOSF Mailbox Driver support"?

Better to rename the file name as well.

Thanks,
-Aubrey
> +	default y
>  	depends on PCI
> -	---help---
> -	  To be selected by modules requiring access to the Intel OnChip System
> -	  Fabric (IOSF) Sideband MailBox Interface (MBI). For MBI platforms
> -	  enumerable by PCI.
>  
>  source "net/Kconfig"
>  
> 

