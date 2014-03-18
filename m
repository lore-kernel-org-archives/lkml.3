Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaCRMex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:34:53 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:39932 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754178AbaCRMew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:34:52 -0400
Date: Tue, 18 Mar 2014 12:34:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>
Subject: Re: [PATCH v2 13/15] arm64: add EFI runtime services
Message-ID: <20140318123418.GH13200@arm.com>
References: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
 <1394750828-16351-14-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394750828-16351-14-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 10:47:06PM +0000, Leif Lindholm wrote:
> --- /dev/null
> +++ b/arch/arm64/kernel/efi.c
[...]
> +/*
> + * Called from setup_arch with interrupts disabled.
> + */
> +void __init efi_enter_virtual_mode(void)
[...]
> --- a/init/main.c
> +++ b/init/main.c
> @@ -902,6 +902,10 @@ static noinline void __init kernel_init_freeable(void)
>         smp_prepare_cpus(setup_max_cpus);
> 
>         do_pre_smp_initcalls();
> +
> +       if (IS_ENABLED(CONFIG_ARM64) && efi_enabled(EFI_BOOT))
> +               efi_enter_virtual_mode();

The comment for the efi_enter_virtual_mode() function says "called from
setup_arch with interrupts disabled". None of these are true for the
call above (and I would really prefer an arch call than this arm64
conditional call in init/main.c.

-- 
Catalin
