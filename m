Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbbAVMbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:31:45 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30406 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbbAVMbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:31:42 -0500
Date: Thu, 22 Jan 2015 13:29:58 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Al Stone <al.stone@linaro.org>, Timur Tabi <timur@codeaurora.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "parth.dixit@linaro.org" <parth.dixit@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH v7 04/17] ARM64 / ACPI: Introduce early_param for "acpi"
 and pass acpi=force to enable ACPI
Message-ID: <20150122122958.GG3473@olila.local.net-space.pl>
References: <CAKv+Gu8vPKAdsNg7QC7xW+i8_BemWEx4mvBx6NrnAHi8Y+bNtw@mail.gmail.com>
 <20150119135144.GI11835@e104818-lin.cambridge.arm.com>
 <20150119151350.21B65C40948@trevor.secretlab.ca>
 <54BD3803.6020307@redhat.com>
 <20150119175233.GK11835@e104818-lin.cambridge.arm.com>
 <20150119180122.GJ21553@leverpostej>
 <54BE1FEA.5040109@linaro.org>
 <alpine.DEB.2.02.1501201901190.12653@kaball.uk.xensource.com>
 <20150121152326.GD6358@e104818-lin.cambridge.arm.com>
 <alpine.DEB.2.02.1501211558561.12653@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1501211558561.12653@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 04:10:00PM +0000, Stefano Stabellini wrote:
> On Wed, 21 Jan 2015, Catalin Marinas wrote:
> > On Tue, Jan 20, 2015 at 07:20:06PM +0000, Stefano Stabellini wrote:
> > > On Tue, 20 Jan 2015, Hanjun Guo wrote:
> > > > How about the patch (just RFC, maybe it is horrible :) ) below:
> > > >
> > > > When system supporting both DT and ACPI but firmware providing
> > > > no dtb, we can use this linux,uefi-stub-generated-dtb property
> > > > to let kernel know that we can try ACPI configuration data.
> > > >
> > > > Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> > > > ---
> > > >  Documentation/devicetree/bindings/chosen.txt | 19 ++++++++++++++++
> > > >  arch/arm64/kernel/setup.c                    | 34
> > > > +++++++++++++++++++++++++++-
> > > >  drivers/firmware/efi/libstub/fdt.c           |  6 +++++
> > > >  3 files changed, 58 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/chosen.txt
> > > > b/Documentation/devicetree/bindings/chosen.txt
> > > > index ed838f4..18776b9 100644
> > > > --- a/Documentation/devicetree/bindings/chosen.txt
> > > > +++ b/Documentation/devicetree/bindings/chosen.txt
> > > > @@ -44,3 +44,22 @@ Implementation note: Linux will look for the property
> > > > "linux,stdout-path" or
> > > >  on PowerPC "stdout" if "stdout-path" is not found.  However, the
> > > >  "linux,stdout-path" and "stdout" properties are deprecated. New platforms
> > > >  should only use the "stdout-path" property.
> > > > +
> > > > +
> > > > +linux,uefi-stub-generated-dtb property
> > > > +--------------------------------------
> > > > +
> > > > +UEFI stub will generate this property in the chosen node to let linux kernel
> > > > +know that there is no DTB provided by firmware.
> > > > +
> > > > +There is a use case for system supporting both DT and ACPI, when firmware
> > > > +doesn't provide DT, we can try ACPI configration data to boot the system.
> > > > +
> > > > +Usage:
> > > > +
> > > > +linux,uefi-stub-generated-dtb = "true" means that it is true that the dtb
> > > > +is generated by uefi stub
> > > > +
> > > > +or
> > > > +
> > > > +linux,uefi-stub-generated-dtb = "false" is the reverse.
> > >
> > > I am sorry to have to make the discussion even more complex than already
> > > is, however we have one more use case to consider: Linux booting on Xen
> > > as Dom0.
> > >
> > > When booting as Dom0 on ACPI hardware, Linux doesn't have access to the
> > > UEFI firmware (no EFI stub). Xen passes a small device tree blob with
> > > a chosen node, memory information and a pointer to the ACPI tables.
> > > It looks similar to the DTB passed to Linux by the EFI stub but it is
> > > generated by Xen instead.
> >
> > We have two (or even three) different use cases here. One of them is a
> > way to tell the kernel that there is no point in trying DT since it has
> > been generated by the EFI stub and it doesn't have any SoC information.
> > The kernel can bet on ACPI tables being present or just fail to boot.
> > What I want to avoid is "acpi=force" parameter being part of the
> > kernel/firmware ABI for using ACPI (whether DT is present or not).
> >
> > We could call this something else ("linux,bare-dtb"?) if we want to use
> > it in other situations but not "enable_acpi" as we don't want to move
> > the ACPI enabling policy in the EFI stub or boot loader (or whatever
> > generates the chosen node).
> >
> > The Xen case is close to the kexec one. For the latter (I haven't looked
> > at the current arm64 patches yet), I can see that you can pass an
> > "acpi_rsdp" argument to the kernel with the ACPI RSDP address. I don't
> > think that's ideal, we better have some defined DT bindings for such
> > information in the absence of EFI. But it basically means that we'll
> > allow ACPI on arm64 without EFI.
>
> Good, I agree.
>
>
> On Wed, 21 Jan 2015, Catalin Marinas wrote:
> > On Wed, Jan 21, 2015 at 03:29:52PM +0000, Jon Masters wrote:
> > > On 01/21/2015 10:23 AM, Catalin Marinas wrote:
> > > > I have some questions for the ACPI and EFI folk:
> > > >
> > > > 1. When booting with ACPI, are the EFI run-time services required for
> > > >    anything? If yes, Xen may have a bigger problem
> > >
> > > Yes. At least for some things. For example, installing an Operating
> > > System would require that you make runtime services calls to set the
> > > BootOrder/BootNext variables, and so on. Further, we use the GetTime
> > > service and EFI based reboot to avoid having special drivers. I had
> > > those added to SBBR as requirements for that reason.
> >
> > So what would a kexec'ed kernel do here? Or we usually expect it to be
> > short lived and doesn't need reboot, nor GetTime.
> >
> > Xen is slightly more problematic but I wonder whether it could run a
> > (paravirtualised) UEFI.
>
> As a matter of fact that's how it is done on x86: Xen exports a
> paravirtualized UEFI run-time services interface (drivers/xen/efi.c).
> Daniel Kiper (CC'ed) wrote the code that went upstream last August.
> There is no reason why we could not do the same on ARM.

I have done it with ARM in my mind. So, I think that you can reuse that code
fairly easy. Just take look at drivers/xen/efi.c (I think that this should
work on ARM without major changes) and assume arch/x86/xen/efi.c and
arch/x86/xen/enlighten.c as an example of starting point.

> > > > 2. Could a boot loader (either kernel doing kexec or Xen) emulate the
> > > >    EFI system/config tables and still make them useful to the kernel but
> > > >    without EFI_BOOT or EFI_RUNTIME_SERVICES?
> > >
> > > Yes. But again, without the other required pieces (including the
> > > services function pointers in the systab which are required) you'd crash
> > > soon after boot trying to make those calls.
> >
> > My point was whether you can still pass information like RSDP address
> > via EFI tables but explicitly disable runtime services so that the
> > kernel won't try to make such calls (and crash).
>
> I don't think that run-time services are going to be a problem for Xen,
> but I agree that it would be nice not to depend on them to have ACPI.

IIRC, there are relevant options in Linux Kernel and Xen to disable
runtime services, however, I have not tested them.

Daniel
