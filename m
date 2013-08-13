Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab3HMP7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:59:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64039 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3HMP7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:59:31 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUUKH6Fa8WksqA69FXKUUJmKsNdXv0ZJH50HA2mFavfPCg@mail.gmail.com>
References: <CA+icZUWmee5nTZCGvFb4vLpna5vUn+RJ-V9pHpKPFaTc96BG5Q@mail.gmail.com>
	<20130813092554.GA4519@cantiga.alporthouse.com>
	<CA+icZUUrJt_sJqp0CNMuM_b36tvv_rUskegLY5zcnm0w+JcW5Q@mail.gmail.com>
	<20130813093920.GB4519@cantiga.alporthouse.com>
	<CA+icZUVEcCTbBre99FWiDXRAMKcdQxUagXE-2-rO9g=YVUAieQ@mail.gmail.com>
	<20130813095259.GC4519@cantiga.alporthouse.com>
	<CA+icZUX6KM3dKrdX3Qkwg-DeBYobjQ+WG6oQEUjJQG3Q=qf+Sg@mail.gmail.com>
	<CA+icZUWPdivbDc=cBUR2BJzKGwWwK-P0OP0CZ5EfCupii7sP_w@mail.gmail.com>
	<CA+icZUUKH6Fa8WksqA69FXKUUJmKsNdXv0ZJH50HA2mFavfPCg@mail.gmail.com>
Date: Tue, 13 Aug 2013 17:59:29 +0200
Message-ID: <CA+icZUXC73i4hO7LHDQ=85__JtrZmSMB+KyUnS+G6vRmm_=tkg@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 13 [ screen corruption in graphical mode ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "s.dilek" <s.dilek@jpberlin.de>
Content-Type: multipart/mixed; boundary=e89a8f6427ce7472a304e3d6536e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f6427ce7472a304e3d6536e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 4:45 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Aug 13, 2013 at 4:07 PM, Sedat Dilek <sedat.dilek@gmail.com> wrot=
e:
>> On Tue, Aug 13, 2013 at 11:57 AM, Sedat Dilek <sedat.dilek@gmail.com> wr=
ote:
>>> On Tue, Aug 13, 2013 at 11:52 AM, Chris Wilson <chris@chris-wilson.co.u=
k> wrote:
>>>> On Tue, Aug 13, 2013 at 11:47:19AM +0200, Sedat Dilek wrote:
>>>>> On Tue, Aug 13, 2013 at 11:39 AM, Chris Wilson <chris@chris-wilson.co=
.uk> wrote:
>>>>> > On Tue, Aug 13, 2013 at 11:35:53AM +0200, Sedat Dilek wrote:
>>>>> >> After a logout from my "BROKEN" Unity-2D session - the login-scree=
n
>>>>> >> for LightDM seems to be OK.
>>>>> >> Then entering my Unity-2D desktop is OK - no screen corruptions.
>>>>> >
>>>>> > What hardware and display do you have?
>>>>>
>>>>> It's a Samsung ultrabook with SandyBridge CPU.
>>>>>
>>>>> [   333.291] (--) intel(0): Integrated Graphics Chipset: Intel(R) HD
>>>>> Graphics 3000
>>>>
>>>> using LVDS.
>>>>
>>>>> - Sedat -
>>>>>
>>>>> P.S.: I switched to intel-ddx v2-21-14-35-g5840bf in the meantime.
>>>>
>>>> Did that make a difference? It shouldn't if the error is occuring befo=
re
>>>> X even starts...
>>>
>>> NO, was just confused not seeing "GT2" (HD-3000 was new to me) in my
>>> Xorg.log :-).
>>>
>>> As said logging out of Unity-2D and entering LightDM greeter - screen i=
s fine.
>>> Starting again a Unity-2D session - no screen corruption, too.
>>>
>>> - Sedat -
>>
>> Some more testing:
>>
>> [1] With my X stack:
>>
>> FIRST BAD: next-20130812
>> LAST GOOD: next-20130809
>>
>> [2] With Ubuntu's X stack:
>>
>> next-20130813 is OK (Xorg.log attached)
>>
>
> drm-intel-nightly is also BAD with my X stack (with Ubuntu's X stack
> no problems).
>

I have bisected the issue on Linux v3.11-rc5 + drm-intel-nightly:

5456fe3882812aba251886e36fe55bfefb8e8829 is the first bad commit
commit 5456fe3882812aba251886e36fe55bfefb8e8829
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Aug 8 14:41:07 2013 +0100

    drm/i915: Allocate LLC ringbuffers from stolen

    As stolen objects now behave identically (wrt to default LLC cacheing)
    as their normal system counterparts, we no longer have to differentiate
    our usage for ringbuffers. So allocate them from stolen on SNB+ as well=
.

    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

:040000 040000 de063a052f39095f4d2f51b49caef9f827df41e8
1c819aa5501a9fcc9912a5c7c037c71b9b9e9a6b M      drivers

See also attached files!

- Sedat -

--e89a8f6427ce7472a304e3d6536e
Content-Type: text/plain; charset=US-ASCII; name="git-bisect-log.txt"
Content-Disposition: attachment; filename="git-bisect-log.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkbaoogd0

Z2l0IGJpc2VjdCBzdGFydAojIGdvb2Q6IFtkNGU0YWI4NmJjYmE1YTcyNzc5YzQzZGMxNDU5Zjcx
ZmVhM2Q4OWM4XSBMaW51eCAzLjExLXJjNQpnaXQgYmlzZWN0IGdvb2QgZDRlNGFiODZiY2JhNWE3
Mjc3OWM0M2RjMTQ1OWY3MWZlYTNkODljOAojIGJhZDogWzViNzljOGViMWI2MWQ0OTljYTcwY2Mz
ZTRlMmNlZDc4MjIyMDk4NzZdIE1lcmdlIGJyYW5jaCAnZHJtLWludGVsLW5pZ2h0bHknIGludG8g
My4xMS4wLXJjNS1pbml6YS1zbWFsbApnaXQgYmlzZWN0IGJhZCA1Yjc5YzhlYjFiNjFkNDk5Y2E3
MGNjM2U0ZTJjZWQ3ODIyMjA5ODc2CiMgZ29vZDogWzM2ZjJkMWYxNTEyMTVjNDhkOTAyOTQ3ZDY0
Yjg2ZGM1YWIyNzdlMTldIGRybS9pOTE1OiByaXAgb3V0IGxlZ2FjeSBlbmNvZGVyLT5tb2RlX3Nl
dCBjYWxsYmFjawpnaXQgYmlzZWN0IGdvb2QgMzZmMmQxZjE1MTIxNWM0OGQ5MDI5NDdkNjRiODZk
YzVhYjI3N2UxOQojIGdvb2Q6IFtjMzU0MjZkMmJjMjViMjQyZWUyYTlhN2ExZDYyNjM0YmUxZTg2
YmIwXSBkcm0vaTkxNTogU3BsaXQgcGxhbmUgd2F0ZXJtYXJrIHBhcmFtZXRlcnMgaW50byBhIHNl
cGFyYXRlIHN0cnVjdApnaXQgYmlzZWN0IGdvb2QgYzM1NDI2ZDJiYzI1YjI0MmVlMmE5YTdhMWQ2
MjYzNGJlMWU4NmJiMAojIGdvb2Q6IFszMmM5MTNlNDM2OWNlN2JkMWQxNmE5YjY5ODNmN2I4OTc1
YzEzZjVhXSBNZXJnZSB0YWcgJ2RybS1pbnRlbC1uZXh0LTIwMTMtMDctMjYtZml4ZWQnIG9mIGdp
dDovL3Blb3BsZS5mcmVlZGVza3RvcC5vcmcvfmRhbnZldC9kcm0taW50ZWwgaW50byBkcm0tbmV4
dApnaXQgYmlzZWN0IGdvb2QgMzJjOTEzZTQzNjljZTdiZDFkMTZhOWI2OTgzZjdiODk3NWMxM2Y1
YQojIGdvb2Q6IFtkNDZmMWMzZjEzNzJlM2E3MmZhYjk3YzYwNDgwYWE0YTEwODQzODdmXSBkcm0v
aTkxNTogQWxsb3cgdGhlIEdQVSB0byBjYWNoZSBzdG9sZW4gbWVtb3J5CmdpdCBiaXNlY3QgZ29v
ZCBkNDZmMWMzZjEzNzJlM2E3MmZhYjk3YzYwNDgwYWE0YTEwODQzODdmCiMgYmFkOiBbYjhhMTg2
OGIxMGJiNGZlN2ZiN2QyODNkYTVkNTYwNjRiMWExODlmNF0gZHJtL2k5MTU6IEFsbG93IHRoZSB1
c2VyIHRvIHNldCBibyBpbnRvIHRoZSBESVNQTEFZIGNhY2hlIGRvbWFpbgpnaXQgYmlzZWN0IGJh
ZCBiOGExODY4YjEwYmI0ZmU3ZmI3ZDI4M2RhNWQ1NjA2NGIxYTE4OWY0CiMgYmFkOiBbYTY5OGEy
MGU4Y2Y5YTk0NmIwYTQ5MWNiNThmZjk2YzBiNDMzMmQwOF0gaTkxNTogRml4IFNEVk8gcG90ZW50
aWFsbHkgdHVybmluZyBvZmYgcmFuZG9tbHkKZ2l0IGJpc2VjdCBiYWQgYTY5OGEyMGU4Y2Y5YTk0
NmIwYTQ5MWNiNThmZjk2YzBiNDMzMmQwOAojIGJhZDogWzhkMmQ5ZTY1MTdkOTVkMmJmYTM1ZGZh
NjUwMzMwY2YwYjU5MWQ3ZTFdIGRybS9pOTE1OiBPbmx5IGRvIGEgY2hpcHNldCBmbHVzaCBhZnRl
ciBhIGNsZmx1c2gKZ2l0IGJpc2VjdCBiYWQgOGQyZDllNjUxN2Q5NWQyYmZhMzVkZmE2NTAzMzBj
ZjBiNTkxZDdlMQojIGJhZDogWzU0NTZmZTM4ODI4MTJhYmEyNTE4ODZlMzZmZTU1YmZlZmI4ZTg4
MjldIGRybS9pOTE1OiBBbGxvY2F0ZSBMTEMgcmluZ2J1ZmZlcnMgZnJvbSBzdG9sZW4KZ2l0IGJp
c2VjdCBiYWQgNTQ1NmZlMzg4MjgxMmFiYTI1MTg4NmUzNmZlNTViZmVmYjhlODgyOQojIGZpcnN0
IGJhZCBjb21taXQ6IFs1NDU2ZmUzODgyODEyYWJhMjUxODg2ZTM2ZmU1NWJmZWZiOGU4ODI5XSBk
cm0vaTkxNTogQWxsb2NhdGUgTExDIHJpbmdidWZmZXJzIGZyb20gc3RvbGVuCg==
--e89a8f6427ce7472a304e3d6536e
Content-Type: text/plain; charset=UTF-8; name="git-bisect-view-stat.txt"
Content-Disposition: attachment; filename="git-bisect-view-stat.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkbaoqge1

Y29tbWl0IDU0NTZmZTM4ODI4MTJhYmEyNTE4ODZlMzZmZTU1YmZlZmI4ZTg4MjkKQXV0aG9yOiBD
aHJpcyBXaWxzb24gPGNocmlzQGNocmlzLXdpbHNvbi5jby51az4KRGF0ZTogICBUaHUgQXVnIDgg
MTQ6NDE6MDcgMjAxMyArMDEwMAoKICAgIGRybS9pOTE1OiBBbGxvY2F0ZSBMTEMgcmluZ2J1ZmZl
cnMgZnJvbSBzdG9sZW4KICAgIAogICAgQXMgc3RvbGVuIG9iamVjdHMgbm93IGJlaGF2ZSBpZGVu
dGljYWxseSAod3J0IHRvIGRlZmF1bHQgTExDIGNhY2hlaW5nKQogICAgYXMgdGhlaXIgbm9ybWFs
IHN5c3RlbSBjb3VudGVycGFydHMsIHdlIG5vIGxvbmdlciBoYXZlIHRvIGRpZmZlcmVudGlhdGUK
ICAgIG91ciB1c2FnZSBmb3IgcmluZ2J1ZmZlcnMuIFNvIGFsbG9jYXRlIHRoZW0gZnJvbSBzdG9s
ZW4gb24gU05CKyBhcyB3ZWxsLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBDaHJpcyBXaWxzb24g
PGNocmlzQGNocmlzLXdpbHNvbi5jby51az4KICAgIFJldmlld2VkLWJ5OiBWaWxsZSBTeXJqw6Rs
w6QgPHZpbGxlLnN5cmphbGFAbGludXguaW50ZWwuY29tPgogICAgU2lnbmVkLW9mZi1ieTogRGFu
aWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBmZndsbC5jaD4KCiBkcml2ZXJzL2dwdS9kcm0vaTkx
NS9pbnRlbF9yaW5nYnVmZmVyLmMgfCA0ICstLS0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMyBkZWxldGlvbnMoLSkK
--e89a8f6427ce7472a304e3d6536e
Content-Type: text/plain; charset=UTF-8; name="git-bisect-visualize.txt"
Content-Disposition: attachment; filename="git-bisect-visualize.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkbaos4a2

Y29tbWl0IDU0NTZmZTM4ODI4MTJhYmEyNTE4ODZlMzZmZTU1YmZlZmI4ZTg4MjkKQXV0aG9yOiBD
aHJpcyBXaWxzb24gPGNocmlzQGNocmlzLXdpbHNvbi5jby51az4KRGF0ZTogICBUaHUgQXVnIDgg
MTQ6NDE6MDcgMjAxMyArMDEwMAoKICAgIGRybS9pOTE1OiBBbGxvY2F0ZSBMTEMgcmluZ2J1ZmZl
cnMgZnJvbSBzdG9sZW4KICAgIAogICAgQXMgc3RvbGVuIG9iamVjdHMgbm93IGJlaGF2ZSBpZGVu
dGljYWxseSAod3J0IHRvIGRlZmF1bHQgTExDIGNhY2hlaW5nKQogICAgYXMgdGhlaXIgbm9ybWFs
IHN5c3RlbSBjb3VudGVycGFydHMsIHdlIG5vIGxvbmdlciBoYXZlIHRvIGRpZmZlcmVudGlhdGUK
ICAgIG91ciB1c2FnZSBmb3IgcmluZ2J1ZmZlcnMuIFNvIGFsbG9jYXRlIHRoZW0gZnJvbSBzdG9s
ZW4gb24gU05CKyBhcyB3ZWxsLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBDaHJpcyBXaWxzb24g
PGNocmlzQGNocmlzLXdpbHNvbi5jby51az4KICAgIFJldmlld2VkLWJ5OiBWaWxsZSBTeXJqw6Rs
w6QgPHZpbGxlLnN5cmphbGFAbGludXguaW50ZWwuY29tPgogICAgU2lnbmVkLW9mZi1ieTogRGFu
aWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBmZndsbC5jaD4K
--e89a8f6427ce7472a304e3d6536e--
