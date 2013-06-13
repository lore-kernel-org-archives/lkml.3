Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab3FMSmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:42:18 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:46766 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759150Ab3FMSmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:42:17 -0400
MIME-Version: 1.0
In-Reply-To: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
Date: Thu, 13 Jun 2013 11:42:16 -0700
X-Google-Sender-Auth: t7zPbqDEag17XkBlzfqkSDM42ug
Message-ID: <CAE9FiQX1xVJA3MZc4LndWU7kx0mxC-YPE1R8JD4W2-Gg9zq3Zw@mail.gmail.com>
Subject: Re: [BUGFIX 0/9] Fix bug 59501 and code improvement for dock driver
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e0111b7464d12cd04df0d7d91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0111b7464d12cd04df0d7d91
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Jun 13, 2013 at 9:32 AM, Jiang Liu <jiang.liu@huawei.com> wrote:
> Alexander E. Patrakov <patrakov@gmail.com> reports two bugs related to
> dock station support on Sony VAIO VPCZ23A4R. Actually there are at least
> four bugs related to Sony VAIO VPCZ23A4R dock support.
> 1) can't correctly detect hotplug slot for dock state
> 2) resource leak on undocking
> 3) resource allocation failure for dock devices
> 4) one bug in intel_snd_hda driver
>
> The first patch fixes issue 1, and the second patch fixes issue 2.
> These two patches, if accepted, should be material for stable branches
> too.
> Patch 3-9 are code improvement for ACPI and dock driver.
>
> I have found the root cause for issue three, but still working on
> solutions, and seems can't be solve in short time. So please help
> to review and test patches for issue 1) and 2) first.

the 3) is about pci resource allocation?
because pcibios_add_bus is called too early?

If that is case, we should have something like attached patch for it.

With that, we will not need to worry about _OSC set for 3.10 etc.

--089e0111b7464d12cd04df0d7d91
Content-Type: application/octet-stream; 
	name="pci_move_pcibios_add_bus_down.patch"
Content-Disposition: attachment; 
	filename="pci_move_pcibios_add_bus_down.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hhwalzsu0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL2J1cy5jIGIvZHJpdmVycy9wY2kvYnVzLmMKaW5kZXgg
YjFmZjAyYS4uNjhlZDVkOCAxMDA2NDQKLS0tIGEvZHJpdmVycy9wY2kvYnVzLmMKKysrIGIvZHJp
dmVycy9wY2kvYnVzLmMKQEAgLTE4Niw2ICsxODYsMTQgQEAgaW50IHBjaV9idXNfYWRkX2Rldmlj
ZShzdHJ1Y3QgcGNpX2RldiAqZGV2KQogCXJldHVybiAwOwogfQogCit2b2lkIF9fd2VhayBwY2li
aW9zX2FkZF9idXMoc3RydWN0IHBjaV9idXMgKmJ1cykKK3sKK30KKwordm9pZCBfX3dlYWsgcGNp
Ymlvc19yZW1vdmVfYnVzKHN0cnVjdCBwY2lfYnVzICpidXMpCit7Cit9CisKIC8qKgogICogcGNp
X2J1c19hZGRfZGV2aWNlcyAtIHN0YXJ0IGRyaXZlciBmb3IgUENJIGRldmljZXMKICAqIEBidXM6
IGJ1cyB0byBjaGVjayBmb3IgbmV3IGRldmljZXMKQEAgLTE5OCw2ICsyMDYsMTEgQEAgdm9pZCBw
Y2lfYnVzX2FkZF9kZXZpY2VzKGNvbnN0IHN0cnVjdCBwY2lfYnVzICpidXMpCiAJc3RydWN0IHBj
aV9idXMgKmNoaWxkOwogCWludCByZXR2YWw7CiAKKwlpZiAoYnVzLT5pc19hZGRlZCA9PSAxKSB7
CisJCXBjaWJpb3NfYWRkX2J1cyhidXMpOworCQlidXMtPmlzX2FkZGVkKys7CisJfQorCiAJbGlz
dF9mb3JfZWFjaF9lbnRyeShkZXYsICZidXMtPmRldmljZXMsIGJ1c19saXN0KSB7CiAJCS8qIFNr
aXAgYWxyZWFkeS1hZGRlZCBkZXZpY2VzICovCiAJCWlmIChkZXYtPmlzX2FkZGVkKQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9wY2kvcHJvYmUuYyBiL2RyaXZlcnMvcGNpL3Byb2JlLmMKaW5kZXggM2Rm
YzkwNy4uNTE0MDRlNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9wY2kvcHJvYmUuYworKysgYi9kcml2
ZXJzL3BjaS9wcm9iZS5jCkBAIC03MDQsOCArNzA0LDYgQEAgYWRkX2RldjoKIAlyZXQgPSBkZXZp
Y2VfYWRkKCZjaGlsZC0+ZGV2KTsKIAlXQVJOX09OKHJldCA8IDApOwogCi0JcGNpYmlvc19hZGRf
YnVzKGNoaWxkKTsKLQogCS8qIENyZWF0ZSBsZWdhY3lfaW8gYW5kIGxlZ2FjeV9tZW0gZmlsZXMg
Zm9yIHRoaXMgYnVzICovCiAJcGNpX2NyZWF0ZV9sZWdhY3lfZmlsZXMoY2hpbGQpOwogCkBAIC0x
Njg4LDE0ICsxNjg2LDYgQEAgaW50IF9fd2VhayBwY2liaW9zX3Jvb3RfYnJpZGdlX3ByZXBhcmUo
c3RydWN0IHBjaV9ob3N0X2JyaWRnZSAqYnJpZGdlKQogCXJldHVybiAwOwogfQogCi12b2lkIF9f
d2VhayBwY2liaW9zX2FkZF9idXMoc3RydWN0IHBjaV9idXMgKmJ1cykKLXsKLX0KLQotdm9pZCBf
X3dlYWsgcGNpYmlvc19yZW1vdmVfYnVzKHN0cnVjdCBwY2lfYnVzICpidXMpCi17Ci19Ci0KIHN0
cnVjdCBwY2lfYnVzICpwY2lfY3JlYXRlX3Jvb3RfYnVzKHN0cnVjdCBkZXZpY2UgKnBhcmVudCwg
aW50IGJ1cywKIAkJc3RydWN0IHBjaV9vcHMgKm9wcywgdm9pZCAqc3lzZGF0YSwgc3RydWN0IGxp
c3RfaGVhZCAqcmVzb3VyY2VzKQogewpAQCAtMTc0Miw4ICsxNzMyLDYgQEAgc3RydWN0IHBjaV9i
dXMgKnBjaV9jcmVhdGVfcm9vdF9idXMoc3RydWN0IGRldmljZSAqcGFyZW50LCBpbnQgYnVzLAog
CWlmIChlcnJvcikKIAkJZ290byBjbGFzc19kZXZfcmVnX2VycjsKIAotCXBjaWJpb3NfYWRkX2J1
cyhiKTsKLQogCS8qIENyZWF0ZSBsZWdhY3lfaW8gYW5kIGxlZ2FjeV9tZW0gZmlsZXMgZm9yIHRo
aXMgYnVzICovCiAJcGNpX2NyZWF0ZV9sZWdhY3lfZmlsZXMoYik7CiAK
--089e0111b7464d12cd04df0d7d91--
