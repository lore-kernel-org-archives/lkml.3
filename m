Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207AbaJPDBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:01:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:43687 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaJPDBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:01:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,729,1406617200"; 
   d="scan'208";a="619595793"
Message-ID: <543F34D3.2040004@linux.intel.com>
Date: Thu, 16 Oct 2014 11:00:35 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Felipe Balbi <balbi@ti.com>, x86@kernel.org
Subject: Re: [Patch v2] x86: Make Atom PMC driver configurable.
References: <20141015144603.GA19944@redhat.com> <20141015145245.GB11511@saruman> <20141015145924.GA21199@redhat.com> <20141015172030.6bb3c522@alan.etchedpixels.co.uk> <20141016021859.GA12042@redhat.com>
In-Reply-To: <20141016021859.GA12042@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/16 10:18, Dave Jones wrote:
> The Atom PMC driver is always built-in, regardless of whether
> the kernel being built is going to be run on an Atom (or even Intel) CPU.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
> Cc: aubrey.li@linux.intel.com
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f2327e88e07c..b4dfd96aeea8 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2485,7 +2485,8 @@ config X86_DMA_REMAP
>  	depends on STA2X11
>  
>  config PMC_ATOM
> -	def_bool y
> +	tristate "Intel Atom SOC power management controller driver"

PMC driver provides core function like reboot, better to change to
bool, or did you see a scenario it can be as a module?

Thanks,
-Aubrey

> +	default y
>          depends on PCI
>  
>  source "net/Kconfig"
> 
> 

