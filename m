Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaEVSmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:42:46 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22479 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaEVSmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:42:46 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19LCHGFPgMxD2NNdBGIWQGb
Date: Thu, 22 May 2014 11:42:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: remove ARM710 specific assembler code
Message-ID: <20140522184232.GC29577@atomide.com>
References: <1364507176.1345.45.camel@x61.thuisdomein>
 <5053472.zFAHKQVpbv@wuerfel>
 <20140520160512.GE27830@atomide.com>
 <4437236.32BrGIk46D@wuerfel>
 <20140522184005.GB29577@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522184005.GB29577@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [140522 11:41]:
> * Arnd Bergmann <arnd@arndb.de> [140520 13:10]:
> > On Tuesday 20 May 2014 09:05:13 Tony Lindgren wrote:
> > > * Arnd Bergmann <arnd@arndb.de> [140519 04:27]:
> > > > On Saturday 17 May 2014 10:56:02 Catalin Marinas wrote:
> > > > 
> > > > For the case of ARM710T, I think the last remaining user that can be
> > > > configured is mach-integrator, but I don't know if anybody even has that
> > > > CPU tile, or wants to keep using it. If Russell and Linus as the only
> > > > people that have cared about Integrator in the past years want to
> > > > cut down the number of supported CPUs, that would be a different matter:
> > > > quite a number of CPUs are not supported in any other platform.
> > > > Note that the integrator target in qemu does not support any ARM7, only
> > > > StrongARM, ARM9 or later. I also double-checked about mach-clps711x,
> > > > but I'm pretty sure those SoCs are all either ARM710a (no longer supported)
> > > > or ARM720T (quite active).
> > > 
> > > Hmm I don't think mach-integrator is using ARM710T?
> > 
> > I don't know, we don't have a separate Kconfig option, so ARM710T and ARM720T
> > use the same CONFIG_CPU_ARM720T symbol that can be enabled for integrator.
> > Without any further information, I assumed that both might potentially be used.
> > 
> > > The ARM710T was done by NEC and was used by the Psion MX hardware.
> > > It's very close to ARM720T as far as I remember so might as well keep
> > > the CPU support for it as that's just a few lines of code in the
> > > mainline kernel.
> > > 
> > > I don't think we have any mach directories using ARM710T, but I
> > > would not be surprised if somebody comes along with device tree
> > > based booting patches for Psion MX at some point.
> > 
> > Of course, if someone does this, the CPU support would be the least
> > of their work ;-)
> 
> Right :)
>  
> > Just out of curiosity: was that NEC 710T a SoC that replaced the
> > CL/PS7110, or a standalone CPU that Psion combined with a custom
> > ASIC?
> 
> I think 710T was a pin compatible clone of CL/PS7110 by NEC. The
> device registers were different both from CL/PS7110 and 720T for
> most part.

Oh and that also means that mach-integrator probably never used 710T
as we only have the 720T SoC registers in the mainline. From CPU
point of view 710T and 720T can be considered the same for most
part like we do.

Regards,

Tony
