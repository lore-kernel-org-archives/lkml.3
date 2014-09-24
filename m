Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaIXNIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:08:23 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50450 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaIXNIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:08:22 -0400
Date: Wed, 24 Sep 2014 15:08:16 +0200
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
Message-ID: <20140924130816.GB3277@gmail.com>
References: <20140923053510.GB27825@gmail.com>
 <20140923053711.GA28704@gmail.com>
 <20140923055802.GA29052@gmail.com>
 <1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com>
 <CAKv+Gu_xqnkVKuoWY=PRoAVYE_qOH8dwM+ZxG+ysC7Xvs82ZNw@mail.gmail.com>
 <20140923131805.GH18635@console-pimps.org>
 <542182E0.6090101@canonical.com>
 <20140923143712.GI18635@console-pimps.org>
 <20140924072633.GA1768@gmail.com>
 <20140924114236.GM18635@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924114236.GM18635@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> +/*
> + * There's no way to return an informative status from this function,
> + * because any analysis (and printing of error messages) needs to be
> + * done directly at the EFI function call-site.
> + *
> + * For example, EFI_INVALID_PARAMETER could indicate a bug or maybe we
> + * just didn't find any PCI devices, but there's no way to tell outside
> + * the context of the call.
> + */
> +static void setup_efi_pci(struct boot_params *params)

Btw., do we print proper complaints at the EFI call sites if such 
failures do happen (and if that failure is unexpected/bad)?

If that's a given then your patch looks good to me.

Thanks,

	Ingo
