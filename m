Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab3FJOJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 10:09:21 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:43197 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3FJOJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 10:09:19 -0400
MIME-Version: 1.0
In-Reply-To: <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	<1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
Date: Mon, 10 Jun 2013 10:09:18 -0400
Message-ID: <CADnq5_Ns9e85h4WB_0m9-E42mOLrydo6GwkyvjrNYarY4yxJcw@mail.gmail.com>
Subject: Re: [PATCH 3/3] i915: Don't provide ACPI backlight interface if
 firmware expects Windows 8
From: Alex Deucher <alexdeucher@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-acpi@vger.kernel.org, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, rjw@sisk.pl,
        seth.forshee@canonical.com, joeyli.kernel@gmail.com, lenb@kernel.org
Content-Type: multipart/mixed; boundary=089e01293fe293264d04decd53e4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01293fe293264d04decd53e4
Content-Type: text/plain; charset=ISO-8859-1

Radeon probably needs something similar.  See attached untested patch.

Alex

On Sun, Jun 9, 2013 at 7:01 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> Windows 8 leaves backlight control up to individual graphics drivers rather
> than making ACPI calls itself. There's plenty of evidence to suggest that
> the Intel driver for Windows doesn't use the ACPI interface, including the
> fact that it's broken on a bunch of machines when the OS claims to support
> Windows 8. The simplest thing to do appears to be to disable the ACPI
> backlight interface on these systems.
>
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  drivers/gpu/drm/i915/i915_dma.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 3b315ba..23b6292 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -1661,6 +1661,9 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
>                 /* Must be done after probing outputs */
>                 intel_opregion_init(dev);
>                 acpi_video_register();
> +               /* Don't use ACPI backlight functions on Windows 8 platforms */
> +               if (acpi_osi_version() >= ACPI_OSI_WIN_8)
> +                       acpi_video_backlight_unregister();
>         }
>
>         if (IS_GEN5(dev))
> --
> 1.8.2.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

--089e01293fe293264d04decd53e4
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-don-t-provide-ACPI-backlight-if-firmware-.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-don-t-provide-ACPI-backlight-if-firmware-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hhrqkrhm0

RnJvbSBjNmVhZDM0MjlmZDM5NzdiNGIyZWU1NzQ4ZDgzYzcyMjcyNTkyYjI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IE1vbiwgMTAgSnVuIDIwMTMgMTA6MDU6NDMgLTA0MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uOiBkb24ndCBwcm92aWRlIEFDUEkgYmFja2xpZ2h0IGlmIGZpcm13YXJlIGV4
cGVjdHMKIFdpbmRvd3MgOAoKV2luZG93cyA4IGxlYXZlcyBiYWNrbGlnaHQgY29udHJvbCB1cCB0
byBpbmRpdmlkdWFsIGdyYXBoaWNzIGRyaXZlcnMgcmF0aGVyCnRoYW4gbWFraW5nIEFDUEkgY2Fs
bHMgaXRzZWxmLgoKVW50ZXN0ZWQuCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhh
bmRlci5kZXVjaGVyQGFtZC5jb20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlv
c19lbmNvZGVycy5jIHwgICAgNCArKysrCiAxIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygr
KSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0
b21iaW9zX2VuY29kZXJzLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2VuY29k
ZXJzLmMKaW5kZXggNDEyMGQzNS4uYmM5ZTAwNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJt
L3JhZGVvbi9hdG9tYmlvc19lbmNvZGVycy5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24v
YXRvbWJpb3NfZW5jb2RlcnMuYwpAQCAtMjMzLDYgKzIzMywxMCBAQCB2b2lkIHJhZGVvbl9hdG9t
X2JhY2tsaWdodF9pbml0KHN0cnVjdCByYWRlb25fZW5jb2RlciAqcmFkZW9uX2VuY29kZXIsCiAK
IAlEUk1fSU5GTygicmFkZW9uIGF0b20gRElHIGJhY2tsaWdodCBpbml0aWFsaXplZFxuIik7CiAK
KwkvKiBEb24ndCB1c2UgQUNQSSBiYWNrbGlnaHQgZnVuY3Rpb25zIG9uIFdpbmRvd3MgOCBwbGF0
Zm9ybXMgKi8KKwlpZiAoYWNwaV9vc2lfdmVyc2lvbigpID49IEFDUElfT1NJX1dJTl84KQorCQlh
Y3BpX3ZpZGVvX2JhY2tsaWdodF91bnJlZ2lzdGVyKCk7CisKIAlyZXR1cm47CiAKIGVycm9yOgot
LSAKMS43LjcuNQoK
--089e01293fe293264d04decd53e4--
