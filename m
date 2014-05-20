Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaETUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:09:59 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:62238 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaETUJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:09:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: remove ARM710 specific assembler code
Date: Tue, 20 May 2014 22:09:48 +0200
Message-ID: <4437236.32BrGIk46D@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140520160512.GE27830@atomide.com>
References: <1364507176.1345.45.camel@x61.thuisdomein> <5053472.zFAHKQVpbv@wuerfel> <20140520160512.GE27830@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wAdaEGixmIOjwnMh8IAh9ZSQvqhHCErhDh5xrKdymIS
 KjoCXW7jGbziHaGHxI2Glsn7+sA9twoeIc/S/ol0AE2/dsdgUl
 Q1Bx2x2V3rx8Cg2DXg2P4PvVDeHd0EbW2lUAhoPOPWUoz4c2pS
 3fzveZn4euoyz+AQRMflnJANeZKLBXaWEETRG10BVSlMHDMQfl
 h0AF1gCZ4UBhzNuWCcu9p0EdxxYu8TBH+d+nUcbJCTZQBs+OPi
 H7PMnptEBdFusYGZprWB+5RtC4L0MQ2IrUJeySN1l0f0QoxyoH
 iooqLzl9KSFCCUyNW5NpfNJG8yFWZtj5CmA7P5CIbLzA5qugks
 L7ebJtl/94RvCUWWhSYM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2014 09:05:13 Tony Lindgren wrote:
> * Arnd Bergmann <arnd@arndb.de> [140519 04:27]:
> > On Saturday 17 May 2014 10:56:02 Catalin Marinas wrote:
> > 
> > For the case of ARM710T, I think the last remaining user that can be
> > configured is mach-integrator, but I don't know if anybody even has that
> > CPU tile, or wants to keep using it. If Russell and Linus as the only
> > people that have cared about Integrator in the past years want to
> > cut down the number of supported CPUs, that would be a different matter:
> > quite a number of CPUs are not supported in any other platform.
> > Note that the integrator target in qemu does not support any ARM7, only
> > StrongARM, ARM9 or later. I also double-checked about mach-clps711x,
> > but I'm pretty sure those SoCs are all either ARM710a (no longer supported)
> > or ARM720T (quite active).
> 
> Hmm I don't think mach-integrator is using ARM710T?

I don't know, we don't have a separate Kconfig option, so ARM710T and ARM720T
use the same CONFIG_CPU_ARM720T symbol that can be enabled for integrator.
Without any further information, I assumed that both might potentially be used.

> The ARM710T was done by NEC and was used by the Psion MX hardware.
> It's very close to ARM720T as far as I remember so might as well keep
> the CPU support for it as that's just a few lines of code in the
> mainline kernel.
> 
> I don't think we have any mach directories using ARM710T, but I
> would not be surprised if somebody comes along with device tree
> based booting patches for Psion MX at some point.

Of course, if someone does this, the CPU support would be the least
of their work ;-)

Just out of curiosity: was that NEC 710T a SoC that replaced the
CL/PS7110, or a standalone CPU that Psion combined with a custom
ASIC?

	Arnd
