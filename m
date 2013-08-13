Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab3HMQXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:23:33 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:59133 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab3HMQXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:23:31 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXC73i4hO7LHDQ=85__JtrZmSMB+KyUnS+G6vRmm_=tkg@mail.gmail.com>
References: <CA+icZUWmee5nTZCGvFb4vLpna5vUn+RJ-V9pHpKPFaTc96BG5Q@mail.gmail.com>
	<20130813092554.GA4519@cantiga.alporthouse.com>
	<CA+icZUUrJt_sJqp0CNMuM_b36tvv_rUskegLY5zcnm0w+JcW5Q@mail.gmail.com>
	<20130813093920.GB4519@cantiga.alporthouse.com>
	<CA+icZUVEcCTbBre99FWiDXRAMKcdQxUagXE-2-rO9g=YVUAieQ@mail.gmail.com>
	<20130813095259.GC4519@cantiga.alporthouse.com>
	<CA+icZUX6KM3dKrdX3Qkwg-DeBYobjQ+WG6oQEUjJQG3Q=qf+Sg@mail.gmail.com>
	<CA+icZUWPdivbDc=cBUR2BJzKGwWwK-P0OP0CZ5EfCupii7sP_w@mail.gmail.com>
	<CA+icZUUKH6Fa8WksqA69FXKUUJmKsNdXv0ZJH50HA2mFavfPCg@mail.gmail.com>
	<CA+icZUXC73i4hO7LHDQ=85__JtrZmSMB+KyUnS+G6vRmm_=tkg@mail.gmail.com>
Date: Tue, 13 Aug 2013 18:23:29 +0200
Message-ID: <CA+icZUXdS3EuXyGZiS1--rMu6H0ospzCiK_CXgPv8mOk0sMt+Q@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 13 [ screen corruption in graphical mode ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "s.dilek" <s.dilek@jpberlin.de>
Content-Type: multipart/mixed; boundary=f46d043bdfde4c6bfb04e3d6a9b6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d043bdfde4c6bfb04e3d6a9b6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 5:59 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Aug 13, 2013 at 4:45 PM, Sedat Dilek <sedat.dilek@gmail.com> wrot=
e:
>> On Tue, Aug 13, 2013 at 4:07 PM, Sedat Dilek <sedat.dilek@gmail.com> wro=
te:
>>> On Tue, Aug 13, 2013 at 11:57 AM, Sedat Dilek <sedat.dilek@gmail.com> w=
rote:
>>>> On Tue, Aug 13, 2013 at 11:52 AM, Chris Wilson <chris@chris-wilson.co.=
uk> wrote:
>>>>> On Tue, Aug 13, 2013 at 11:47:19AM +0200, Sedat Dilek wrote:
>>>>>> On Tue, Aug 13, 2013 at 11:39 AM, Chris Wilson <chris@chris-wilson.c=
o.uk> wrote:
>>>>>> > On Tue, Aug 13, 2013 at 11:35:53AM +0200, Sedat Dilek wrote:
>>>>>> >> After a logout from my "BROKEN" Unity-2D session - the login-scre=
en
>>>>>> >> for LightDM seems to be OK.
>>>>>> >> Then entering my Unity-2D desktop is OK - no screen corruptions.
>>>>>> >
>>>>>> > What hardware and display do you have?
>>>>>>
>>>>>> It's a Samsung ultrabook with SandyBridge CPU.
>>>>>>
>>>>>> [   333.291] (--) intel(0): Integrated Graphics Chipset: Intel(R) HD
>>>>>> Graphics 3000
>>>>>
>>>>> using LVDS.
>>>>>
>>>>>> - Sedat -
>>>>>>
>>>>>> P.S.: I switched to intel-ddx v2-21-14-35-g5840bf in the meantime.
>>>>>
>>>>> Did that make a difference? It shouldn't if the error is occuring bef=
ore
>>>>> X even starts...
>>>>
>>>> NO, was just confused not seeing "GT2" (HD-3000 was new to me) in my
>>>> Xorg.log :-).
>>>>
>>>> As said logging out of Unity-2D and entering LightDM greeter - screen =
is fine.
>>>> Starting again a Unity-2D session - no screen corruption, too.
>>>>
>>>> - Sedat -
>>>
>>> Some more testing:
>>>
>>> [1] With my X stack:
>>>
>>> FIRST BAD: next-20130812
>>> LAST GOOD: next-20130809
>>>
>>> [2] With Ubuntu's X stack:
>>>
>>> next-20130813 is OK (Xorg.log attached)
>>>
>>
>> drm-intel-nightly is also BAD with my X stack (with Ubuntu's X stack
>> no problems).
>>
>
> I have bisected the issue on Linux v3.11-rc5 + drm-intel-nightly:
>
> 5456fe3882812aba251886e36fe55bfefb8e8829 is the first bad commit
> commit 5456fe3882812aba251886e36fe55bfefb8e8829
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Thu Aug 8 14:41:07 2013 +0100
>
>     drm/i915: Allocate LLC ringbuffers from stolen
>
>     As stolen objects now behave identically (wrt to default LLC cacheing=
)
>     as their normal system counterparts, we no longer have to differentia=
te
>     our usage for ringbuffers. So allocate them from stolen on SNB+ as we=
ll.
>
>     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>     Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>
> :040000 040000 de063a052f39095f4d2f51b49caef9f827df41e8
> 1c819aa5501a9fcc9912a5c7c037c71b9b9e9a6b M      drivers
>
> See also attached files!
>

With the attached revert-patch my system is OK (with my customized X stack)=
.

- Sedat -

--f46d043bdfde4c6bfb04e3d6a9b6
Content-Type: application/octet-stream; 
	name="0001-Revert-drm-i915-Allocate-LLC-ringbuffers-from-stolen.patch"
Content-Disposition: attachment; 
	filename="0001-Revert-drm-i915-Allocate-LLC-ringbuffers-from-stolen.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkbbkmag3

RnJvbSBlMjgyOTgyNzExY2IzMjYyMTFmN2VkNGJkMDJlMDU0NWMzYWRjMGM0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDEzIEF1ZyAyMDEzIDE4OjAxOjUyICswMjAwClN1YmplY3Q6IFtQQVRDSCBkcm0t
aW50ZWwtbmlnaHRseV0gUmV2ZXJ0ICJkcm0vaTkxNTogQWxsb2NhdGUgTExDIHJpbmdidWZmZXJz
CiBmcm9tIHN0b2xlbiIKClRoaXMgcmV2ZXJ0cyBjb21taXQgNTQ1NmZlMzg4MjgxMmFiYTI1MTg4
NmUzNmZlNTViZmVmYjhlODgyOS4KClNpZ25lZC1vZmYtYnk6IFNlZGF0IERpbGVrIDxzZWRhdC5k
aWxla0BnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfcmluZ2J1ZmZl
ci5jIHwgNCArKystCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfcmluZ2J1ZmZlci5j
IGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfcmluZ2J1ZmZlci5jCmluZGV4IDEwYzJhYWEu
Ljc0ZDAyYTcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3JpbmdidWZm
ZXIuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9yaW5nYnVmZmVyLmMKQEAgLTEy
OTQsNyArMTI5NCw5IEBAIHN0YXRpYyBpbnQgaW50ZWxfaW5pdF9yaW5nX2J1ZmZlcihzdHJ1Y3Qg
ZHJtX2RldmljZSAqZGV2LAogCQkJcmV0dXJuIHJldDsKIAl9CiAKLQlvYmogPSBpOTE1X2dlbV9v
YmplY3RfY3JlYXRlX3N0b2xlbihkZXYsIHJpbmctPnNpemUpOworCW9iaiA9IE5VTEw7CisJaWYg
KCFIQVNfTExDKGRldikpCisJCW9iaiA9IGk5MTVfZ2VtX29iamVjdF9jcmVhdGVfc3RvbGVuKGRl
diwgcmluZy0+c2l6ZSk7CiAJaWYgKG9iaiA9PSBOVUxMKQogCQlvYmogPSBpOTE1X2dlbV9hbGxv
Y19vYmplY3QoZGV2LCByaW5nLT5zaXplKTsKIAlpZiAob2JqID09IE5VTEwpIHsKLS0gCjEuOC4z
LjQKCg==
--f46d043bdfde4c6bfb04e3d6a9b6--
