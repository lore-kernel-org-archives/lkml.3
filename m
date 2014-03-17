Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaCQWjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:39:42 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:33588 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbaCQWjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:39:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140317204410.GA1118@arch.cereza>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
	<1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
	<20140316070917.GA3094@arch.cereza>
	<CADHgK6s58EJyJxB-47K8w26H8ZCBFQ2zu7PGAQU9O+2g7=fPwA@mail.gmail.com>
	<20140317204410.GA1118@arch.cereza>
Date: Mon, 17 Mar 2014 15:39:39 -0700
Message-ID: <CADHgK6tHngKVZS=jo=VYt3Nt3dhiEmiWr28iDy7q_uR9goBj=Q@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
From: Sebastian Capella <sebastian.capella@linaro.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Laura Abbott <lauraa@codeaurora.org>, Sricharan R <r.sricharan@ti.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Russ Dill <Russ.Dill@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 March 2014 13:44, Ezequiel Garcia
<ezequiel.garcia@free-electrons.com> wrote:
> On Mar 17, Sebastian Capella wrote:
>> On 16 March 2014 00:09, Ezequiel Garcia
>> <ezequiel.garcia@free-electrons.com> wrote:
>> > On Mar 05, Sebastian Capella wrote:
>> > [..]
>> >> diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
>> >> index 1f8fed9..83707702 100644
>> >> --- a/arch/arm/mm/Kconfig
>> >> +++ b/arch/arm/mm/Kconfig
>> >> @@ -611,6 +611,11 @@ config CPU_USE_DOMAINS
>> >>  config IO_36
>> >>       bool
>> >>
>> >> +config ARCH_HIBERNATION_POSSIBLE
...
>> > Is there any reason why CPU_FEROCEON is not listed here? FWIW, I've just built
>> > (but not really tested) a Kirkwood kernel with CONFIG_HIBERNATION=y.
...
> Sure, no problem. If you consider that build-test is enough, feel free to put
> CPU_FEROCEON on that list. We added suspend/resume to feroceon not long ago.
>> > And is there any reason to put this config in arch/arm/mm/Kconfig, instead of
>> > in arch/arm/Kconfig, below ARCH_SUSPEND_POSSIBLE?
...
> I guess my question wasn't clear. I mean to ask: Are there any other
> requirements on an ARM platform to support hibernation, other than
> suspend/resume support?
>
> If this is the *only* requirement, it seems to me we could make our
> ARCH_SUSPEND_POSSIBLE also select ARCH_HIBERNATION_POSSIBLE.

Thanks, I've added it like this in arch/arm/Kconfig.  I'm sure you
know, but this way also takes care of the CPU_FEROCEON in the default
list since SUSPEND_POSSIBLE already contains it.

config ARCH_HIBERNATION_POSSIBLE
        bool
        depends on MMU
        default y if ARCH_SUSPEND_POSSIBLE

Does this look ok?

Thanks!

Sebastian
