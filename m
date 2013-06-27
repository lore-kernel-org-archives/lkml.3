Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3F0SU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:20:56 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:37635 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3F0SUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:20:54 -0400
Message-ID: <51CC8284.9070301@lwfinger.net>
Date: Thu, 27 Jun 2013 13:20:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: rtl8192cu: slow path warning
References: <20130611123814.GA9854@lnx-rg> <20130626142241.GA13107@lnx-rg> <51CB0E9C.50408@lwfinger.net> <CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com>
In-Reply-To: <CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030507000806060906060502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030507000806060906060502
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/27/2013 02:33 AM, Richard Genoud wrote:
> Yes, of course, you can add my
> Reported-by: Richard Genoud <richard.genoud@gmail.com>
>
> But the patch doesn't compile on my platform ( since I'm on ARM, I
> haven't got a PCI bus, so rtlwifi/pci.c is not compiled ) :
>
> ERROR: "rtl_lps_change_work_callback"
> [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
>
>
> Best regards,
> Richard.
>
> PS: duckducking the warning, I found this automated report also :
> https://retrace.fedoraproject.org/faf/reports/142038/

A revised patch for the warning is attached. The fix relatively simple and the 
only difference between this one and the earlier version is that routine 
rtl_lps_change_work_callback() was moved from pci.c to ps.c. As a result, it 
will be available for ARM and other architectures without a PCI bus.

Larry



--------------030507000806060906060502
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192cu_init_work"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rtl8192cu_init_work"

SW5kZXg6IHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3
aWZpL3BjaS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS5vcmln
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcGNpLmMKKysrIHdpcmVsZXNzLXRlc3Rp
bmctc2F2ZS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3BjaS5jCkBAIC0xMDA4LDE5
ICsxMDA4LDYgQEAgc3RhdGljIHZvaWQgX3J0bF9wY2lfcHJlcGFyZV9iY25fdGFza2xldAog
CXJldHVybjsKIH0KIAotc3RhdGljIHZvaWQgcnRsX2xwc19jaGFuZ2Vfd29ya19jYWxsYmFj
ayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCi17Ci0Jc3RydWN0IHJ0bF93b3JrcyAqcnRs
d29ya3MgPQotCSAgICBjb250YWluZXJfb2Yod29yaywgc3RydWN0IHJ0bF93b3JrcywgbHBz
X2NoYW5nZV93b3JrKTsKLQlzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodyA9IHJ0bHdvcmtzLT5o
dzsKLQlzdHJ1Y3QgcnRsX3ByaXYgKnJ0bHByaXYgPSBydGxfcHJpdihodyk7Ci0KLQlpZiAo
cnRscHJpdi0+ZW50ZXJfcHMpCi0JCXJ0bF9scHNfZW50ZXIoaHcpOwotCWVsc2UKLQkJcnRs
X2xwc19sZWF2ZShodyk7Ci19Ci0KIHN0YXRpYyB2b2lkIF9ydGxfcGNpX2luaXRfdHJ4X3Zh
cihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodykKIHsKIAlzdHJ1Y3QgcnRsX3BjaSAqcnRscGNp
ID0gcnRsX3BjaWRldihydGxfcGNpcHJpdihodykpOwpJbmRleDogd2lyZWxlc3MtdGVzdGlu
Zy1zYXZlL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcHMuaAo9PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
Ci0tLSB3aXJlbGVzcy10ZXN0aW5nLXNhdmUub3JpZy9kcml2ZXJzL25ldC93aXJlbGVzcy9y
dGx3aWZpL3BzLmgKKysrIHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS9kcml2ZXJzL25ldC93aXJl
bGVzcy9ydGx3aWZpL3BzLmgKQEAgLTQ5LDUgKzQ5LDYgQEAgdm9pZCBydGxfc3dscHNfcmZf
YXdha2Uoc3RydWN0IGllZWU4MDIxMQogdm9pZCBydGxfc3dscHNfcmZfc2xlZXAoc3RydWN0
IGllZWU4MDIxMV9odyAqaHcpOwogdm9pZCBydGxfcDJwX3BzX2NtZChzdHJ1Y3QgaWVlZTgw
MjExX2h3ICpodywgdTggcDJwX3BzX3N0YXRlKTsKIHZvaWQgcnRsX3AycF9pbmZvKHN0cnVj
dCBpZWVlODAyMTFfaHcgKmh3LCB2b2lkICpkYXRhLCB1bnNpZ25lZCBpbnQgbGVuKTsKK3Zv
aWQgcnRsX2xwc19jaGFuZ2Vfd29ya19jYWxsYmFjayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndv
cmspOwogCiAjZW5kaWYKSW5kZXg6IHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS9kcml2ZXJzL25l
dC93aXJlbGVzcy9ydGx3aWZpL3VzYi5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIHdpcmVsZXNzLXRl
c3Rpbmctc2F2ZS5vcmlnL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvdXNiLmMKKysr
IHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3Vz
Yi5jCkBAIC0xMDcwLDYgKzEwNzAsOCBAQCBpbnQgcnRsX3VzYl9wcm9iZShzdHJ1Y3QgdXNi
X2ludGVyZmFjZSAqCiAJc3Bpbl9sb2NrX2luaXQoJnJ0bHByaXYtPmxvY2tzLnVzYl9sb2Nr
KTsKIAlJTklUX1dPUksoJnJ0bHByaXYtPndvcmtzLmZpbGxfaDJjX2NtZCwKIAkJICBydGxf
ZmlsbF9oMmNfY21kX3dvcmtfY2FsbGJhY2spOworCUlOSVRfV09SSygmcnRscHJpdi0+d29y
a3MubHBzX2NoYW5nZV93b3JrLAorCQkgIHJ0bF9scHNfY2hhbmdlX3dvcmtfY2FsbGJhY2sp
OwogCiAJcnRscHJpdi0+dXNiX2RhdGFfaW5kZXggPSAwOwogCWluaXRfY29tcGxldGlvbigm
cnRscHJpdi0+ZmlybXdhcmVfbG9hZGluZ19jb21wbGV0ZSk7CkluZGV4OiB3aXJlbGVzcy10
ZXN0aW5nLXNhdmUvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9wcy5jCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT0KLS0tIHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS5vcmlnL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL3J0bHdpZmkvcHMuYworKysgd2lyZWxlc3MtdGVzdGluZy1zYXZlL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL3J0bHdpZmkvcHMuYwpAQCAtNjExLDYgKzYxMSwxOCBAQCB2b2lkIHJ0bF9z
d2xwc19yZl9zbGVlcChzdHJ1Y3QgaWVlZTgwMjExCiAJCQlNU0VDUyhzbGVlcF9pbnR2ICog
bWFjLT52aWYtPmJzc19jb25mLmJlYWNvbl9pbnQgLSA0MCkpOwogfQogCit2b2lkIHJ0bF9s
cHNfY2hhbmdlX3dvcmtfY2FsbGJhY2soc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQorewor
CXN0cnVjdCBydGxfd29ya3MgKnJ0bHdvcmtzID0KKwkgICAgY29udGFpbmVyX29mKHdvcmss
IHN0cnVjdCBydGxfd29ya3MsIGxwc19jaGFuZ2Vfd29yayk7CisJc3RydWN0IGllZWU4MDIx
MV9odyAqaHcgPSBydGx3b3Jrcy0+aHc7CisJc3RydWN0IHJ0bF9wcml2ICpydGxwcml2ID0g
cnRsX3ByaXYoaHcpOworCisJaWYgKHJ0bHByaXYtPmVudGVyX3BzKQorCQlydGxfbHBzX2Vu
dGVyKGh3KTsKKwllbHNlCisJCXJ0bF9scHNfbGVhdmUoaHcpOworfQogCiB2b2lkIHJ0bF9z
d2xwc193cV9jYWxsYmFjayh2b2lkICpkYXRhKQogewo=
--------------030507000806060906060502--
