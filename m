Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbaBDT1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:27:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56607 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBDT1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:27:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH 09/10] watchdog: xilinx: Add missing binding
Date: Tue, 4 Feb 2014 20:27:15 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-doc@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <3121595.GbLMuGPlvA@wuerfel> <4c4539fe-e810-4c0a-9a01-c1e4c67ea661@AM1EHSMHS007.ehs.local>
In-Reply-To: <4c4539fe-e810-4c0a-9a01-c1e4c67ea661@AM1EHSMHS007.ehs.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402042027.15898.arnd@arndb.de>
X-Provags-ID: V02:K0:WEt0hmQRc/9xiwOlns99eMV8SpuCA6l3RftCL/jg+af
 Rage8ao6AEz3Fw6iScwaJ4D4G/Ra4ex4r42vDzqgowNFTFrknh
 vO/z1snmaQ/503vhpy8gOps6754ConeITA3fGcvmPmTXN9/7UZ
 /SXkawFOY3mw/cMLYfYZhc0k9bFbqcmcVZbHNFtYpHLq30spUe
 Uhp60JHuCPKVI5OitJlpjucRUO7khK2+QdOh5G4KMtT8y1EDWt
 HQy51ITfrNH2PEXED1qUVSkFiuS/tA9Y0yYGjJBXQa21v5K3eM
 dz3d67jyUd1mPeJy756rL6zSAhuN79THwQwmNiIjjHNDPtMuky
 RO0wFZuRnFJkp2+0HrYFb0FHNnw+Nihep8yzP148u
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 February 2014, Michal Simek wrote:
> On 02/03/2014 04:32 PM, Arnd Bergmann wrote:
> > On Monday 03 February 2014 16:13:47 Michal Simek wrote:
> >> Intention wasn't to fix binding but document current one
> >> which is in mainline for a long time.
> > 
> > Ok, I see.
> > 
> >> Apart of this - yes, wdt-enable-once is nowayout and wdt-interval should be timeout
> >> is seconds, and clock-frequency should go out and use CCF for getting clock.
> > 
> > Could we make a common binding then, and document that the xilinx
> > watchdog can optionally provide either one?
> 
> Do you mean to have 2 DT bindings?
> 
> This binding is used from 2011-07.
> It means it was generated for all hw designs at least from this time.
> I would say from DT usage on Microblaze because it is not special case
> in our dt generator.

I certainly wasn't suggesting to break the binding, quite the contrary.
What I tried to say is that the properties look like they should be
useful for different kinds of watchdogs, not just xilinx, so it would
be good to have a common definition using generic strings.

The xilinx driver would definitely have to keep supporting the traditional
property names, but it could also support the generic names in the
future.

> xlnx,XXX are XXX parameters which you have to setup in tools
> and get synthesized. This is valid for all xilinx IPs. We have full
> IP description by generating xlnx,XXX parameters directly from tools
> because we know all variants which can happen.
>
> Just back to your previous post:
> "I'm not sure about the enable-once flag, which seems to just map to the
> "nowayout" watchdog option that is not a hardware feature at all"
> this is hw feature which you can select in tools because this is fpga. :-)

Ah, so you mean the properties are not settings that the driver
programs into the hardware, but they are hardware properties that the
driver reports to user space?

	Arnd
