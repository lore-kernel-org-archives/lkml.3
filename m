Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab3HMRDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:03:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55848 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3HMRDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:03:46 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUX8HZD3z-uwTMWX9CoLdYYqyPVuhH-vWGhJuoonvMQTbQ@mail.gmail.com>
References: <20130813092554.GA4519@cantiga.alporthouse.com>
	<CA+icZUUrJt_sJqp0CNMuM_b36tvv_rUskegLY5zcnm0w+JcW5Q@mail.gmail.com>
	<20130813093920.GB4519@cantiga.alporthouse.com>
	<CA+icZUVEcCTbBre99FWiDXRAMKcdQxUagXE-2-rO9g=YVUAieQ@mail.gmail.com>
	<20130813095259.GC4519@cantiga.alporthouse.com>
	<CA+icZUX6KM3dKrdX3Qkwg-DeBYobjQ+WG6oQEUjJQG3Q=qf+Sg@mail.gmail.com>
	<CA+icZUWPdivbDc=cBUR2BJzKGwWwK-P0OP0CZ5EfCupii7sP_w@mail.gmail.com>
	<CA+icZUUKH6Fa8WksqA69FXKUUJmKsNdXv0ZJH50HA2mFavfPCg@mail.gmail.com>
	<CA+icZUXC73i4hO7LHDQ=85__JtrZmSMB+KyUnS+G6vRmm_=tkg@mail.gmail.com>
	<CA+icZUXdS3EuXyGZiS1--rMu6H0ospzCiK_CXgPv8mOk0sMt+Q@mail.gmail.com>
	<20130813163439.GA8805@cantiga.alporthouse.com>
	<CA+icZUX8HZD3z-uwTMWX9CoLdYYqyPVuhH-vWGhJuoonvMQTbQ@mail.gmail.com>
Date: Tue, 13 Aug 2013 19:03:44 +0200
Message-ID: <CA+icZUU1tbHGVPgjXNvsq-F44O6umbhp_bFcoLE35HZ0zTqo2g@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 13 [ screen corruption in graphical mode ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "s.dilek" <s.dilek@jpberlin.de>
Content-Type: multipart/mixed; boundary=f46d043c815e3e47fc04e3d739d3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d043c815e3e47fc04e3d739d3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 6:37 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Aug 13, 2013 at 6:34 PM, Chris Wilson <chris@chris-wilson.co.uk> =
wrote:
>> On Tue, Aug 13, 2013 at 06:23:29PM +0200, Sedat Dilek wrote:
>>> On Tue, Aug 13, 2013 at 5:59 PM, Sedat Dilek <sedat.dilek@gmail.com> wr=
ote:
>>> > I have bisected the issue on Linux v3.11-rc5 + drm-intel-nightly:
>>> >
>>> > 5456fe3882812aba251886e36fe55bfefb8e8829 is the first bad commit
>>> > commit 5456fe3882812aba251886e36fe55bfefb8e8829
>>> > Author: Chris Wilson <chris@chris-wilson.co.uk>
>>> > Date:   Thu Aug 8 14:41:07 2013 +0100
>>> >
>>> >     drm/i915: Allocate LLC ringbuffers from stolen
>>> >
>>> >     As stolen objects now behave identically (wrt to default LLC cach=
eing)
>>> >     as their normal system counterparts, we no longer have to differe=
ntiate
>>> >     our usage for ringbuffers. So allocate them from stolen on SNB+ a=
s well.
>>> >
>>> >     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>>> >     Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.c=
om>
>>> >     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>> >
>>> > :040000 040000 de063a052f39095f4d2f51b49caef9f827df41e8
>>> > 1c819aa5501a9fcc9912a5c7c037c71b9b9e9a6b M      drivers
>>> >
>>> > See also attached files!
>>> >
>>>
>>> With the attached revert-patch my system is OK (with my customized X st=
ack).
>>
>> No indication of a GPU hang? I'm puzzled as to how this ends up with the
>> scanout being misread.
>>
>> cat /sys/kernel/debug/dri/0/i915_gem_stolen
>> cat /sys/kernel/debug/dri/0/i915_gem_framebuffer
>>
>> would be interesting.
>
> With revert-patch applied:
>
> $ sudo cat /sys/kernel/debug/dri/0/i915_gem_stolen
> Stolen:
>    ffff88007f6f5200: p g     4128KiB 77 00 0 0 0 uncached (name: 1)
> (pinned x 1) (display) (ggtt offset: 00072000, size: 00408000)
> (stolen: 00000000) (p mappable)
> Total 1 objects, 4227072 bytes, 4227072 GTT size
>
> $ sudo cat /sys/kernel/debug/dri/0/i915_gem_framebuffer
> fbcon size: 1366 x 768, depth 24, 32 bpp, refcount 2, obj
> ffff88007f6f5200: p g     4128KiB 77 00 0 0 0 uncached (name: 1)
> (pinned x 1) (display) (ggtt offset: 00072000, size: 00408000)
> (stolen: 00000000) (p mappable)
> user size: 1366 x 768, depth 24, 32 bpp, refcount 3, obj
> ffff88007f6f5080: pXg     5120KiB 36 02 124873 124873 0 uncached dirty
> (name: 3) (pinned x 1) (display) (fence: 0) (ggtt offset: 0047a000,
> size: 00500000) (p mappable) (blitter ring)
>

Attached both outputs with GOOD and BAD (BROKEN) kernel.

- Sedat -

--f46d043c815e3e47fc04e3d739d3
Content-Type: text/plain; charset=US-ASCII; name="i915_gem_framebuffer.txt"
Content-Disposition: attachment; filename="i915_gem_framebuffer.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkbczh3j0

ZmJjb24gc2l6ZTogMTM2NiB4IDc2OCwgZGVwdGggMjQsIDMyIGJwcCwgcmVmY291bnQgMiwgb2Jq
IGZmZmY4ODAwNzQ0OTJlNDA6IHAgZyAgICAgNDEyOEtpQiA3NyAwMCAwIDAgMCB1bmNhY2hlZCAo
bmFtZTogMSkgKHBpbm5lZCB4IDEpIChkaXNwbGF5KSAoZ2d0dCBvZmZzZXQ6IDAwMDcyMDAwLCBz
aXplOiAwMDQwODAwMCkgKHN0b2xlbjogMDAwMDAwMDApIChwIG1hcHBhYmxlKQp1c2VyIHNpemU6
IDEzNjYgeCA3NjgsIGRlcHRoIDI0LCAzMiBicHAsIHJlZmNvdW50IDMsIG9iaiBmZmZmODgwMDc0
NDkyODQwOiBwWGcgICAgIDUxMjBLaUIgMzYgMDIgMTU4MTI2IDE1ODEyNiAwIHVuY2FjaGVkIGRp
cnR5IChuYW1lOiAzKSAocGlubmVkIHggMSkgKGRpc3BsYXkpIChmZW5jZTogMCkgKGdndHQgb2Zm
c2V0OiAwMDQ3YTAwMCwgc2l6ZTogMDA1MDAwMDApIChwIG1hcHBhYmxlKSAoYmxpdHRlciByaW5n
KQo=
--f46d043c815e3e47fc04e3d739d3
Content-Type: text/plain; charset=US-ASCII; name="i915_gem_framebuffer_BROKEN.txt"
Content-Disposition: attachment; filename="i915_gem_framebuffer_BROKEN.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkbczj8r1

ZmJjb24gc2l6ZTogMTM2NiB4IDc2OCwgZGVwdGggMjQsIDMyIGJwcCwgcmVmY291bnQgMiwgb2Jq
IGZmZmY4ODAwNzM5OTUyMDA6IHAgZyAgICAgNDEyOEtpQiA3NyAwMCAwIDAgMCB1bmNhY2hlZCAo
bmFtZTogMSkgKHBpbm5lZCB4IDEpIChkaXNwbGF5KSAoZ2d0dCBvZmZzZXQ6IDAwMDcyMDAwLCBz
aXplOiAwMDQwODAwMCkgKHN0b2xlbjogMDAwNjAwMDApIChwIG1hcHBhYmxlKQp1c2VyIHNpemU6
IDEzNjYgeCA3NjgsIGRlcHRoIDI0LCAzMiBicHAsIHJlZmNvdW50IDMsIG9iaiBmZmZmODgwMDcz
NmQ4ZTAwOiBwWGcgICAgIDUxMjBLaUIgMzYgMDIgLTczNyAtNzM3IDAgdW5jYWNoZWQgZGlydHkg
KG5hbWU6IDMpIChwaW5uZWQgeCAxKSAoZGlzcGxheSkgKGZlbmNlOiAwKSAoZ2d0dCBvZmZzZXQ6
IDAwNDdhMDAwLCBzaXplOiAwMDUwMDAwMCkgKHAgbWFwcGFibGUpIChibGl0dGVyIHJpbmcpCg==
--f46d043c815e3e47fc04e3d739d3
Content-Type: text/plain; charset=US-ASCII; name="i915_gem_stolen.txt"
Content-Disposition: attachment; filename="i915_gem_stolen.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkbczkxv2

U3RvbGVuOgogICBmZmZmODgwMDc0NDkyZTQwOiBwIGcgICAgIDQxMjhLaUIgNzcgMDAgMCAwIDAg
dW5jYWNoZWQgKG5hbWU6IDEpIChwaW5uZWQgeCAxKSAoZGlzcGxheSkgKGdndHQgb2Zmc2V0OiAw
MDA3MjAwMCwgc2l6ZTogMDA0MDgwMDApIChzdG9sZW46IDAwMDAwMDAwKSAocCBtYXBwYWJsZSkK
VG90YWwgMSBvYmplY3RzLCA0MjI3MDcyIGJ5dGVzLCA0MjI3MDcyIEdUVCBzaXplCg==
--f46d043c815e3e47fc04e3d739d3
Content-Type: text/plain; charset=US-ASCII; name="i915_gem_stolen_BROKEN.txt"
Content-Disposition: attachment; filename="i915_gem_stolen_BROKEN.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkbczn1e3

U3RvbGVuOgogICBmZmZmODgwMDczOTk1YzgwOiBwIGcgICAgICAxMjhLaUIgNDAgNDAgMCAwIDAg
c25vb3BlZCBvciBMTEMgZGlydHkgKHBpbm5lZCB4IDEpIChnZ3R0IG9mZnNldDogMDAwMDEwMDAs
IHNpemU6IDAwMDIwMDAwKSAoc3RvbGVuOiAwMDAwMDAwMCkgKHAgbWFwcGFibGUpCiAgIGZmZmY4
ODAwNzM5OTU4MDA6IHAgZyAgICAgIDEyOEtpQiA0MCA0MCAwIDAgMCBzbm9vcGVkIG9yIExMQyBk
aXJ0eSAocGlubmVkIHggMSkgKGdndHQgb2Zmc2V0OiAwMDAyMzAwMCwgc2l6ZTogMDAwMjAwMDAp
IChzdG9sZW46IDAwMDIwMDAwKSAocCBtYXBwYWJsZSkKICAgZmZmZjg4MDA3Mzk5NTUwMDogcCBn
ICAgICAgMTI4S2lCIDQwIDQwIDAgMCAwIHNub29wZWQgb3IgTExDIGRpcnR5IChwaW5uZWQgeCAx
KSAoZ2d0dCBvZmZzZXQ6IDAwMDQ0MDAwLCBzaXplOiAwMDAyMDAwMCkgKHN0b2xlbjogMDAwNDAw
MDApIChwIG1hcHBhYmxlKQogICBmZmZmODgwMDczOTk1MjAwOiBwIGcgICAgIDQxMjhLaUIgNzcg
MDAgMCAwIDAgdW5jYWNoZWQgKG5hbWU6IDEpIChwaW5uZWQgeCAxKSAoZGlzcGxheSkgKGdndHQg
b2Zmc2V0OiAwMDA3MjAwMCwgc2l6ZTogMDA0MDgwMDApIChzdG9sZW46IDAwMDYwMDAwKSAocCBt
YXBwYWJsZSkKVG90YWwgNCBvYmplY3RzLCA0NjIwMjg4IGJ5dGVzLCA0NjIwMjg4IEdUVCBzaXpl
Cg==
--f46d043c815e3e47fc04e3d739d3--
