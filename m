Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529AbaJVW3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 18:29:42 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:64410 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933487AbaJVW3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 18:29:39 -0400
Date: Wed, 22 Oct 2014 23:29:36 +0100
From: James Hogan <james.hogan@imgtec.com>
To: John Crispin <blogic@openwrt.org>
CC: <eunb.song@samsung.com>, "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mips: add arch_trigger_all_cpu_backtrace() function
Message-ID: <20141022222936.GE12296@jhogan-linux.le.imgtec.org>
References: <1061520101.169091413960858532.JavaMail.weblogic@epmlwas02b>
 <544758AB.3060100@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <544758AB.3060100@openwrt.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Wed, Oct 22, 2014 at 09:11:39AM +0200, John Crispin wrote:
> On 22/10/2014 08:54, Eunbong Song wrote:
> >>> +void arch_trigger_all_cpu_backtrace(bool); +#define
> >>> arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
> > 
> >> What is the purpose of this define ? is this maybe a leftover from
> >> some regex/cleanups ?
> > 
> > Hi John.
> > Actually, I just follow the same function of sparc architecture.
> > You can find this in arch/sparc/include/asm/irq_64.h as below
> > 
> > void arch_trigger_all_cpu_backtrace(bool);
> > #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
> > 
> > I guess this is used for conditional compile. 
> > See below.
> > include/linux/nmi.h
> > #ifdef arch_trigger_all_cpu_backtrace
> > static inline bool trigger_all_cpu_backtrace(void)
> > {
> >         arch_trigger_all_cpu_backtrace(true);
> > 
> >         return true;
> > }
> > static inline bool trigger_allbutself_cpu_backtrace(void)
> > {
> >         arch_trigger_all_cpu_backtrace(false);
> >         return true;
> > }
> > #else
> > static inline bool trigger_all_cpu_backtrace(void)
> > {
> >         return false;
> > }
> > static inline bool trigger_allbutself_cpu_backtrace(void)
> > {
> >         return false;
> > }
> > #endif
> > 
> > Thanks. 
> >> John
> > 
> 
> i don't see how this is required for conditional compiles. the code
> define a->a which is bogus i think.

It's a pretty common pattern in the asm headers, in order to allow
generic code to use the preprocessor to see whether it was defined or
not.

Cheers
James
