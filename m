Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab3LDWcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 17:32:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab3LDWcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 17:32:08 -0500
Message-ID: <1386196283.1861.115.camel@deneb.redhat.com>
Subject: Re: [PATCH v3 1/3] Documentation: arm: add UEFI support
 documentation
From: Mark Salter <msalter@redhat.com>
To: Matt Sealey <neko@bakuhatsu.net>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, matt.fleming@intel.com,
        Grant Likely <grant.likely@linaro.org>,
        Roy Franz <roy.franz@linaro.org>, Patch Tracking <patches@linaro.org>,
        linaro-uefi@lists.linaro.org, Mark Rutland <mark.rutland@arm.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Date: Wed, 04 Dec 2013 17:31:23 -0500
In-Reply-To: <CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg@mail.gmail.com>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
	 <1385656883-4420-2-git-send-email-leif.lindholm@linaro.org>
	 <CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com>
	 <20131202210719.GQ24997@rocoto.smurfnet.nu>
	 <CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 15:06 -0600, Matt Sealey wrote:
> On Mon, Dec 2, 2013 at 3:07 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> > On Mon, Dec 02, 2013 at 01:51:22PM -0600, Matt Sealey wrote:
> >> Here's where I think this whole thing falls down as being the weirdest
> >> possible implementation of this. It defies logic to put this
> >> information in the device tree /chosen node while also attempting to
> >> boot the kernel using an EFI stub; the stub is going to have this
> >> information because it is going to have the pointer to the system
> >> System Table (since it was called by StartImage()). Why not stash the
> >> System Table pointer somewhere safe in the stub?
> >
> > We do. In the DT.
> 
> Hang on... see way below about "reinventing the wheel"
> 
> >> The information in the device tree is all accessible from Boot
> >> Services and as long as the System Table isn't being thrown away (my
> >> suggestion would be.. stuff it in r2, and set r1 = "EFI\0" then work
> >> with arch/arm/kernel/head{-common,}.S code to do the right thing)
> >
> > You left out the bit of redefining the kernel boot protocol to permit
> > calling it with caches, MMU and interrupts enabled - also known as
> > before ExitBootServices().
> 
> And that's a horrible idea because of what?

Talk about reinventing the wheel.

I look at it like this. UEFI applications have a specific boot protocol.
The kernel has a different boot protocol. The purpose of the stub is to
go from the UEFI protocol to the kernel protocol. The kernel protocol
doesn't currently include an explicit way to pass UEFI info (system table
and memory map). It does have a way to pass a DT. Much like x86 and ia64
pass the UEFI info in an already existing boot_params block, arm and arm64
pass that info in the device tree. Not changing the kernel boot protocol
seems like the simplest and best way to get the job done. Maybe x86 and
now arm are going about the wrong way and should be doing it differently,
but so far, I'm not convinced that is the case.

--Mark


