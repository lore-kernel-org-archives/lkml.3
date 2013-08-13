Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab3HMRx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:53:29 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39763 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab3HMRx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:53:27 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130813171324.GB8805@cantiga.alporthouse.com>
References: <CA+icZUVEcCTbBre99FWiDXRAMKcdQxUagXE-2-rO9g=YVUAieQ@mail.gmail.com>
	<20130813095259.GC4519@cantiga.alporthouse.com>
	<CA+icZUX6KM3dKrdX3Qkwg-DeBYobjQ+WG6oQEUjJQG3Q=qf+Sg@mail.gmail.com>
	<CA+icZUWPdivbDc=cBUR2BJzKGwWwK-P0OP0CZ5EfCupii7sP_w@mail.gmail.com>
	<CA+icZUUKH6Fa8WksqA69FXKUUJmKsNdXv0ZJH50HA2mFavfPCg@mail.gmail.com>
	<CA+icZUXC73i4hO7LHDQ=85__JtrZmSMB+KyUnS+G6vRmm_=tkg@mail.gmail.com>
	<CA+icZUXdS3EuXyGZiS1--rMu6H0ospzCiK_CXgPv8mOk0sMt+Q@mail.gmail.com>
	<20130813163439.GA8805@cantiga.alporthouse.com>
	<CA+icZUX8HZD3z-uwTMWX9CoLdYYqyPVuhH-vWGhJuoonvMQTbQ@mail.gmail.com>
	<CA+icZUU1tbHGVPgjXNvsq-F44O6umbhp_bFcoLE35HZ0zTqo2g@mail.gmail.com>
	<20130813171324.GB8805@cantiga.alporthouse.com>
Date: Tue, 13 Aug 2013 19:53:25 +0200
Message-ID: <CA+icZUWFqpObp_6KzJExPs2pkJOofaKw6CKv8J0=VTfyVy_Uew@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 13 [ screen corruption in graphical mode ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "s.dilek" <s.dilek@jpberlin.de>
Content-Type: multipart/mixed; boundary=047d7b624e7eec303304e3d7eaa2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b624e7eec303304e3d7eaa2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 7:13 PM, Chris Wilson <chris@chris-wilson.co.uk> wr=
ote:
> On Tue, Aug 13, 2013 at 07:03:44PM +0200, Sedat Dilek wrote:
>> On Tue, Aug 13, 2013 at 6:37 PM, Sedat Dilek <sedat.dilek@gmail.com> wro=
te:
>> > On Tue, Aug 13, 2013 at 6:34 PM, Chris Wilson <chris@chris-wilson.co.u=
k> wrote:
>> >> On Tue, Aug 13, 2013 at 06:23:29PM +0200, Sedat Dilek wrote:
>> >>> On Tue, Aug 13, 2013 at 5:59 PM, Sedat Dilek <sedat.dilek@gmail.com>=
 wrote:
>> >>> > I have bisected the issue on Linux v3.11-rc5 + drm-intel-nightly:
>> >>> >
>> >>> > 5456fe3882812aba251886e36fe55bfefb8e8829 is the first bad commit
>> >>> > commit 5456fe3882812aba251886e36fe55bfefb8e8829
>> >>> > Author: Chris Wilson <chris@chris-wilson.co.uk>
>> >>> > Date:   Thu Aug 8 14:41:07 2013 +0100
>> >>> >
>> >>> >     drm/i915: Allocate LLC ringbuffers from stolen
>> >>> >
>> >>> >     As stolen objects now behave identically (wrt to default LLC c=
acheing)
>> >>> >     as their normal system counterparts, we no longer have to diff=
erentiate
>> >>> >     our usage for ringbuffers. So allocate them from stolen on SNB=
+ as well.
>> >>> >
>> >>> >     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>> >>> >     Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.inte=
l.com>
>> >>> >     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> >>> >
>> >>> > :040000 040000 de063a052f39095f4d2f51b49caef9f827df41e8
>> >>> > 1c819aa5501a9fcc9912a5c7c037c71b9b9e9a6b M      drivers
>> >>> >
>> >>> > See also attached files!
>> >>> >
>> >>>
>> >>> With the attached revert-patch my system is OK (with my customized X=
 stack).
>> >>
>> >> No indication of a GPU hang? I'm puzzled as to how this ends up with =
the
>> >> scanout being misread.
>> >>
>> >> cat /sys/kernel/debug/dri/0/i915_gem_stolen
>> >> cat /sys/kernel/debug/dri/0/i915_gem_framebuffer
>> >>
>> >> would be interesting.
>
>> Attached both outputs with GOOD and BAD (BROKEN) kernel.
>
> ggtt offset is the same for both setups, the only difference between the
> two is the location of fbcon in stolen memory.
>
> Can you please attach the output of intel_reg_dumper for good/bad? It's
> a long shot...
>
> Speaking of long shots, try this (slightly different to the earlier patch=
):
>
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/=
intel_display.c
> index a21f935..37ad772 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -1850,6 +1850,9 @@ intel_pin_and_fence_fb_obj(struct drm_device *dev,
>                 BUG();
>         }
>
> +       if (obj->stolen && INTEL_INFO(dev)->gen >=3D 6)
> +               alignment =3D 256 * 1024;
> +
>         /* Note that the w/a also requires 64 PTE of padding following th=
e
>          * bo. We currently fill all unused PTE with the shadow page and =
so
>          * we should always have valid PTE following the scanout preventi=
ng
>
>
> --

Files attached.

- Sedat -

--047d7b624e7eec303304e3d7eaa2
Content-Type: text/plain; charset=US-ASCII; 
	name="i915_gem_framebuffer_BROKEN_with-ickle-patch.txt"
Content-Disposition: attachment; 
	filename="i915_gem_framebuffer_BROKEN_with-ickle-patch.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkbersqb0

ZmJjb24gc2l6ZTogMTM2NiB4IDc2OCwgZGVwdGggMjQsIDMyIGJwcCwgcmVmY291bnQgMiwgb2Jq
IGZmZmY4ODAxMGM1NGZlNDA6IHAgZyAgICAgNDEyOEtpQiA3NyAwMCAwIDAgMCB1bmNhY2hlZCAo
bmFtZTogMSkgKHBpbm5lZCB4IDEpIChkaXNwbGF5KSAoZ2d0dCBvZmZzZXQ6IDAwMDgwMDAwLCBz
aXplOiAwMDQwODAwMCkgKHN0b2xlbjogMDAwNjAwMDApIChwIG1hcHBhYmxlKQp1c2VyIHNpemU6
IDEzNjYgeCA3NjgsIGRlcHRoIDI0LCAzMiBicHAsIHJlZmNvdW50IDMsIG9iaiBmZmZmODgwMTBj
NTRmY2MwOiBwWGcgICAgIDUxMjBLaUIgMzYgMDIgLTU5MSAtNTkxIDAgdW5jYWNoZWQgZGlydHkg
KG5hbWU6IDMpIChwaW5uZWQgeCAxKSAoZGlzcGxheSkgKGZlbmNlOiAwKSAoZ2d0dCBvZmZzZXQ6
IDAwNDg4MDAwLCBzaXplOiAwMDUwMDAwMCkgKHAgbWFwcGFibGUpIChibGl0dGVyIHJpbmcpCg==
--047d7b624e7eec303304e3d7eaa2
Content-Type: text/plain; charset=US-ASCII; 
	name="i915_gem_framebuffer_with-ickle-patch.txt"
Content-Disposition: attachment; 
	filename="i915_gem_framebuffer_with-ickle-patch.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkberuoy1

ZmJjb24gc2l6ZTogMTM2NiB4IDc2OCwgZGVwdGggMjQsIDMyIGJwcCwgcmVmY291bnQgMiwgb2Jq
IGZmZmY4ODAwNzNmY2EyMDA6IHAgZyAgICAgNDEyOEtpQiA3NyAwMCAwIDAgMCB1bmNhY2hlZCAo
bmFtZTogMSkgKHBpbm5lZCB4IDEpIChkaXNwbGF5KSAoZ2d0dCBvZmZzZXQ6IDAwMDgwMDAwLCBz
aXplOiAwMDQwODAwMCkgKHN0b2xlbjogMDAwMDAwMDApIChwIG1hcHBhYmxlKQp1c2VyIHNpemU6
IDEzNjYgeCA3NjgsIGRlcHRoIDI0LCAzMiBicHAsIHJlZmNvdW50IDMsIG9iaiBmZmZmODgwMTE4
OTI4YjQwOiBwWGcgICAgIDUxMjBLaUIgMzYgMDIgLTEyIC0xMiAwIHVuY2FjaGVkIGRpcnR5IChu
YW1lOiAzKSAocGlubmVkIHggMSkgKGRpc3BsYXkpIChmZW5jZTogMCkgKGdndHQgb2Zmc2V0OiAw
MDQ4ODAwMCwgc2l6ZTogMDA1MDAwMDApIChwIG1hcHBhYmxlKSAoYmxpdHRlciByaW5nKQo=
--047d7b624e7eec303304e3d7eaa2
Content-Type: text/plain; charset=US-ASCII; 
	name="i915_gem_stolen_BROKEN_with-ickle-patch.txt"
Content-Disposition: attachment; 
	filename="i915_gem_stolen_BROKEN_with-ickle-patch.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkberww52

U3RvbGVuOgogICBmZmZmODgwMDcyYzM5YzgwOiBwIGcgICAgICAxMjhLaUIgNDAgNDAgMCAwIDAg
c25vb3BlZCBvciBMTEMgZGlydHkgKHBpbm5lZCB4IDEpIChnZ3R0IG9mZnNldDogMDAwMDEwMDAs
IHNpemU6IDAwMDIwMDAwKSAoc3RvbGVuOiAwMDAwMDAwMCkgKHAgbWFwcGFibGUpCiAgIGZmZmY4
ODAwNzJjMzk4MDA6IHAgZyAgICAgIDEyOEtpQiA0MCA0MCAwIDAgMCBzbm9vcGVkIG9yIExMQyBk
aXJ0eSAocGlubmVkIHggMSkgKGdndHQgb2Zmc2V0OiAwMDAyMzAwMCwgc2l6ZTogMDAwMjAwMDAp
IChzdG9sZW46IDAwMDIwMDAwKSAocCBtYXBwYWJsZSkKICAgZmZmZjg4MDA3MmMzOTUwMDogcCBn
ICAgICAgMTI4S2lCIDQwIDQwIDAgMCAwIHNub29wZWQgb3IgTExDIGRpcnR5IChwaW5uZWQgeCAx
KSAoZ2d0dCBvZmZzZXQ6IDAwMDQ0MDAwLCBzaXplOiAwMDAyMDAwMCkgKHN0b2xlbjogMDAwNDAw
MDApIChwIG1hcHBhYmxlKQogICBmZmZmODgwMTBjNTRmZTQwOiBwIGcgICAgIDQxMjhLaUIgNzcg
MDAgMCAwIDAgdW5jYWNoZWQgKG5hbWU6IDEpIChwaW5uZWQgeCAxKSAoZGlzcGxheSkgKGdndHQg
b2Zmc2V0OiAwMDA4MDAwMCwgc2l6ZTogMDA0MDgwMDApIChzdG9sZW46IDAwMDYwMDAwKSAocCBt
YXBwYWJsZSkKVG90YWwgNCBvYmplY3RzLCA0NjIwMjg4IGJ5dGVzLCA0NjIwMjg4IEdUVCBzaXpl
Cg==
--047d7b624e7eec303304e3d7eaa2
Content-Type: text/plain; charset=US-ASCII; name="i915_gem_stolen_with-ickle-patch.txt"
Content-Disposition: attachment; 
	filename="i915_gem_stolen_with-ickle-patch.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkberyry3

U3RvbGVuOgogICBmZmZmODgwMDczZmNhMjAwOiBwIGcgICAgIDQxMjhLaUIgNzcgMDAgMCAwIDAg
dW5jYWNoZWQgKG5hbWU6IDEpIChwaW5uZWQgeCAxKSAoZGlzcGxheSkgKGdndHQgb2Zmc2V0OiAw
MDA4MDAwMCwgc2l6ZTogMDA0MDgwMDApIChzdG9sZW46IDAwMDAwMDAwKSAocCBtYXBwYWJsZSkK
VG90YWwgMSBvYmplY3RzLCA0MjI3MDcyIGJ5dGVzLCA0MjI3MDcyIEdUVCBzaXplCg==
--047d7b624e7eec303304e3d7eaa2--
