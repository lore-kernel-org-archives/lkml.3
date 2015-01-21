Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbbAUND3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:03:29 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:53757 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbbAUNDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:03:22 -0500
X-IronPort-AV: E=Sophos;i="5.09,441,1418083200"; 
   d="scan'208";a="220172727"
Date: Wed, 21 Jan 2015 13:03:04 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Hanjun Guo <hanjun.guo@linaro.org>
CC: Christoffer Dall <christoffer.dall@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>, Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        <linaro-acpi@lists.linaro.org>, Marc Zyngier <marc.zyngier@arm.com>,
        Jon Masters <jcm@redhat.com>, Timur Tabi <timur@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
        Al Stone <al.stone@linaro.org>, <linux-acpi@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, <suravee.suthikulpanit@amd.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, <phoenix.liyi@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>, <Charles.Garcia-Tobin@arm.com>,
        Parth Dixit <parth.dixit@linaro.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Julien Grall <julien.grall@linaro.org>,
        Stefano Stabellini <stefano.stabellini@citrix.com>
Subject: Re: [PATCH v6 17/17] Documentation: ACPI for ARM64
In-Reply-To: <54BF9D6C.7020807@linaro.org>
Message-ID: <alpine.DEB.2.02.1501211246060.12653@kaball.uk.xensource.com>
References: <1420368918-5086-1-git-send-email-hanjun.guo@linaro.org> <1420368918-5086-18-git-send-email-hanjun.guo@linaro.org> <20150119203328.GB3766@cbox> <54BF9D6C.7020807@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="1342847746-912168662-1421844783=:12653"
Content-ID: <alpine.DEB.2.02.1501211254280.12653@kaball.uk.xensource.com>
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1342847746-912168662-1421844783=:12653
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.02.1501211254281.12653@kaball.uk.xensource.com>

On Wed, 21 Jan 2015, Hanjun Guo wrote:
> Hi Christoffer,
>=20
> Sorry for the late reply, I got no answer yet but
> with one question below.
>=20
> On 2015=E5=B9=B401=E6=9C=8820=E6=97=A5 04:33, Christoffer Dall wrote:
> > Hi,
> >=20
> > On Sun, Jan 04, 2015 at 06:55:18PM +0800, Hanjun Guo wrote:
> > > From: Graeme Gregory <graeme.gregory@linaro.org>
> > >=20
> > > Add documentation for the guidelines of how to use ACPI
> > > on ARM64.
> > >=20
> > > Reviewed-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> > > Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> > > Signed-off-by: Al Stone <al.stone@linaro.org>
> > > Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> > > ---
> > >   Documentation/arm64/arm-acpi.txt | 327
> > > +++++++++++++++++++++++++++++++++++++++
> > >   1 file changed, 327 insertions(+)
> > >   create mode 100644 Documentation/arm64/arm-acpi.txt
> > >=20
> > > diff --git a/Documentation/arm64/arm-acpi.txt
> > > b/Documentation/arm64/arm-acpi.txt
> > > new file mode 100644
> > > index 0000000..21e7020
> > > --- /dev/null
> > > +++ b/Documentation/arm64/arm-acpi.txt
> > > @@ -0,0 +1,327 @@
> > > +ACPI on ARMv8 Servers
> > > +---------------------
> > > +ACPI can be used for ARMv8 general purpose servers designed to follo=
w
> > > +the ARM SBSA (Server Base System Architecture) and SBBR (Server Base
> > > +Boot Requirements) specifications, currently available to those with
> > > +an ARM login at http://silver.arm.com.
> > > +
> > > +The ARMv8 kernel implements the reduced hardware model of ACPI versi=
on
> > > +5.1 and later.  Links to the specification and all external document=
s
> > > +it refers to are managed by the UEFI Forum.  The specification is
> > > +available at http://www.uefi.org/specifications and external documen=
ts
> > > +can be found via http://www.uefi.org/acpi.
> > > +
> > > +If an ARMv8 system does not meet the requirements of the SBSA, or ca=
nnot
> > > +be described using the mechanisms defined in the required ACPI
> > > specifications,
> > > +then it is likely that Device Tree (DT) is more suitable than ACPI f=
or
> > > the
> > > +hardware.
> > > +
> > > +
> > > +Relationship with Device Tree
> > > +-----------------------------
> > > +ACPI support in drivers and subsystems for ARMv8 should never be mut=
ually
> > > +exclusive with DT support at compile time.
> > > +
> > > +At boot time the kernel will only use one description method dependi=
ng on
> > > +parameters passed from the bootloader (including kernel bootargs).
> > > +
> > > +Regardless of whether DT or ACPI is used, the kernel must always be
> > > capable
> > > +of booting with either scheme (in kernels with both schemes enabled =
at
> > > compile
> > > +time).
> > > +
> > > +
> > > +Booting using ACPI tables
> > > +-------------------------
> > > +The only defined method for passing ACPI tables to the kernel on ARM=
v8
> > > +is via the UEFI system configuration table.
> > > +
> >=20
> > This is a bit concerning for the approach we are currently taking to
> > support ACPI on Xen [1].
> >=20
> > Background: Xen is a tiny hypervisor which cannot parse the DSDT or any
> > other non-static table. Xen relies on Linux in Dom0 to manage most
> > (basically everything except the GIC, serial port, SMMU, and timers)
> > hardware resources and relies on Dom0 to parse the ACPI tables.
> >=20
> > While Xen itself is typically booted by UEFI and finds RSDP through the
> > UEFI system table, Xen does NOT run another UEFI instance to boot Dom0
> > nor does it pass through the presence of UEFI to Dom0 in any way.
> > Instead, it just created a DT (with modifications concerning the
> > hardware mentioned above) and boots Linux in Dom0 directly (on x86 any
> > required UEFI call is performed through paravirtualized hypercalls).
> >=20
> > In the case of ACPI, Xen adds a property to the chosen node and
> > populates it with the RDSP in Dom0's address space.  Patches have not
>=20
> Sorry I'm not familiar with hypervisor, I have question here about
> x86 on xen, how ACPI works on XEN for x86?
=20
The whole thing works differently on x86: on native x86 the OS finds the
RDSP by scanning a couple of memory regions looking for the string "RSD
PTR".

Xen and Dom0 both do that independently (Dom0 can map that memory
region).
--1342847746-912168662-1421844783=:12653--
