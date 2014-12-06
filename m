Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaLFK50 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 05:57:26 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53999 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaLFK5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 05:57:23 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1411052137430.29198@pobox.suse.cz>
References: <1415067972-3239-1-git-send-email-alan.c.wu@gmail.com>
	<alpine.LNX.2.00.1411052137430.29198@pobox.suse.cz>
Date: Sat, 6 Dec 2014 21:57:21 +1100
Message-ID: <CAOWMAxxR9U5fpN74wOrytWoDB52_p=3t3Swtq+uDry2XT3ZE-g@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: Surface Pro 3 Type Cover 3
From: Jarrad Whitaker <jarrad.whitaker@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Wu <alan.c.wu@gmail.com>, linux-input <linux-input@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d0438903bc7e2f205098a0e03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0438903bc7e2f205098a0e03
Content-Type: text/plain; charset=UTF-8

Hey guys,

Sorry for the very slow reply, I broke my build dir and was in the
middle of exams. Tested successfully (keyboard works after a hotplug)
with 3.18-rc7.

Jarrad

On 6 November 2014 at 07:39, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 3 Nov 2014, Alan Wu wrote:
>
>> Surface Pro 3 Type Cover that works with Ubuntu (and possibly Arch) from this thread. Both trackpad and keyboard work after compiling my own kernel.
>> http://ubuntuforums.org/showthread.php?t=2231207&page=2&s=44910e0c56047e4f93dfd9fea58121ef
>>
>> Also includes Jarrad Whitaker's message which sources
>> http://winaero.com/blog/how-to-install-linux-on-surface-pro-3/
>> which he says is sourced from a Russian site
>>
>> Signed-off-by: Alan Wu <alan.c.wu@gmail.com>
>
> Adding Jarrad to CC so that he can test your patch as well.
>
> Jarrad, if you could provide your Tested-by: to Alan's patch, I'd
> appreciate it (that would mean that we've reached the right super-position
> of both the patches you guys submitted).
>
> I don't own the device, so I fully depend on what you guys submit and
> test.
>
> Thanks.
>
>> ---
>>  drivers/hid/hid-core.c          | 6 ++++++
>>  drivers/hid/hid-ids.h           | 1 +
>>  drivers/hid/hid-microsoft.c     | 2 ++
>>  drivers/hid/usbhid/hid-quirks.c | 1 +
>>  4 files changed, 10 insertions(+)
>>
>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>> index 73bd9e2..e94afcc 100644
>> --- a/drivers/hid/hid-core.c
>> +++ b/drivers/hid/hid-core.c
>> @@ -702,6 +702,11 @@ static void hid_scan_collection(struct hid_parser *parser, unsigned type)
>>       if (((parser->global.usage_page << 16) == HID_UP_SENSOR) &&
>>           type == HID_COLLECTION_PHYSICAL)
>>               hid->group = HID_GROUP_SENSOR_HUB;
>> +
>> +     if (hid->vendor == USB_VENDOR_ID_MICROSOFT &&
>> +         hid->product == USB_DEVICE_ID_MS_TYPE_COVER_3 &&
>> +         hid->group == HID_GROUP_MULTITOUCH)
>> +             hid->group = HID_GROUP_GENERIC;
>>  }
>>
>>  static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
>> @@ -1861,6 +1866,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
>>       { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_WIRELESS_OPTICAL_DESKTOP_3_0) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_OFFICE_KB) },
>> +     { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_3) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_MONTEREY, USB_DEVICE_ID_GENIUS_KB29E) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN) },
>> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
>> index e23ab8b..15f32c2 100644
>> --- a/drivers/hid/hid-ids.h
>> +++ b/drivers/hid/hid-ids.h
>> @@ -648,6 +648,7 @@
>>  #define USB_DEVICE_ID_MS_SURFACE_PRO_2   0x0799
>>  #define USB_DEVICE_ID_MS_TOUCH_COVER_2   0x07a7
>>  #define USB_DEVICE_ID_MS_TYPE_COVER_2    0x07a9
>> +#define USB_DEVICE_ID_MS_TYPE_COVER_3    0x07dc
>>
>>  #define USB_VENDOR_ID_MOJO           0x8282
>>  #define USB_DEVICE_ID_RETRO_ADAPTER  0x3201
>> diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
>> index 8ba17a9..cacda43 100644
>> --- a/drivers/hid/hid-microsoft.c
>> +++ b/drivers/hid/hid-microsoft.c
>> @@ -274,6 +274,8 @@ static const struct hid_device_id ms_devices[] = {
>>               .driver_data = MS_NOGET },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_COMFORT_MOUSE_4500),
>>               .driver_data = MS_DUPLICATE_USAGES },
>> +     { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_3),
>> +             .driver_data = MS_HIDINPUT },
>>
>>       { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT),
>>               .driver_data = MS_PRESENTER },
>> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
>> index 5014bb5..cebfaf2 100644
>> --- a/drivers/hid/usbhid/hid-quirks.c
>> +++ b/drivers/hid/usbhid/hid-quirks.c
>> @@ -77,6 +77,7 @@ static const struct hid_blacklist {
>>       { USB_VENDOR_ID_FORMOSA, USB_DEVICE_ID_FORMOSA_IR_RECEIVER, HID_QUIRK_NO_INIT_REPORTS },
>>       { USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
>>       { USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
>> +     { USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_3, HID_QUIRK_NO_INIT_REPORTS },
>>       { USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
>>       { USB_VENDOR_ID_NEXIO, USB_DEVICE_ID_NEXIO_MULTITOUCH_PTI0750, HID_QUIRK_NO_INIT_REPORTS },
>>       { USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_MOUSE, HID_QUIRK_NO_INIT_REPORTS },
>> --
>> 2.1.0
>>
>
> --
> Jiri Kosina
> SUSE Labs

--f46d0438903bc7e2f205098a0e03
Content-Type: text/x-patch; charset=US-ASCII; name="s3.patch"
Content-Disposition: attachment; filename="s3.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3cv8yy80

U2lnbmVkLW9mZi1ieTogQWxhbiBXdSA8YWxhbi5jLnd1QHh4eHh4eHh4eD4KVGVzdGVkLWJ5OiBK
YXJyYWQgV2hpdGFrZXIgPGphcnJhZC53aGl0YWtlckBnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9o
aWQvaGlkLWNvcmUuYyAgICAgICAgICB8IDYgKysrKysrCiBkcml2ZXJzL2hpZC9oaWQtaWRzLmgg
ICAgICAgICAgIHwgMSArCiBkcml2ZXJzL2hpZC9oaWQtbWljcm9zb2Z0LmMgICAgIHwgMiArKwog
ZHJpdmVycy9oaWQvdXNiaGlkL2hpZC1xdWlya3MuYyB8IDEgKwogNCBmaWxlcyBjaGFuZ2VkLCAx
MCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9oaWQvaGlkLWNvcmUuYyBiL2Ry
aXZlcnMvaGlkL2hpZC1jb3JlLmMKaW5kZXggNzNiZDllMi4uZTk0YWZjYyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9oaWQvaGlkLWNvcmUuYworKysgYi9kcml2ZXJzL2hpZC9oaWQtY29yZS5jCkBAIC03
MDIsNiArNzAyLDExIEBAIHN0YXRpYyB2b2lkIGhpZF9zY2FuX2NvbGxlY3Rpb24oc3RydWN0IGhp
ZF9wYXJzZXIgKnBhcnNlciwgdW5zaWduZWQgdHlwZSkKIAlpZiAoKChwYXJzZXItPmdsb2JhbC51
c2FnZV9wYWdlIDw8IDE2KSA9PSBISURfVVBfU0VOU09SKSAmJgogCSAgICB0eXBlID09IEhJRF9D
T0xMRUNUSU9OX1BIWVNJQ0FMKQogCQloaWQtPmdyb3VwID0gSElEX0dST1VQX1NFTlNPUl9IVUI7
CisKKwlpZiAoaGlkLT52ZW5kb3IgPT0gVVNCX1ZFTkRPUl9JRF9NSUNST1NPRlQgJiYKKwkgICAg
aGlkLT5wcm9kdWN0ID09IFVTQl9ERVZJQ0VfSURfTVNfVFlQRV9DT1ZFUl8zICYmCisJICAgIGhp
ZC0+Z3JvdXAgPT0gSElEX0dST1VQX01VTFRJVE9VQ0gpCisJCWhpZC0+Z3JvdXAgPSBISURfR1JP
VVBfR0VORVJJQzsKIH0KIAogc3RhdGljIGludCBoaWRfc2Nhbl9tYWluKHN0cnVjdCBoaWRfcGFy
c2VyICpwYXJzZXIsIHN0cnVjdCBoaWRfaXRlbSAqaXRlbSkKQEAgLTE4NjEsNiArMTg2Niw3IEBA
IHN0YXRpYyBjb25zdCBzdHJ1Y3QgaGlkX2RldmljZV9pZCBoaWRfaGF2ZV9zcGVjaWFsX2RyaXZl
cltdID0gewogCXsgSElEX1VTQl9ERVZJQ0UoVVNCX1ZFTkRPUl9JRF9NSUNST1NPRlQsIFVTQl9E
RVZJQ0VfSURfTVNfRElHSVRBTF9NRURJQV8zSykgfSwKIAl7IEhJRF9VU0JfREVWSUNFKFVTQl9W
RU5ET1JfSURfTUlDUk9TT0ZULCBVU0JfREVWSUNFX0lEX1dJUkVMRVNTX09QVElDQUxfREVTS1RP
UF8zXzApIH0sCiAJeyBISURfVVNCX0RFVklDRShVU0JfVkVORE9SX0lEX01JQ1JPU09GVCwgVVNC
X0RFVklDRV9JRF9NU19PRkZJQ0VfS0IpIH0sCisJeyBISURfVVNCX0RFVklDRShVU0JfVkVORE9S
X0lEX01JQ1JPU09GVCwgVVNCX0RFVklDRV9JRF9NU19UWVBFX0NPVkVSXzMpIH0sCiAJeyBISURf
VVNCX0RFVklDRShVU0JfVkVORE9SX0lEX01PTlRFUkVZLCBVU0JfREVWSUNFX0lEX0dFTklVU19L
QjI5RSkgfSwKIAl7IEhJRF9VU0JfREVWSUNFKFVTQl9WRU5ET1JfSURfTVNJLCBVU0JfREVWSUNF
X0lEX01TSV9HVDY4M1JfTEVEX1BBTkVMKSB9LAogCXsgSElEX1VTQl9ERVZJQ0UoVVNCX1ZFTkRP
Ul9JRF9OVFJJRywgVVNCX0RFVklDRV9JRF9OVFJJR19UT1VDSF9TQ1JFRU4pIH0sCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL2hpZC9oaWQtaWRzLmggYi9kcml2ZXJzL2hpZC9oaWQtaWRzLmgKaW5kZXgg
ZTIzYWI4Yi4uMTVmMzJjMiAxMDA2NDQKLS0tIGEvZHJpdmVycy9oaWQvaGlkLWlkcy5oCisrKyBi
L2RyaXZlcnMvaGlkL2hpZC1pZHMuaApAQCAtNjQ4LDYgKzY0OCw3IEBACiAjZGVmaW5lIFVTQl9E
RVZJQ0VfSURfTVNfU1VSRkFDRV9QUk9fMiAgIDB4MDc5OQogI2RlZmluZSBVU0JfREVWSUNFX0lE
X01TX1RPVUNIX0NPVkVSXzIgICAweDA3YTcKICNkZWZpbmUgVVNCX0RFVklDRV9JRF9NU19UWVBF
X0NPVkVSXzIgICAgMHgwN2E5CisjZGVmaW5lIFVTQl9ERVZJQ0VfSURfTVNfVFlQRV9DT1ZFUl8z
ICAgIDB4MDdkYwogCiAjZGVmaW5lIFVTQl9WRU5ET1JfSURfTU9KTwkJMHg4MjgyCiAjZGVmaW5l
IFVTQl9ERVZJQ0VfSURfUkVUUk9fQURBUFRFUgkweDMyMDEKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
aGlkL2hpZC1taWNyb3NvZnQuYyBiL2RyaXZlcnMvaGlkL2hpZC1taWNyb3NvZnQuYwppbmRleCA4
YmExN2E5Li5jYWNkYTQzIDEwMDY0NAotLS0gYS9kcml2ZXJzL2hpZC9oaWQtbWljcm9zb2Z0LmMK
KysrIGIvZHJpdmVycy9oaWQvaGlkLW1pY3Jvc29mdC5jCkBAIC0yNzQsNiArMjc0LDggQEAgc3Rh
dGljIGNvbnN0IHN0cnVjdCBoaWRfZGV2aWNlX2lkIG1zX2RldmljZXNbXSA9IHsKIAkJLmRyaXZl
cl9kYXRhID0gTVNfTk9HRVQgfSwKIAl7IEhJRF9VU0JfREVWSUNFKFVTQl9WRU5ET1JfSURfTUlD
Uk9TT0ZULCBVU0JfREVWSUNFX0lEX01TX0NPTUZPUlRfTU9VU0VfNDUwMCksCiAJCS5kcml2ZXJf
ZGF0YSA9IE1TX0RVUExJQ0FURV9VU0FHRVMgfSwKKwl7IEhJRF9VU0JfREVWSUNFKFVTQl9WRU5E
T1JfSURfTUlDUk9TT0ZULCBVU0JfREVWSUNFX0lEX01TX1RZUEVfQ09WRVJfMyksCisJCS5kcml2
ZXJfZGF0YSA9IE1TX0hJRElOUFVUIH0sCiAKIAl7IEhJRF9CTFVFVE9PVEhfREVWSUNFKFVTQl9W
RU5ET1JfSURfTUlDUk9TT0ZULCBVU0JfREVWSUNFX0lEX01TX1BSRVNFTlRFUl84S19CVCksCiAJ
CS5kcml2ZXJfZGF0YSA9IE1TX1BSRVNFTlRFUiB9LApkaWZmIC0tZ2l0IGEvZHJpdmVycy9oaWQv
dXNiaGlkL2hpZC1xdWlya3MuYyBiL2RyaXZlcnMvaGlkL3VzYmhpZC9oaWQtcXVpcmtzLmMKaW5k
ZXggNTAxNGJiNS4uY2ViZmFmMiAxMDA2NDQKLS0tIGEvZHJpdmVycy9oaWQvdXNiaGlkL2hpZC1x
dWlya3MuYworKysgYi9kcml2ZXJzL2hpZC91c2JoaWQvaGlkLXF1aXJrcy5jCkBAIC03Nyw2ICs3
Nyw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaGlkX2JsYWNrbGlzdCB7CiAJeyBVU0JfVkVORE9S
X0lEX0ZPUk1PU0EsIFVTQl9ERVZJQ0VfSURfRk9STU9TQV9JUl9SRUNFSVZFUiwgSElEX1FVSVJL
X05PX0lOSVRfUkVQT1JUUyB9LAogCXsgVVNCX1ZFTkRPUl9JRF9GUkVFU0NBTEUsIFVTQl9ERVZJ
Q0VfSURfRlJFRVNDQUxFX01YMjgsIEhJRF9RVUlSS19OT0dFVCB9LAogCXsgVVNCX1ZFTkRPUl9J
RF9NR0UsIFVTQl9ERVZJQ0VfSURfTUdFX1VQUywgSElEX1FVSVJLX05PR0VUIH0sCisJeyBVU0Jf
VkVORE9SX0lEX01JQ1JPU09GVCwgVVNCX0RFVklDRV9JRF9NU19UWVBFX0NPVkVSXzMsIEhJRF9R
VUlSS19OT19JTklUX1JFUE9SVFMgfSwKIAl7IFVTQl9WRU5ET1JfSURfTVNJLCBVU0JfREVWSUNF
X0lEX01TSV9HVDY4M1JfTEVEX1BBTkVMLCBISURfUVVJUktfTk9fSU5JVF9SRVBPUlRTIH0sCiAJ
eyBVU0JfVkVORE9SX0lEX05FWElPLCBVU0JfREVWSUNFX0lEX05FWElPX01VTFRJVE9VQ0hfUFRJ
MDc1MCwgSElEX1FVSVJLX05PX0lOSVRfUkVQT1JUUyB9LAogCXsgVVNCX1ZFTkRPUl9JRF9OT1ZB
VEVLLCBVU0JfREVWSUNFX0lEX05PVkFURUtfTU9VU0UsIEhJRF9RVUlSS19OT19JTklUX1JFUE9S
VFMgfSwKCg==
--f46d0438903bc7e2f205098a0e03--
