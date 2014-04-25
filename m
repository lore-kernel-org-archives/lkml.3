Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaDYRGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:06:15 -0400
Received: from smtp.citrix.com ([66.165.176.89]:26516 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbaDYRGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:06:13 -0400
X-IronPort-AV: E=Sophos;i="4.97,928,1389744000"; 
   d="scan'208";a="124654613"
Date: Fri, 25 Apr 2014 18:05:41 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: Julien Grall <julien.grall@linaro.org>, <stefano.stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>, <ian.campbell@citrix.com>,
        <konrad.wilk@oracle.com>
Subject: Re: [PATCH] arm/xen: Remove definiition of virt_to_pfn in
 asm/xen/page.h
In-Reply-To: <53591B8F.8070300@citrix.com>
Message-ID: <alpine.DEB.2.02.1404251801060.8072@kaball.uk.xensource.com>
References: <1397836474-10478-1-git-send-email-julien.grall@linaro.org> <535901F0.3010908@citrix.com> <53590845.1090405@linaro.org> <53591B8F.8070300@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="1342847746-1412538136-1398445541=:8072"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1342847746-1412538136-1398445541=:8072
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 24 Apr 2014, David Vrabel wrote:
> On 24/04/14 13:49, Julien Grall wrote:
> > Hi David,
> >=20
> > On 04/24/2014 01:22 PM, David Vrabel wrote:
> >> On 18/04/14 16:54, Julien Grall wrote:
> >>> virt_to_pfn has been defined in asm/memory.h by the commit e26a9e0 "A=
RM: Better
> >>> virt_to_page() handling"
> >>>
> >>> This will result of a compilation warning when CONFIG_XEN is enabled.
> >>>
> >>> arch/arm/include/asm/xen/page.h:80:0: warning: "virt_to_pfn" redefine=
d [enabled by default]
> >>>  #define virt_to_pfn(v)          (PFN_DOWN(__pa(v)))
> >>>  ^
> >>> In file included from arch/arm/include/asm/page.h:163:0,
> >>>                  from arch/arm/include/asm/xen/page.h:4,
> >>>                  from include/xen/page.h:4,
> >>>                  from arch/arm/xen/grant-table.c:33:
> >>>
> >>> The definition in memory.h is nearly the same (it directly expand PFN=
_DOWN),
> >>> so we can safely drop virt_to_pfn in xen include.
> >>
> >>
> >> This breaks the arm build for me.
> >>
> >> /local/davidvr/work/k.org/tip/drivers/block/xen-blkfront.c: In functio=
n
> >> =E2=80=98setup_blkring=E2=80=99:
> >> /local/davidvr/work/k.org/tip/drivers/block/xen-blkfront.c:1236:2:
> >> error: implicit declaration of function =E2=80=98virt_to_pfn=E2=80=99
> >> [-Werror=3Dimplicit-function-declaration]
> >>   err =3D xenbus_grant_ring(dev, virt_to_mfn(info->ring.sring));
> >>   ^
> >=20
> > I don't have any issue to build the following branch with this patch on=
:
> > =09- v3.15-rc2
> > =09- xentip master
> > =09- xentip for-linus-3.16
>=20
> Applied to devel/for-linus-3.16.
>=20
> If something else turns up for 3.15 (and I remember) I'll take it for
> 3.15 instead.

David,
thank you very much for taking the patch in my absence.

Considering that the problem is affecting everybody enabling CONFIG_XEN
on ARM on v3.15, I don't think we can wait for the next merge window to
send this fix upstream.
Too many warnings for too many people.

Cheers,

Stefano
--1342847746-1412538136-1398445541=:8072--
