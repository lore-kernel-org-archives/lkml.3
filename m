Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaCRORZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:17:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbaCRORX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:17:23 -0400
Message-ID: <1395152209.2967.3.camel@deneb.redhat.com>
Subject: Re: [PATCH v2 13/15] arm64: add EFI runtime services
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>
Date: Tue, 18 Mar 2014 10:16:49 -0400
In-Reply-To: <20140318123418.GH13200@arm.com>
References: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
	 <1394750828-16351-14-git-send-email-leif.lindholm@linaro.org>
	 <20140318123418.GH13200@arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 12:34 +0000, Catalin Marinas wrote:
> On Thu, Mar 13, 2014 at 10:47:06PM +0000, Leif Lindholm wrote:
> > --- /dev/null
> > +++ b/arch/arm64/kernel/efi.c
> [...]
> > +/*
> > + * Called from setup_arch with interrupts disabled.
> > + */
> > +void __init efi_enter_virtual_mode(void)
> [...]
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -902,6 +902,10 @@ static noinline void __init kernel_init_freeable(void)
> >         smp_prepare_cpus(setup_max_cpus);
> > 
> >         do_pre_smp_initcalls();
> > +
> > +       if (IS_ENABLED(CONFIG_ARM64) && efi_enabled(EFI_BOOT))
> > +               efi_enter_virtual_mode();
> 
> The comment for the efi_enter_virtual_mode() function says "called from
> setup_arch with interrupts disabled". None of these are true for the
> call above (and I would really prefer an arch call than this arm64
> conditional call in init/main.c.
> 

Right, the call changed to later in boot but the comment didn't. Calling
from setup_arch is too early. But an early_initcall would work and would
get rid of the ugly CONFIG_ARM64 test.



