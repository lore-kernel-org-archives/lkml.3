Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3AZQSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 11:18:43 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:64318 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3AZQSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 11:18:40 -0500
MIME-Version: 1.0
In-Reply-To: <A2530357-B6DA-418D-8193-2955CEC17F1E@yourdreamnet.co.uk>
References: <A2530357-B6DA-418D-8193-2955CEC17F1E@yourdreamnet.co.uk>
Date: Sat, 26 Jan 2013 11:18:39 -0500
Message-ID: <CADnq5_Orb0iVSRo+JioDCLmUd=qmz_MmRZS-w7=Lcbws6Zu3og@mail.gmail.com>
Subject: Re: [PATCH] drm: fix to radeon driver for HD 6450
From: Alex Deucher <alexdeucher@gmail.com>
To: Chris Staite <chris@yourdreamnet.co.uk>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: multipart/mixed; boundary=14dae9cfc75298a23f04d43365e1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9cfc75298a23f04d43365e1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 25, 2013 at 1:10 PM, Chris Staite <chris@yourdreamnet.co.uk> wr=
ote:
> From: Christopher Staite <chris@yourdreamnet.co.uk>
>
> Fix commit 62444b7462a2b98bc78d68736c03a7c4e66ba7e2 for HD 6450.  The sto=
p and resume causes the screen to glitch and the X server to reboot constan=
tly.  Re-instating the UPDATE_LOCK fixes the issue in tests on the v3.6.11 =
stable, and the code has not been altered to fix this since.
>
> Signed-off-by: Christopher Staite <chris@yourdreamnet.co.uk>
>

Looks good.  I've updated the patch to handle the DCE6 case and
improved the commit message.  I'll go ahead and add it to my next
-fixes pull.

Thanks,

Alex

>
>
> --- drivers/gpu/drm/radeon/evergreen.c.org      2013-01-25 17:45:06.00000=
0000 +0000
> +++ drivers/gpu/drm/radeon/evergreen.c  2013-01-25 17:48:14.000000000 +00=
00
> @@ -1320,7 +1320,9 @@ void evergreen_mc_stop(struct radeon_dev
>                                 if (!(tmp & EVERGREEN_CRTC_DISP_READ_REQU=
EST_DISABLE)) {
>                                         radeon_wait_for_vblank(rdev, i);
>                                         tmp |=3D EVERGREEN_CRTC_DISP_READ=
_REQUEST_DISABLE;
> +                                       WREG32(EVERGREEN_CRTC_UPDATE_LOCK=
 + crtc_offsets[i], 1);
>                                         WREG32(EVERGREEN_CRTC_CONTROL + c=
rtc_offsets[i], tmp);
> +                                       WREG32(EVERGREEN_CRTC_UPDATE_LOCK=
 + crtc_offsets[i], 0);
>                                 }
>                         }
>                         /* wait for the next frame */
> @@ -1382,7 +1384,9 @@ void evergreen_mc_resume(struct radeon_d
>                         } else {
>                                 tmp =3D RREG32(EVERGREEN_CRTC_CONTROL + c=
rtc_offsets[i]);
>                                 tmp &=3D ~EVERGREEN_CRTC_DISP_READ_REQUES=
T_DISABLE;
> +                               WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_=
offsets[i], 1);
>                                 WREG32(EVERGREEN_CRTC_CONTROL + crtc_offs=
ets[i], tmp);
> +                               WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_=
offsets[i], 0);
>                         }
>                         /* wait for the next frame */
>                         frame_count =3D radeon_get_vblank_counter(rdev, i=
);
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

--14dae9cfc75298a23f04d43365e1
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-fix-MC-blackout-on-evergreen.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-fix-MC-blackout-on-evergreen.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hceyqumi0

RnJvbSAyNTMzMDdjMWNhN2NjZjBiYTlkZWMxOGMxMjllMDAzMGUwNWQ2ZWJiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDaHJpc3RvcGhlciBTdGFpdGUgPGNocmlzQHlvdXJkcmVhbW5l
dC5jby51az4KRGF0ZTogU2F0LCAyNiBKYW4gMjAxMyAxMToxMDo1OCAtMDUwMApTdWJqZWN0OiBb
UEFUQ0hdIGRybS9yYWRlb246IGZpeCBNQyBibGFja291dCBvbiBldmVyZ3JlZW4rCgpGb3JjZSB0
aGUgY3J0YyBtZW0gcmVxdWVzdHMgb24vb2ZmIGltbWVkaWF0ZWx5IHJhdGhlcgp0aGFuIHdhaXRp
bmcgZm9yIHRoZSBkb3VibGUgYnVmZmVyZWQgdXBkYXRlcyB0byBraWNrIGluLgpTZWVtcyB3ZSBt
aXNzIHRoZSB1cGRhdGUgaW4gY2VydGFpbiBjb25kaXRpb25zLiAgQWxzbwpoYW5kbGUgdGhlIERD
RTYgY2FzZS4KClNpZ25lZC1vZmYtYnk6IENocmlzdG9waGVyIFN0YWl0ZSA8Y2hyaXNAeW91cmRy
ZWFtbmV0LmNvLnVrPgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVj
aGVyQGFtZC5jb20+CkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCi0tLQogZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9ldmVyZ3JlZW4uYyB8ICAgIDggKysrKysrKysKIDEgZmlsZXMgY2hhbmdlZCwg
OCBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1
L2RybS9yYWRlb24vZXZlcmdyZWVuLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2V2ZXJncmVl
bi5jCmluZGV4IDRkMGU2MGEuLjExMmRhOWIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9y
YWRlb24vZXZlcmdyZWVuLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW4u
YwpAQCAtMTMxMywxNCArMTMxMywxOCBAQCB2b2lkIGV2ZXJncmVlbl9tY19zdG9wKHN0cnVjdCBy
YWRlb25fZGV2aWNlICpyZGV2LCBzdHJ1Y3QgZXZlcmdyZWVuX21jX3NhdmUgKnNhdgogCQkJCWlm
ICghKHRtcCAmIEVWRVJHUkVFTl9DUlRDX0JMQU5LX0RBVEFfRU4pKSB7CiAJCQkJCXJhZGVvbl93
YWl0X2Zvcl92YmxhbmsocmRldiwgaSk7CiAJCQkJCXRtcCB8PSBFVkVSR1JFRU5fQ1JUQ19CTEFO
S19EQVRBX0VOOworCQkJCQlXUkVHMzIoRVZFUkdSRUVOX0NSVENfVVBEQVRFX0xPQ0sgKyBjcnRj
X29mZnNldHNbaV0sIDEpOwogCQkJCQlXUkVHMzIoRVZFUkdSRUVOX0NSVENfQkxBTktfQ09OVFJP
TCArIGNydGNfb2Zmc2V0c1tpXSwgdG1wKTsKKwkJCQkJV1JFRzMyKEVWRVJHUkVFTl9DUlRDX1VQ
REFURV9MT0NLICsgY3J0Y19vZmZzZXRzW2ldLCAwKTsKIAkJCQl9CiAJCQl9IGVsc2UgewogCQkJ
CXRtcCA9IFJSRUczMihFVkVSR1JFRU5fQ1JUQ19DT05UUk9MICsgY3J0Y19vZmZzZXRzW2ldKTsK
IAkJCQlpZiAoISh0bXAgJiBFVkVSR1JFRU5fQ1JUQ19ESVNQX1JFQURfUkVRVUVTVF9ESVNBQkxF
KSkgewogCQkJCQlyYWRlb25fd2FpdF9mb3JfdmJsYW5rKHJkZXYsIGkpOwogCQkJCQl0bXAgfD0g
RVZFUkdSRUVOX0NSVENfRElTUF9SRUFEX1JFUVVFU1RfRElTQUJMRTsKKwkJCQkJV1JFRzMyKEVW
RVJHUkVFTl9DUlRDX1VQREFURV9MT0NLICsgY3J0Y19vZmZzZXRzW2ldLCAxKTsKIAkJCQkJV1JF
RzMyKEVWRVJHUkVFTl9DUlRDX0NPTlRST0wgKyBjcnRjX29mZnNldHNbaV0sIHRtcCk7CisJCQkJ
CVdSRUczMihFVkVSR1JFRU5fQ1JUQ19VUERBVEVfTE9DSyArIGNydGNfb2Zmc2V0c1tpXSwgMCk7
CiAJCQkJfQogCQkJfQogCQkJLyogd2FpdCBmb3IgdGhlIG5leHQgZnJhbWUgKi8KQEAgLTEzNzgs
MTEgKzEzODIsMTUgQEAgdm9pZCBldmVyZ3JlZW5fbWNfcmVzdW1lKHN0cnVjdCByYWRlb25fZGV2
aWNlICpyZGV2LCBzdHJ1Y3QgZXZlcmdyZWVuX21jX3NhdmUgKnMKIAkJCWlmIChBU0lDX0lTX0RD
RTYocmRldikpIHsKIAkJCQl0bXAgPSBSUkVHMzIoRVZFUkdSRUVOX0NSVENfQkxBTktfQ09OVFJP
TCArIGNydGNfb2Zmc2V0c1tpXSk7CiAJCQkJdG1wIHw9IEVWRVJHUkVFTl9DUlRDX0JMQU5LX0RB
VEFfRU47CisJCQkJV1JFRzMyKEVWRVJHUkVFTl9DUlRDX1VQREFURV9MT0NLICsgY3J0Y19vZmZz
ZXRzW2ldLCAxKTsKIAkJCQlXUkVHMzIoRVZFUkdSRUVOX0NSVENfQkxBTktfQ09OVFJPTCArIGNy
dGNfb2Zmc2V0c1tpXSwgdG1wKTsKKwkJCQlXUkVHMzIoRVZFUkdSRUVOX0NSVENfVVBEQVRFX0xP
Q0sgKyBjcnRjX29mZnNldHNbaV0sIDApOwogCQkJfSBlbHNlIHsKIAkJCQl0bXAgPSBSUkVHMzIo
RVZFUkdSRUVOX0NSVENfQ09OVFJPTCArIGNydGNfb2Zmc2V0c1tpXSk7CiAJCQkJdG1wICY9IH5F
VkVSR1JFRU5fQ1JUQ19ESVNQX1JFQURfUkVRVUVTVF9ESVNBQkxFOworCQkJCVdSRUczMihFVkVS
R1JFRU5fQ1JUQ19VUERBVEVfTE9DSyArIGNydGNfb2Zmc2V0c1tpXSwgMSk7CiAJCQkJV1JFRzMy
KEVWRVJHUkVFTl9DUlRDX0NPTlRST0wgKyBjcnRjX29mZnNldHNbaV0sIHRtcCk7CisJCQkJV1JF
RzMyKEVWRVJHUkVFTl9DUlRDX1VQREFURV9MT0NLICsgY3J0Y19vZmZzZXRzW2ldLCAwKTsKIAkJ
CX0KIAkJCS8qIHdhaXQgZm9yIHRoZSBuZXh0IGZyYW1lICovCiAJCQlmcmFtZV9jb3VudCA9IHJh
ZGVvbl9nZXRfdmJsYW5rX2NvdW50ZXIocmRldiwgaSk7Ci0tIAoxLjcuNy41Cgo=
--14dae9cfc75298a23f04d43365e1--
