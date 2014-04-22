Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbaDVK7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:59:49 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65411 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755457AbaDVK7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:59:45 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 1/4] ACPICA: Add <acpi/platform/aclinuxxf.h> to remove mis-ordered inclusion of <acpi/actypes.h> from <acpi/platform/aclinux.h>.
Date: Tue, 22 Apr 2014 13:16:02 +0200
Message-ID: <1465848.IEpXGNryLP@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E8802556F33@SHSMSX101.ccr.corp.intel.com>
References: <cover.1385110130.git.lv.zheng@intel.com> <3086544.JUcChlMM9C@vostro.rjw.lan> <1AE640813FDE7649BE1B193DEA596E8802556F33@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 22, 2014 02:01:57 AM Zheng, Lv wrote:
> Hi,
> 
> <skip>
> 
> > > +#define ACPI_NATIVE_INTERFACE_HEADER	<acpi/platform/aclinuxxf.h>
> > 
> > This is not good.
> > 
> > We don't do things like this in the kernel, because they are confusing and hard
> > to debug if necessary, so please find a different way to make this work.
> 
> I use this extra header file to collect:

I was not talking about the new header, which is basically OK, but about the
#define above, which is just too confusing to live.

Please use header file paths directly with #include.

> 1. static inline OSL functions
> 2. divergences of prototypes that haven't been back ported to ACPICA.
> This file is useful for ACPICA release automation.
> 
> There are the following concerns that lead to the use of this solution:
> 1. for this extra header file itself
>     A. The new header file is OSPM specific, thus it needn't be upstreamed to ACPICA;
>     B. Since it needn't be upstreamed to ACPICA, ACPICA needn't determine the name of this extra header;
>     C. It has to be the last file included by <acpi/acpi.h>.
> 2. for the file that includes this extra header file
>     A. Currently there is no OSPM specific code in <acpi/acpi.h>.
> Thus I use a macro so that there is still no OSPM specific code in <acpi/acpi.h> and the name of the extra header can be determined by OSPM.
> 
> If you want another solution, is the following acceptable?
> 1. In <acpi/platform/aclinux.h>
>     #define ACPI_INCLUDE_EXTRA_NATIVE_HEADER	1
> 2. In <acpi/acpi.h> <- this is an ACPICA header file, 
>     #ifdef ACPI_INCLUDE_EXTRA_NATIVE_HEADER
>     #include <acpi/platform/acextra.h>
>     #endif
> Note that in this solution, the name of the extra header file will be determined by ACPICA.

I think I see what you're trying to do now.  And I see that this ACPI_NATIVE_INTERFACE_HEADER
thing is already there in the Linus' tree which is not good at all.

I probably would create an extra ACPICA header, something like <acpios_opt.h>,
that would be empty for all hosts except for Linux and that would contain the
stuff you want to put into acextra.h in Linux.

That would be clean enough I suppose?

Rafael

