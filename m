Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbbATTqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:46:32 -0500
Received: from smtp.citrix.com ([66.165.176.89]:61446 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbbATTqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:46:30 -0500
X-IronPort-AV: E=Sophos;i="5.09,436,1418083200"; 
   d="scan'208";a="219131681"
Date: Tue, 20 Jan 2015 19:20:06 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Hanjun Guo <hanjun.guo@linaro.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>,
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
        <christoffer.dall@linaro.org>, <parth.dixit@linaro.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH v7 04/17] ARM64 / ACPI: Introduce early_param for "acpi"
 and pass acpi=force to enable ACPI
In-Reply-To: <54BE1FEA.5040109@linaro.org>
Message-ID: <alpine.DEB.2.02.1501201901190.12653@kaball.uk.xensource.com>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-5-git-send-email-hanjun.guo@linaro.org> <20150119114255.GF11835@e104818-lin.cambridge.arm.com> <CAKv+Gu8vPKAdsNg7QC7xW+i8_BemWEx4mvBx6NrnAHi8Y+bNtw@mail.gmail.com>
 <20150119135144.GI11835@e104818-lin.cambridge.arm.com> <20150119151350.21B65C40948@trevor.secretlab.ca> <54BD3803.6020307@redhat.com> <20150119175233.GK11835@e104818-lin.cambridge.arm.com> <20150119180122.GJ21553@leverpostej> <54BE1FEA.5040109@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="1342847746-1975317034-1421780805=:12653"
Content-ID: <alpine.DEB.2.02.1501201906540.12653@kaball.uk.xensource.com>
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1342847746-1975317034-1421780805=:12653
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.02.1501201906541.12653@kaball.uk.xensource.com>

On Tue, 20 Jan 2015, Hanjun Guo wrote:
> On 2015=E5=B9=B401=E6=9C=8820=E6=97=A5 02:01, Mark Rutland wrote:
> > On Mon, Jan 19, 2015 at 05:52:33PM +0000, Catalin Marinas wrote:
> > > On Mon, Jan 19, 2015 at 04:59:47PM +0000, Jon Masters wrote:
> > > > On 01/19/2015 10:13 AM, Grant Likely wrote:
> > > > > On Mon, 19 Jan 2015 13:51:45 +0000
> > > > > , Catalin Marinas <catalin.marinas@arm.com>
> > > > >   wrote:
> > > > > > On Mon, Jan 19, 2015 at 11:55:32AM +0000, Ard Biesheuvel wrote:
> > > > > > > On 19 January 2015 at 11:42, Catalin Marinas
> > > > > > > <catalin.marinas@arm.com> wrote:
> > > > > > > > On Wed, Jan 14, 2015 at 03:04:52PM +0000, Hanjun Guo wrote:
> > > > > > > > > From: Al Stone <al.stone@linaro.org>
> > > > > > > > >=20
> > > > > > > > > Introduce one early parameters "off" and "force" for "acp=
i",
> > > > > > > > > acpi=3Doff
> > > > > > > > > will be the default behavior for ARM64, so introduce
> > > > > > > > > acpi=3Dforce to
> > > > > > > > > enable ACPI on ARM64.
> > > > > > > > >=20
> > > > > > > > > Disable ACPI before early parameters parsed, and enable i=
t to
> > > > > > > > > pass
> > > > > > > > > "acpi=3Dforce" if people want use ACPI on ARM64. This ens=
ures DT
> > > > > > > > > be
> > > > > > > > > the prefer one if ACPI table and DT both are provided at =
this
> > > > > > > > > moment.
> > > > > > > > [...]
> > > > > > > > > --- a/arch/arm64/kernel/setup.c
> > > > > > > > > +++ b/arch/arm64/kernel/setup.c
> > > > > > > > > @@ -62,6 +62,7 @@
> > > > > > > > >   #include <asm/memblock.h>
> > > > > > > > >   #include <asm/psci.h>
> > > > > > > > >   #include <asm/efi.h>
> > > > > > > > > +#include <asm/acpi.h>
> > > > > > > > >=20
> > > > > > > > >   unsigned int processor_id;
> > > > > > > > >   EXPORT_SYMBOL(processor_id);
> > > > > > > > > @@ -388,6 +389,8 @@ void __init setup_arch(char **cmdline=
_p)
> > > > > > > > >        early_fixmap_init();
> > > > > > > > >        early_ioremap_init();
> > > > > > > > >=20
> > > > > > > > > +     disable_acpi();
> > > > > > > > > +
> > > > > > > > >        parse_early_param();
> > > > > > > > >=20
> > > > > > > > >        /*
> > > > > > > >=20
> > > > > > > > Did we get to any conclusion here? DT being the preferred o=
ne is
> > > > > > > > fine
> > > > > > > > when both DT and ACPI are present but do we still want the
> > > > > > > > kernel to
> > > > > > > > ignore ACPI altogether if DT is not present? It's a bit har=
der
> > > > > > > > to detect
> > > > > > > > the presence of DT at this point since the EFI_STUB added o=
ne
> > > > > > > > already. I
> > > > > > > > guess we could move the "acpi=3Dforce" argument passing to
> > > > > > > > EFI_STUB if no
> > > > > > > > DT is present at boot.
> > > > > > >=20
> > > > > > > Since the EFI stub populates the /chosen node in DT, I would
> > > > > > > prefer
> > > > > > > for it to add a property there to indicate whether it created=
 the
> > > > > > > DT
> > > > > > > from scratch rather than adding ACPI specific stuff in there =
(even
> > > > > > > if
> > > > > > > it is just a string to concatenate)
> > > > > >=20
> > > > > > This works for me. So we could pass "acpi=3Dforce" in EFI stub =
if it
> > > > > > created the DT from scratch *and* ACPI tables are present (can =
it
> > > > > > detect
> > > > > > the latter? And maybe it could print something if none are
> > > > > > available).
> > > > > > If that works, the actual kernel can assume that ACPI needs to =
be
> > > > > > explicitly enabled via acpi=3Dforce, irrespective of how much
> > > > > > information
> > > > > > it has in DT.
> > > > >=20
> > > > > Ditto for me. I think this is a fine solution. And, yes, the stub=
 can
> > > > > easily detect the presence of ACPI by looking in the UEFI config
> > > > > table.
> > > >=20
> > > > I get the point behind doing this, but could we not have it pass in=
 a
> > > > different parameter than =3Dforce? Perhaps something new? I'd like =
to
> > > > separate out the case that it was enabled automatically vs explicit=
ly
> > > > forced on by a user wanting to use ACPI on a system with both table=
s.
> > >=20
> > > Ard had a point, so we should probably not pass acpi=3Dforce from EFI=
 stub
> > > (especially since a user may explicitly pass acpi=3Doff irrespective =
of DT
> > > presence). Some other property in the chosen node? It's not even an A=
BI
> > > since that's a contract between EFI stub and the rest of the kernel, =
so
> > > an in-kernel only interface.
> >=20
> > Not strictly true once kexec is in place. Then it becomes a stub ->
> > kernel -> kernel -> kernel -> ... interface, alnog with the rest of the
> > properties the stub puts in the DTB.
> >=20
> > Having something like /chosen/linux,uefi-stub-generated-dtb sounds sane
> > regardless.
>=20
> How about the patch (just RFC, maybe it is horrible :) ) below:
>=20
> When system supporting both DT and ACPI but firmware providing
> no dtb, we can use this linux,uefi-stub-generated-dtb property
> to let kernel know that we can try ACPI configuration data.
>=20
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  Documentation/devicetree/bindings/chosen.txt | 19 ++++++++++++++++
>  arch/arm64/kernel/setup.c                    | 34
> +++++++++++++++++++++++++++-
>  drivers/firmware/efi/libstub/fdt.c           |  6 +++++
>  3 files changed, 58 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/chosen.txt
> b/Documentation/devicetree/bindings/chosen.txt
> index ed838f4..18776b9 100644
> --- a/Documentation/devicetree/bindings/chosen.txt
> +++ b/Documentation/devicetree/bindings/chosen.txt
> @@ -44,3 +44,22 @@ Implementation note: Linux will look for the property
> "linux,stdout-path" or
>  on PowerPC "stdout" if "stdout-path" is not found.  However, the
>  "linux,stdout-path" and "stdout" properties are deprecated. New platform=
s
>  should only use the "stdout-path" property.
> +
> +
> +linux,uefi-stub-generated-dtb property
> +--------------------------------------
> +
> +UEFI stub will generate this property in the chosen node to let linux ke=
rnel
> +know that there is no DTB provided by firmware.
> +
> +There is a use case for system supporting both DT and ACPI, when firmwar=
e
> +doesn't provide DT, we can try ACPI configration data to boot the system=
=2E
> +
> +Usage:
> +
> +linux,uefi-stub-generated-dtb =3D "true" means that it is true that the =
dtb
> +is generated by uefi stub
> +
> +or
> +
> +linux,uefi-stub-generated-dtb =3D "false" is the reverse.

I am sorry to have to make the discussion even more complex than already
is, however we have one more use case to consider: Linux booting on Xen
as Dom0.

When booting as Dom0 on ACPI hardware, Linux doesn't have access to the
UEFI firmware (no EFI stub). Xen passes a small device tree blob with
a chosen node, memory information and a pointer to the ACPI tables.
It looks similar to the DTB passed to Linux by the EFI stub but it is
generated by Xen instead.

See also Christoffer's explanation:

http://marc.info/?l=3Dlinux-arm-kernel&m=3D142169977401658&w=3D2

The actual patches haven't been posted to the list yet, but Linaro seems
to have an internal prototype working already. We really need to
document this interface properly soon if we expect future Linux and Xen
to adhere to it (hint hint).

In the Dom0 case Linux should parse the small device tree binary, then
enable acpi.

Maybe we could generalize the concept of this uefi-stub-generated-dtb
variable and call it instead "enable_acpi", optionally exporting the
RDSP, like Parth's patches to Xen are doing (I haven't seen the code yet
so I don't know the details).

Do you think that would work for you?
--1342847746-1975317034-1421780805=:12653--
