Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaEHP4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:56:01 -0400
Received: from smtp.citrix.com ([66.165.176.89]:38903 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaEHP4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:56:00 -0400
X-IronPort-AV: E=Sophos;i="4.97,1010,1389744000"; 
   d="scan'208";a="129026747"
Date: Thu, 8 May 2014 16:54:57 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Julien Grall <julien.grall@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH] arm/xen: Remove definiition of virt_to_pfn in
 asm/xen/page.h
In-Reply-To: <20140508110527.GE17344@arm.com>
Message-ID: <alpine.DEB.2.02.1405081653280.14596@kaball.uk.xensource.com>
References: <1397836474-10478-1-git-send-email-julien.grall@linaro.org> <535901F0.3010908@citrix.com> <53590845.1090405@linaro.org> <53591B8F.8070300@citrix.com> <alpine.DEB.2.02.1404251801060.8072@kaball.uk.xensource.com> <alpine.DEB.2.02.1405071234010.14596@kaball.uk.xensource.com>
 <536A1CF8.5000309@citrix.com> <alpine.DEB.2.02.1405071758070.14596@kaball.uk.xensource.com> <20140508110527.GE17344@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="1342847746-963756837-1399564428=:14596"
Content-ID: <alpine.DEB.2.02.1405081653500.14596@kaball.uk.xensource.com>
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1342847746-963756837-1399564428=:14596
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.02.1405081653501.14596@kaball.uk.xensource.com>

On Thu, 8 May 2014, Catalin Marinas wrote:
> On Wed, May 07, 2014 at 05:58:21PM +0100, Stefano Stabellini wrote:
> > On Wed, 7 May 2014, David Vrabel wrote:
> > > On 07/05/14 12:41, Stefano Stabellini wrote:
> > > > On Fri, 25 Apr 2014, Stefano Stabellini wrote:
> > > >> On Thu, 24 Apr 2014, David Vrabel wrote:
> > > >>> On 24/04/14 13:49, Julien Grall wrote:
> > > >>>> Hi David,
> > > >>>>
> > > >>>> On 04/24/2014 01:22 PM, David Vrabel wrote:
> > > >>>>> On 18/04/14 16:54, Julien Grall wrote:
> > > >>>>>> virt_to_pfn has been defined in asm/memory.h by the commit e26=
a9e0 "ARM: Better
> > > >>>>>> virt_to_page() handling"
> > > >>>>>>
> > > >>>>>> This will result of a compilation warning when CONFIG_XEN is e=
nabled.
> > > >>>>>>
> > > >>>>>> arch/arm/include/asm/xen/page.h:80:0: warning: "virt_to_pfn" r=
edefined [enabled by default]
> > > >>>>>>  #define virt_to_pfn(v)          (PFN_DOWN(__pa(v)))
> > > >>>>>>  ^
> > > >>>>>> In file included from arch/arm/include/asm/page.h:163:0,
> > > >>>>>>                  from arch/arm/include/asm/xen/page.h:4,
> > > >>>>>>                  from include/xen/page.h:4,
> > > >>>>>>                  from arch/arm/xen/grant-table.c:33:
> > > >>>>>>
> > > >>>>>> The definition in memory.h is nearly the same (it directly exp=
and PFN_DOWN),
> > > >>>>>> so we can safely drop virt_to_pfn in xen include.
> > > >>>>>
> > > >>>>>
> > > >>>>> This breaks the arm build for me.
> > > >>>>>
> > > >>>>> /local/davidvr/work/k.org/tip/drivers/block/xen-blkfront.c: In =
function
> > > >>>>> =E2=80=98setup_blkring=E2=80=99:
> > > >>>>> /local/davidvr/work/k.org/tip/drivers/block/xen-blkfront.c:1236=
:2:
> > > >>>>> error: implicit declaration of function =E2=80=98virt_to_pfn=E2=
=80=99
> > > >>>>> [-Werror=3Dimplicit-function-declaration]
> > > >>>>>   err =3D xenbus_grant_ring(dev, virt_to_mfn(info->ring.sring))=
;
> > > >>>>>   ^
> > > >>>>
> > > >>>> I don't have any issue to build the following branch with this p=
atch on:
> > > >>>> =09- v3.15-rc2
> > > >>>> =09- xentip master
> > > >>>> =09- xentip for-linus-3.16
> > > >>>
> > > >>> Applied to devel/for-linus-3.16.
> > > >>>
> > > >>> If something else turns up for 3.15 (and I remember) I'll take it=
 for
> > > >>> 3.15 instead.
> > > >>
> > > >> David,
> > > >> thank you very much for taking the patch in my absence.
> > > >>
> > > >> Considering that the problem is affecting everybody enabling CONFI=
G_XEN
> > > >> on ARM on v3.15, I don't think we can wait for the next merge wind=
ow to
> > > >> send this fix upstream.
> > > >> Too many warnings for too many people.
> > > >=20
> > > > Unfortunately this commit breaks arm64 compilation, as virt_to_pfn =
has
> > > > not been introduced to arm64/include/asm/memory.h.
> > > > Has the patch been sent upstream yet?
> > >=20
> > > No.
> > >=20
> > > > We need this additional change for arm64:
> > > >=20
> > > > diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/a=
sm/memory.h
> > > > index e94f945..993bce5 100644
> > > > --- a/arch/arm64/include/asm/memory.h
> > > > +++ b/arch/arm64/include/asm/memory.h
> > > > @@ -138,6 +138,7 @@ static inline void *phys_to_virt(phys_addr_t x)
> > > >  #define __pa(x)=09=09=09__virt_to_phys((unsigned long)(x))
> > > >  #define __va(x)=09=09=09((void *)__phys_to_virt((phys_addr_t)(x)))
> > > >  #define pfn_to_kaddr(pfn)=09__va((pfn) << PAGE_SHIFT)
> > > > +#define virt_to_pfn(x)      __phys_to_pfn(__virt_to_phys(x))
> > >=20
> > > This would need an ack from an arm64 maintainer.
> >=20
> > Certainly. Catalin is in CC.
>=20
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks!
I'll add the following patch to the xentip queue:

commit be0000f4d132cd6db37babd0fd3fb5d1029f9515
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Thu May 8 15:48:13 2014 +0000

    arm64: introduce virt_to_pfn
   =20
    virt_to_pfn has been defined in arch/arm/include/asm/memory.h by commit
    e26a9e0 "ARM: Better virt_to_page() handling" and Xen has come to rely
    on it.  Introduce virt_to_pfn on arm64 too.
   =20
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
    Acked-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memor=
y.h
index e94f945..993bce5 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -138,6 +138,7 @@ static inline void *phys_to_virt(phys_addr_t x)
 #define __pa(x)=09=09=09__virt_to_phys((unsigned long)(x))
 #define __va(x)=09=09=09((void *)__phys_to_virt((phys_addr_t)(x)))
 #define pfn_to_kaddr(pfn)=09__va((pfn) << PAGE_SHIFT)
+#define virt_to_pfn(x)      __phys_to_pfn(__virt_to_phys(x))
=20
 /*
  *  virt_to_page(k)=09convert a _valid_ virtual address to struct page *
--1342847746-963756837-1399564428=:14596--
