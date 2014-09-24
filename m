Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaIXH0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:26:39 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:58450 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIXH0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:26:38 -0400
Date: Wed, 24 Sep 2014 09:26:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Roy Franz <roy.franz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20140924072633.GA1768@gmail.com>
References: <20140919104021.GA11552@gmail.com>
 <CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
 <20140923053510.GB27825@gmail.com>
 <20140923053711.GA28704@gmail.com>
 <20140923055802.GA29052@gmail.com>
 <1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com>
 <CAKv+Gu_xqnkVKuoWY=PRoAVYE_qOH8dwM+ZxG+ysC7Xvs82ZNw@mail.gmail.com>
 <20140923131805.GH18635@console-pimps.org>
 <542182E0.6090101@canonical.com>
 <20140923143712.GI18635@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923143712.GI18635@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> @@ -1394,10 +1394,7 @@ struct boot_params *efi_main(struct efi_config *c,
>  
>  	setup_graphics(boot_params);
>  
> -	status = setup_efi_pci(boot_params);
> -	if (status != EFI_SUCCESS) {
> -		efi_printk(sys_table, "setup_efi_pci() failed!\n");
> -	}
> +	setup_efi_pci(boot_params);
>  
>  	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
>  				sizeof(*gdt), (void **)&gdt);


So 'status' is unused - either use it for a less threatening 
message, or remove the return code from the function and document 
that failure is an option?

Thanks,

	Ingo
