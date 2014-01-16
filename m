Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaAPCNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:13:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbaAPCNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:13:43 -0500
Message-ID: <1389838384.1923.41.camel@deneb.redhat.com>
Subject: Re: [PATCH v3 4/6] arm: add early_ioremap support
From: Mark Salter <msalter@redhat.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 15 Jan 2014 21:13:04 -0500
In-Reply-To: <52D72883.3020500@codeaurora.org>
References: <1389325833-16535-1-git-send-email-msalter@redhat.com>
	 <1389325833-16535-5-git-send-email-msalter@redhat.com>
	 <52D72883.3020500@codeaurora.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-15 at 16:32 -0800, Laura Abbott wrote:
> On 1/9/2014 7:50 PM, Mark Salter wrote:
> ....
> > diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> > index 987a7f5..038fb75 100644
> > --- a/arch/arm/kernel/setup.c
> > +++ b/arch/arm/kernel/setup.c
> > @@ -36,6 +36,7 @@
> >   #include <asm/cpu.h>
> >   #include <asm/cputype.h>
> >   #include <asm/elf.h>
> > +#include <asm/io.h>
> >   #include <asm/procinfo.h>
> >   #include <asm/psci.h>
> >   #include <asm/sections.h>
> > @@ -887,6 +888,8 @@ void __init setup_arch(char **cmdline_p)
> >
> >   	parse_early_param();
> >
> > +	early_ioremap_init();
> > +
> >   	sort(&meminfo.bank, meminfo.nr_banks, sizeof(meminfo.bank[0]), meminfo_cmp, NULL);
> >
> >   	early_paging_init(mdesc, lookup_processor_type(read_cpuid_id()));
> 
> Any chance we could do this even earlier, say right after 
> setup_processor? It would be nice to be able to do this while FDT 
> scanning (I have a use case in mind, potential patches are in the works)

It looks like that would work...


