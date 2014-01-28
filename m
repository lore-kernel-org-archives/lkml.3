Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaA1USv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:18:51 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39508 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbaA1USt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:18:49 -0500
From: "Strashko, Grygorii" <grygorii.strashko@ti.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Yinghai Lu <yinghai@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
Thread-Topic: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
Thread-Index: AQHPHFfdxt7WG3vYDU6baCQUblPPbpqaa/UAgAAUuqQ=
Date: Tue, 28 Jan 2014 20:16:26 +0000
Message-ID: <902E09E6452B0E43903E4F2D568737AB0B98EE9A@DFRE01.ent.ti.com>
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
 <1390590670-25901-4-git-send-email-yinghai@kernel.org>
 <CAOesGMh7+SzLTfyPomnB_Q_wft+RC+F3tx-Ow1TdSmHiSwrKcw@mail.gmail.com>
 <CAGa+x87jJep_TSG70wAr5M-Ce7soPyr4SBdPqyo2ENZ2DYcqkA@mail.gmail.com>
 <CAE9FiQU_vZo40cje_XJXSxuKW-JL6H-8rAazwOw1O-ewcV+C5g@mail.gmail.com>
 <52E7E776.30909@ti.com> <20140128182230.GO15937@n2100.arm.linux.org.uk>
 <52E7F8AC.9090909@ti.com>,<20140128185652.GA9362@phenom.dumpdata.com>
In-Reply-To: <20140128185652.GA9362@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.92]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: multipart/mixed;
	boundary="_002_902E09E6452B0E43903E4F2D568737AB0B98EE9ADFRE01entticom_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_902E09E6452B0E43903E4F2D568737AB0B98EE9ADFRE01entticom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,=0A=
=0A=
Sorry, for the invalid mail & patch format - have no way to send it properl=
y now.=0A=
=0A=
Suppose there is another way to fix this issue (more generic)=0A=
- Correct memblock_virt_allocX() API to limit allocations below memblock.cu=
rrent_limit=0A=
(patch attached).=0A=
=0A=
Then the code behavior will become more similar to _alloc_memory_core_early=
.=0A=
=0A=
Not tested.=0A=
=0A=
=0A=
Best regards,=0A=
- grygorii=0A=
=0A=
________________________________________=0A=
From: Konrad Rzeszutek Wilk [konrad.wilk@oracle.com]=0A=
Sent: Tuesday, January 28, 2014 8:56 PM=0A=
To: Shilimkar, Santosh=0A=
Cc: Russell King - ARM Linux; Yinghai Lu; Kevin Hilman; Olof Johansson; Lin=
us Torvalds; Andrew Morton; Ingo Molnar; H. Peter Anvin; Dave Hansen; linux=
-kernel@vger.kernel.org; Strashko, Grygorii; xen-devel@lists.xensource.com=
=0A=
Subject: Re: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()=
=0A=
=0A=
On Tue, Jan 28, 2014 at 01:36:28PM -0500, Santosh Shilimkar wrote:=0A=
> + Gryagorii,=0A=
> On Tuesday 28 January 2014 01:22 PM, Russell King - ARM Linux wrote:=0A=
> > On Tue, Jan 28, 2014 at 12:23:02PM -0500, Santosh Shilimkar wrote:=0A=
> >> On Tuesday 28 January 2014 12:12 PM, Yinghai Lu wrote:=0A=
> >>> Index: linux-2.6/include/linux/bootmem.h=0A=
> >>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
> >>> --- linux-2.6.orig/include/linux/bootmem.h=0A=
> >>> +++ linux-2.6/include/linux/bootmem.h=0A=
> >>> @@ -179,6 +179,9 @@ static inline void * __init memblock_vir=0A=
> >>>                                                     NUMA_NO_NODE);=0A=
> >>>  }=0A=
> >>>=0A=
> >>> +/* Take arch's ARCH_LOW_ADDRESS_LIMIT at first*/=0A=
> >>> +#include <asm/processor.h>=0A=
> >>> +=0A=
> >>>  #ifndef ARCH_LOW_ADDRESS_LIMIT=0A=
> >>>  #define ARCH_LOW_ADDRESS_LIMIT  0xffffffffUL=0A=
> >>>  #endif=0A=
> >>=0A=
> >> This won't help mostly since the ARM 32 arch don't set ARCH_LOW_ADDRES=
S_LIMIT.=0A=
> >> Sorry i couldn't respond to the thread earlier because of travel and=
=0A=
> >> don't have access to my board to try out the patches.=0A=
> >=0A=
> > Let's think about this for a moment, shall we...=0A=
> >=0A=
> > What does memblock_alloc_virt*() return?  It returns a virtual address.=
=0A=
> >=0A=
> > How is that virtual address obtained?  ptr =3D phys_to_virt(alloc);=0A=
> >=0A=
> > What is the valid address range for passing into phys_to_virt() ?  Only=
=0A=
> > lowmem addresses.=0A=
> >=0A=
> > Hence, having ARCH_LOW_ADDRESS_LIMIT set to 4GB-1 by default seems to b=
e=0A=
> > completely rediculous - and presumably this also fails on x86_32 if it=
=0A=
> > returns memory up at 4GB.=0A=
> >=0A=
> > So... yes, I think reverting the arch/arm part of this patch is the rig=
ht=0A=
> > solution, whether the rest of it should be reverted is something I can'=
t=0A=
> > comment on.=0A=
> >=0A=
> Grygorri mentioned an alternate to update the memblock_find_in_range_node=
() so=0A=
> that it takes into account the limit.=0A=
=0A=
This patch breaks also Xen and 32-bit guests (see=0A=
http://lists.xen.org/archives/html/xen-devel/2014-01/msg02476.html)=0A=
=0A=
Reverting it fixes it.=0A=
=0A=
>=0A=
> Regards,=0A=
> Santosh=0A=

--_002_902E09E6452B0E43903E4F2D568737AB0B98EE9ADFRE01entticom_
Content-Type: text/x-patch;
	name="0001-mm-memblock-fix-upper-boundary-of-allocating-region.patch"
Content-Description: 0001-mm-memblock-fix-upper-boundary-of-allocating-region.patch
Content-Disposition: attachment;
	filename="0001-mm-memblock-fix-upper-boundary-of-allocating-region.patch";
	size=901; creation-date="Tue, 28 Jan 2014 20:10:27 GMT";
	modification-date="Tue, 28 Jan 2014 20:10:27 GMT"
Content-Transfer-Encoding: base64

RnJvbSBlZTMxYWZiOWM1YzBlNzg4MTljZTYyNGUzYTkzMGQzMWI5NzUyN2NkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBncnlnb3JpaXMgPGdyeWdvcmlpLnN0cmFzaGtvQGdsb2JhbGxv
Z2ljLmNvbT4KRGF0ZTogVHVlLCAyOCBKYW4gMjAxNCAyMTo1OTozMCArMDIwMApTdWJqZWN0OiBb
UEFUQ0hdIG1tL21lbWJsb2NrOiBmaXggdXBwZXIgYm91bmRhcnkgb2YgYWxsb2NhdGluZyByZWdp
b24KCkNvcnJlY3QgbWVtYmxvY2tfdmlydF9hbGxvY1goKSBBUEkgdG8gbGltaXQgYWxsb2NhdGlv
bnMgYmVsb3cKbWVtYmxvY2suY3VycmVudF9saW1pdC4KClNpZ25lZC1vZmYtYnk6IGdyeWdvcmlp
cyA8Z3J5Z29yaWkuc3RyYXNoa29AZ2xvYmFsbG9naWMuY29tPgotLS0KIG1tL21lbWJsb2NrLmMg
fCAgICAzICsrKwogMSBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvbW0vbWVtYmxvY2suYyBiL21tL21lbWJsb2NrLmMKaW5kZXggODdk
MjFhNi4uZTkzZDY2OSAxMDA2NDQKLS0tIGEvbW0vbWVtYmxvY2suYworKysgYi9tbS9tZW1ibG9j
ay5jCkBAIC0xMDc3LDYgKzEwNzcsOSBAQCBzdGF0aWMgdm9pZCAqIF9faW5pdCBtZW1ibG9ja192
aXJ0X2FsbG9jX2ludGVybmFsKAogCWlmICghYWxpZ24pCiAJCWFsaWduID0gU01QX0NBQ0hFX0JZ
VEVTOwogCisgICAgICAgIGlmIChtYXhfYWRkciA+IG1lbWJsb2NrLmN1cnJlbnRfbGltaXQpCisg
ICAgICAgICAgICAgICAgbWF4X2FkZHIgPSBtZW1ibG9jay5jdXJyZW50X2xpbWl0OworCiBhZ2Fp
bjoKIAlhbGxvYyA9IG1lbWJsb2NrX2ZpbmRfaW5fcmFuZ2Vfbm9kZShzaXplLCBhbGlnbiwgbWlu
X2FkZHIsIG1heF9hZGRyLAogCQkJCQkgICAgbmlkKTsKLS0gCjEuNy40LjEKCg==

--_002_902E09E6452B0E43903E4F2D568737AB0B98EE9ADFRE01entticom_--
