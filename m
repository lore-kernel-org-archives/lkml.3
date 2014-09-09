Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbaIILgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:36:17 -0400
Received: from plane.gmane.org ([80.91.229.3]:40901 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbaIILgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:36:15 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <jvpeetz@web.de>
Subject: Re: [BISECTED] (?) since 3.16: USB video cam of an HP Pavilion dv7
 laptop not working
Date: Tue, 09 Sep 2014 13:36:02 +0200
Message-ID: <540EE622.4030203@web.de>
References: <540DC871.7040901@web.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020803050302000609080007"
X-Complaints-To: usenet@ger.gmane.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
X-Gmane-NNTP-Posting-Host: p5b37afc2.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
In-Reply-To: <540DC871.7040901@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020803050302000609080007
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Jörg-Volker Peetz wrote on 09/08/2014 17:17:
> Since 3.16 the builtin USB video cam of an HP Pavilion dv7 laptop shows only a
> black screen with the application guvcview although the video LED is turned on.
> There is no hint in dmesg. Also the output of guvcview shows no conspicuousness.
> 
> With kernel version 3.15.9 the camera works.
> 
> I tried to bisect between good v3.15 and bad v3.16, which identified
> 
> commit 9262c19d14c433a6a1ba25c3ff897cb89e412309
> Author: Dan Williams <dan.j.williams@intel.com>
> Date:   Tue May 20 18:08:12 2014 -0700
> 
>     usb: disable port power control if not supported in wHubCharacteristics
> 
>     A hub indicates whether it supports per-port power control via the
>     wHubCharacteristics field in its descriptor.  If it is not supported
>     a hub will still emulate ClearPortPower(PORT_POWER) requests by
>     stopping the link state machine.  However, since this does not save
>     power do not bother suspending.
> 
>     This also consolidates support checks into a
>     hub_is_port_power_switchable() helper.
> 
>     Acked-by: Alan Stern <stern@rowland.harvard.edu>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> In the bad bisection steps the video device even was not found. Therefore, I'm
> not sure if I identified the right culprit.
> 

As you suggested Dan, I reverted this commit on top of 3.16.0 (the commit could
not be reverted cleanly, I had to do it manually, patch appended). But still I
see a black picture from the camera. So this commit is not the culprit.

How to proceed with the bisection?
-- 
Regards,
Jörg-Volker.


--------------020803050302000609080007
Content-Type: text/plain; charset=UTF-8;
 name="my-patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="my-patch"

LS0tIGh1Yi5jLm9yaWcJMjAxNC0wOC0wNCAwMDoyNTowMi4wMDAwMDAwMDAgKzAyMDAKKysr
IGh1Yi5jCTIwMTQtMDktMDkgMTE6NTY6MjQuNzIxMzEyNDY5ICswMjAwCkBAIC04MjAsNiAr
ODIwLDggQEAgRVhQT1JUX1NZTUJPTF9HUEwodXNiX2h1Yl9jbGVhcl90dF9idWZmZQogc3Rh
dGljIHZvaWQgaHViX3Bvd2VyX29uKHN0cnVjdCB1c2JfaHViICpodWIsIGJvb2wgZG9fZGVs
YXkpCiB7CiAJaW50IHBvcnQxOworCXUxNiB3SHViQ2hhcmFjdGVyaXN0aWNzID0KKwkJCWxl
MTZfdG9fY3B1KGh1Yi0+ZGVzY3JpcHRvci0+d0h1YkNoYXJhY3RlcmlzdGljcyk7CiAKIAkv
KiBFbmFibGUgcG93ZXIgb24gZWFjaCBwb3J0LiAgU29tZSBodWJzIGhhdmUgcmVzZXJ2ZWQg
dmFsdWVzCiAJICogb2YgTFBTTSAoPiAyKSBpbiB0aGVpciBkZXNjcmlwdG9ycywgZXZlbiB0
aG91Z2ggdGhleSBhcmUKQEAgLTgyNyw3ICs4MjksNyBAQCBzdGF0aWMgdm9pZCBodWJfcG93
ZXJfb24oc3RydWN0IHVzYl9odWIKIAkgKiBidXQgb25seSBlbXVsYXRlIGl0LiAgSW4gYWxs
IGNhc2VzLCB0aGUgcG9ydHMgd29uJ3Qgd29yawogCSAqIHVubGVzcyB3ZSBzZW5kIHRoZXNl
IG1lc3NhZ2VzIHRvIHRoZSBodWIuCiAJICovCi0JaWYgKGh1Yl9pc19wb3J0X3Bvd2VyX3N3
aXRjaGFibGUoaHViKSkKKwlpZiAoKHdIdWJDaGFyYWN0ZXJpc3RpY3MgJiBIVUJfQ0hBUl9M
UFNNKSA8IDIpCiAJCWRldl9kYmcoaHViLT5pbnRmZGV2LCAiZW5hYmxpbmcgcG93ZXIgb24g
YWxsIHBvcnRzXG4iKTsKIAllbHNlCiAJCWRldl9kYmcoaHViLT5pbnRmZGV2LCAidHJ5aW5n
IHRvIGVuYWJsZSBwb3J0IHBvd2VyIG9uICIKQEAgLTQ1NDgsNiArNDU1MCw4IEBAIHN0YXRp
YyB2b2lkIGh1Yl9wb3J0X2Nvbm5lY3Qoc3RydWN0IHVzYl8KIAl1bnNpZ25lZCB1bml0X2xv
YWQ7CiAJc3RydWN0IHVzYl9kZXZpY2UgKmhkZXYgPSBodWItPmhkZXY7CiAJc3RydWN0IHVz
Yl9oY2QgKmhjZCA9IGJ1c190b19oY2QoaGRldi0+YnVzKTsKKwl1bnNpZ25lZCB3SHViQ2hh
cmFjdGVyaXN0aWNzID0KKwkJCWxlMTZfdG9fY3B1KGh1Yi0+ZGVzY3JpcHRvci0+d0h1YkNo
YXJhY3RlcmlzdGljcyk7CiAJc3RydWN0IHVzYl9wb3J0ICpwb3J0X2RldiA9IGh1Yi0+cG9y
dHNbcG9ydDEgLSAxXTsKIAlzdHJ1Y3QgdXNiX2RldmljZSAqdWRldiA9IHBvcnRfZGV2LT5j
aGlsZDsKIApAQCAtNDU4Niw3ICs0NTkwLDcgQEAgc3RhdGljIHZvaWQgaHViX3BvcnRfY29u
bmVjdChzdHJ1Y3QgdXNiXwogCQkJdGVzdF9iaXQocG9ydDEsIGh1Yi0+cmVtb3ZlZF9iaXRz
KSkgewogCiAJCS8qIG1heWJlIHN3aXRjaCBwb3dlciBiYWNrIG9uIChlLmcuIHJvb3QgaHVi
IHdhcyByZXNldCkgKi8KLQkJaWYgKGh1Yl9pc19wb3J0X3Bvd2VyX3N3aXRjaGFibGUoaHVi
KQorCQlpZiAoKHdIdWJDaGFyYWN0ZXJpc3RpY3MgJiBIVUJfQ0hBUl9MUFNNKSA8IDIKIAkJ
CQkmJiAhcG9ydF9pc19wb3dlcl9vbihodWIsIHBvcnRzdGF0dXMpKQogCQkJc2V0X3BvcnRf
ZmVhdHVyZShoZGV2LCBwb3J0MSwgVVNCX1BPUlRfRkVBVF9QT1dFUik7CiAKLS0tIGh1Yi5o
Lm9yaWcJMjAxNC0wOC0wNCAwMDoyNTowMi4wMDAwMDAwMDAgKzAyMDAKKysrIGh1Yi5oCTIw
MTQtMDktMDkgMTI6NTI6NDAuMDI3OTAzNzkxICswMjAwCkBAIC0xMTksMTYgKzExOSw2IEBA
IGV4dGVybiBpbnQgaHViX3BvcnRfZGVib3VuY2Uoc3RydWN0IHVzYl8KIGV4dGVybiBpbnQg
dXNiX2NsZWFyX3BvcnRfZmVhdHVyZShzdHJ1Y3QgdXNiX2RldmljZSAqaGRldiwKIAkJaW50
IHBvcnQxLCBpbnQgZmVhdHVyZSk7CiAKLXN0YXRpYyBpbmxpbmUgYm9vbCBodWJfaXNfcG9y
dF9wb3dlcl9zd2l0Y2hhYmxlKHN0cnVjdCB1c2JfaHViICpodWIpCi17Ci0JX19sZTE2IGhj
czsKLQotCWlmICghaHViKQotCQlyZXR1cm4gZmFsc2U7Ci0JaGNzID0gaHViLT5kZXNjcmlw
dG9yLT53SHViQ2hhcmFjdGVyaXN0aWNzOwotCXJldHVybiAobGUxNl90b19jcHUoaGNzKSAm
IEhVQl9DSEFSX0xQU00pIDwgSFVCX0NIQVJfTk9fTFBTTTsKLX0KLQogc3RhdGljIGlubGlu
ZSBpbnQgaHViX2lzX3N1cGVyc3BlZWQoc3RydWN0IHVzYl9kZXZpY2UgKmhkZXYpCiB7CiAJ
cmV0dXJuIGhkZXYtPmRlc2NyaXB0b3IuYkRldmljZVByb3RvY29sID09IFVTQl9IVUJfUFJf
U1M7Ci0tLSBwb3J0LmMub3JpZwkyMDE0LTA4LTA0IDAwOjI1OjAyLjAwMDAwMDAwMCArMDIw
MAorKysgcG9ydC5jCTIwMTQtMDktMDkgMTI6NTg6NDYuNTIxMjI5NDMwICswMjAwCkBAIC00
NDUsMTYgKzQ0NSwxMSBAQCBpbnQgdXNiX2h1Yl9jcmVhdGVfcG9ydF9kZXZpY2Uoc3RydWN0
IHVzCiAJICovCiAJcG1fcnVudGltZV9zZXRfYWN0aXZlKCZwb3J0X2Rldi0+ZGV2KTsKIAlw
bV9ydW50aW1lX2dldF9ub3Jlc3VtZSgmcG9ydF9kZXYtPmRldik7Ci0JcG1fcnVudGltZV9l
bmFibGUoJnBvcnRfZGV2LT5kZXYpOworCWlmICghZGV2X3BtX3Fvc19leHBvc2VfZmxhZ3Mo
JnBvcnRfZGV2LT5kZXYsCisJCQlQTV9RT1NfRkxBR19OT19QT1dFUl9PRkYpKQorCQlwbV9y
dW50aW1lX2VuYWJsZSgmcG9ydF9kZXYtPmRldik7CiAJZGV2aWNlX2VuYWJsZV9hc3luY19z
dXNwZW5kKCZwb3J0X2Rldi0+ZGV2KTsKIAotCS8qCi0JICogS2VlcCBoaWRkZW4gdGhlIGFi
aWxpdHkgdG8gZW5hYmxlIHBvcnQtcG93ZXJvZmYgaWYgdGhlIGh1YgotCSAqIGRvZXMgbm90
IHN1cHBvcnQgcG93ZXIgc3dpdGNoaW5nLgotCSAqLwotCWlmICghaHViX2lzX3BvcnRfcG93
ZXJfc3dpdGNoYWJsZShodWIpKQotCQlyZXR1cm4gMDsKLQogCS8qIEF0dGVtcHQgdG8gbGV0
IHVzZXJzcGFjZSB0YWtlIG92ZXIgdGhlIHBvbGljeS4gKi8KIAlyZXR2YWwgPSBkZXZfcG1f
cW9zX2V4cG9zZV9mbGFncygmcG9ydF9kZXYtPmRldiwKIAkJCVBNX1FPU19GTEFHX05PX1BP
V0VSX09GRik7Cg==
--------------020803050302000609080007--

