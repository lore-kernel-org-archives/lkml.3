Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbaGVXX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 19:23:56 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62075 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932171AbaGVXXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 19:23:54 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v3 2/7] ACPICA: Linux: Add stub implementation of ACPICA 64-bit mathematics.
Date: Wed, 23 Jul 2014 01:42:18 +0200
Message-ID: <1733924.BlDCbaVj8l@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E8802643932@SHSMSX101.ccr.corp.intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com> <3777197.HSR7Q9huIS@vostro.rjw.lan> <1AE640813FDE7649BE1B193DEA596E8802643932@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 21, 2014 01:26:10 AM Zheng, Lv wrote:
> Hi, Rafael
> 
> > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > Sent: Sunday, July 20, 2014 7:46 AM
> > To: Zheng, Lv
> > 
> > On Wednesday, July 16, 2014 04:58:00 PM Lv Zheng wrote:
> > > This patch adds default 64-bit mathematics in aclinux.h using do_div(). As
> > > do_div() can be used for all Linux architectures, this can also be used as
> > > stub macros for ACPICA 64-bit mathematics.
> > >
> > > But this is not a performance friendly way, as ACPICA's architecture
> > > specific division OSL only requires a dividing 64-bit number with a 32-bit
> > > number implementation, while Linux __div64_32() is not available for all
> > > build environments. So currently, if an architecture really wants to
> > > support ACPICA, it must implement its own division OSL.
> > 
> > What does this mean for i386, in particular?
> 
> All ACPICA environment macros have defaults in actypes.h or acenv.h, these macros are the only ones do not have defaults.
> Because their defaults should be provided by OSPMs.
> This patch just adds their default implementation for __KERNEL__ surrounded code for Linux kernel.
> It only provides build protection and demonstrations of the functionality, no one actually uses it now.
> 
> Let me figure out the possible users below:
> 
> These macros are required by drivers/acpi/utmath.c when ACPI_USE_NATIVE_DIVIDE is not defined.
> It is used by ACPICA, so currently this is only meaningful to CONFIG_ACPI builds.
> So kernel will not use these macros unless CONFIG_ACPI is defined and ACPI_USE_DIVIDE is not defined.
> 
> For 64-bit kernels: 
> In include/acpi/actypes.h, for ACPI_MACHINE_WIDTH=64, ACPI_USE_NATIVE_DIVIDE will be defined, thus these macros are not used.
> In include/acpi/platform/aclinux.h, for __KERNEL__ surrounded code, ACPI_MACHINE_WIDTH is defined to be BITS_PER_LONG.
> So all 64-bit kernels do not use these macros.
> 
> For 32-bit kernels:
> As mentioned above, these macros will be used when BITS_PER_LONG is 32.
> Thus currently the i328 kernels are the only users for these macros.
> But they won't use this default implementation provided by this patch because:
> In arch/x86/include/asm/acenv.h, there are already overrides implemented.
> So these default macros are not used by 32-bit x86 (i386) kernels.
> 
> These macros will only be used by future non x86 32-bit architectures that try to support ACPI in Linux kernel.
> During the period they do not have arch specific implementations of such macros, we can avoid build errors for them.
> And since they can see ACPICA functioning without implementing any arch specific environment tunings, we  can also avoid function errors for them.
> As this implementation is not performance friendly, those architectures still need to implement real support in the end.
> 
> As a conclusion, IMO:
> 1. This default implementation just fill an ACPICA default environment gap.
> 1. There are no users and will be no users of this default implementation in the kernel.
> 3. Though this default implementation is not performance friendly, it functions correctly, so it can be a demo for future 32-bit architectures that try to support ACPI.
> 4. We can use this default implementation to avoid build troubles.

Good analysis, thanks!

I copied the most useful part of it to the changelog of this patch and queued
up the whole series for 3.17.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
