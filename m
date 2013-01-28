Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3A1G5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 01:57:40 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:62334 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3A1G5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 01:57:36 -0500
MIME-Version: 1.0
In-Reply-To: <FE3E8B88161FFE48B03E3B93408433EC671016E2@G9W0754.americas.hpqcorp.net>
References: <1358214636-4801-1-git-send-email-song-bo.wang@hp.com>
	<FE3E8B88161FFE48B03E3B93408433EC671016E2@G9W0754.americas.hpqcorp.net>
Date: Sun, 27 Jan 2013 22:57:35 -0800
X-Google-Sender-Auth: VQmLQfKJEIc0XbwfY31VAN95tlc
Message-ID: <CAE9FiQW75eP_exufb1gd7jQuu98WnkyGX23EBXktUCSyZX9Jvg@mail.gmail.com>
Subject: Re: [PATCH] x86/apic: check FADT settings after enable x2apic
From: Yinghai Lu <yinghai@kernel.org>
To: "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>
Content-Type: multipart/mixed; boundary=20cf303ddba6baf5fc04d453ca01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf303ddba6baf5fc04d453ca01
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Jan 27, 2013 at 9:05 PM, Wang, Song-Bo (Stoney)
<song-bo.wang@hp.com> wrote:
> Hi Yinghai, hpa and others,
>
> Would you please review the patch on detecting x2apic FADT settings?
>
> We meet a BIOS system which works on x2apic physical mode by setting the bit ACPI_FADT_APIC_PHYSICAL in FADT table.
> And for those systems with all cpuid < 255, the spec requires BIOS's default mode in xapic.
> The kernel detects the default mode and do some initializations and will call enable_IR_x2apic and change the mode to x2apic successfully.

Hi, Peter and Ingo,

I checked the patch, and looks right.

I updated the changelog and simplify the code a little bit.

Please check if you can put it into tip:x86/apic

Thanks

Yinghai

--20cf303ddba6baf5fc04d453ca01
Content-Type: application/octet-stream; name="wang_hp_x2apic.patch"
Content-Disposition: attachment; filename="wang_hp_x2apic.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hch9k4yg0

RnJvbToJU3RvbmV5IFdhbmcgPHNvbmctYm8ud2FuZ0BocC5jb20+ClN1YmplY3Q6IFtQQVRDSF0g
eDg2LCBhcGljOiBDaGVjayBmYWR0IHgyYXBpYyBwaHlzIGluIHgyYXBpY19waHlzX3Byb2JlKCkK
CkhQIGhhcyBzeXN0ZW1zIHRoYXQgd29yayB3aXRoIHgyYXBpYyBwaHlzIG1vZGUgYW5kIEJJT1Mg
c2V0CkFDUElfRkFEVF9BUElDX1BIWVNJQ0FMIGluIEZBRFQgdGFibGUsIGFuZCBhbGwgY3B1aWQg
PCAyNTUsIHRoZSBzcGVjCnJlcXVpcmVzIEJJT1Mgb25seSBwdXQgc3lzdGVtIG9uIHhhcGljIG1v
ZGUuCktlcm5lbCB3aWxsIHNldCB0byB4MmFwaWMgbG9naWNhbCBtb2RlIGluc3RlYWQgb2YgeDJh
cGljIHBoeXMgbW9kZS4KCkN1cnJlbnQgY29kZSBoYW5kbGUgeDJhcGljIGFzOgoxLiBCSU9TIHNl
dCB4MmFwaWMgbW9kZToKV2hlbiB1c2VyIHNwZWNpZnkgeDJhcGljX3BoeXMsIG9yIEZBRFQgaW5k
aWNhdGVzIFBIWVNJQ0FMLgpEdXJpbmcgbWFkdCBvZW0gY2hlY2ssIGFwaWMgZHJpdmVyIHdpbGwg
c2V0IGNvcnJlY3RseSB0byB4MmFwaWMgcGh5cyBkcml2ZXIuCgoyLiBCSU9TIGRvZXMgTk9UIHNl
dCB4MmFwaWMgbW9kZToKV2hlbiB1c2VyIHNwZWNpZnkgeDJhcGljX3BoeXMsIG9yIEZBRFQgaW5k
aWNhdGVzIFBIWVNJQ0FMLgpEdXJpbmcgbWFkdCBvZW0gY2hlY2ssIGFwaWMgZHJpdmVyIHdpbGwg
Z2V0IHNldCB3aXRoIHhhcGljIGxvZ2ljYWwgb3IKeGFwaWMgcGh5cyBkcml2ZXIgYXQgZmlyc3Qu
CkxhdGVyIGVuYWJsZV9JUl94MmFwaWMoKSB3aWxsIGVuYWJsZSB4MmFwaWNfbW9kZS4KQWZ0ZXIg
dGhhdCwgeDJhcGljX3BoeXNfcHJvYmUoKSBnZXQgY2FsbGVkLgpUaGF0IHdpbGwgaW5zdGFsbCBy
aWdodCB4MmFwaWMgcGh5c2ljYWwgZHJpdmVyIHdoZW4gdXNlciBzcGVjaWZ5IHgyYXBpY19waHlz
LApidXQgd2lsbCBpbnN0YWxsIHdyb25nIGFwaWMgZHJpdmVyICh4MmFwaWMgbG9naWNhbCkgd2hl
biBGQURUIGluZGljYXRlcwpQSFlTSUNBTCwgYmVjYXVzZSB0aGF0IHByb2JlIGRvZXMgbm90IGNo
ZWNrIEZBRFQgUEhZU0lDQUwuCgpGaXggdGhhdCBieSBhZGRpbmcgY2hlY2sgeDJhcGljX2ZhZHRf
cGh5cyBpbiB4MmFwaWNfcGh5c19wcm9iZSgpLgoKWyBjaGFuZ2Vsb2csIGFuZCBzaW1wbGlmeSBj
b2RlIC0gWWluZ2hhaSBMdSBdClNpZ25lZC1vZmYtYnk6IFN0b25leSBXYW5nIDxzb25nLWJvLndh
bmdAaHAuY29tPgpTaWduZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+
CgotLS0KIGFyY2gveDg2L2tlcm5lbC9hcGljL3gyYXBpY19waHlzLmMgfCAgIDE5ICsrKysrKysr
KystLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9u
cygtKQoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvYXBpYy94MmFwaWNfcGh5cy5j
Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5lbC9hcGljL3gyYXBp
Y19waHlzLmMKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvYXBpYy94MmFwaWNfcGh5cy5j
CkBAIC0yMCwxOCArMjAsMTkgQEAgc3RhdGljIGludCBzZXRfeDJhcGljX3BoeXNfbW9kZShjaGFy
ICphcgogfQogZWFybHlfcGFyYW0oIngyYXBpY19waHlzIiwgc2V0X3gyYXBpY19waHlzX21vZGUp
OwogCi1zdGF0aWMgaW50IHgyYXBpY19hY3BpX21hZHRfb2VtX2NoZWNrKGNoYXIgKm9lbV9pZCwg
Y2hhciAqb2VtX3RhYmxlX2lkKQorc3RhdGljIGludCB4MmFwaWNfZmFkdF9waHlzKHZvaWQpCiB7
Ci0JaWYgKHgyYXBpY19waHlzKQotCQlyZXR1cm4geDJhcGljX2VuYWJsZWQoKTsKLQllbHNlIGlm
ICgoYWNwaV9nYmxfRkFEVC5oZWFkZXIucmV2aXNpb24gPj0gRkFEVDJfUkVWSVNJT05fSUQpICYm
Ci0JCShhY3BpX2dibF9GQURULmZsYWdzICYgQUNQSV9GQURUX0FQSUNfUEhZU0lDQUwpICYmCi0J
CXgyYXBpY19lbmFibGVkKCkpIHsKKwlpZiAoKGFjcGlfZ2JsX0ZBRFQuaGVhZGVyLnJldmlzaW9u
ID49IEZBRFQyX1JFVklTSU9OX0lEKSAmJgorCQkoYWNwaV9nYmxfRkFEVC5mbGFncyAmIEFDUElf
RkFEVF9BUElDX1BIWVNJQ0FMKSkgewogCQlwcmludGsoS0VSTl9ERUJVRyAiU3lzdGVtIHJlcXVp
cmVzIHgyYXBpYyBwaHlzaWNhbCBtb2RlXG4iKTsKIAkJcmV0dXJuIDE7CiAJfQotCWVsc2UKLQkJ
cmV0dXJuIDA7CisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgeDJhcGljX2FjcGlfbWFkdF9v
ZW1fY2hlY2soY2hhciAqb2VtX2lkLCBjaGFyICpvZW1fdGFibGVfaWQpCit7CisJcmV0dXJuIHgy
YXBpY19lbmFibGVkKCkgJiYgKHgyYXBpY19waHlzIHx8IHgyYXBpY19mYWR0X3BoeXMoKSk7CiB9
CiAKIHN0YXRpYyB2b2lkCkBAIC04Miw3ICs4Myw3IEBAIHN0YXRpYyB2b2lkIGluaXRfeDJhcGlj
X2xkcih2b2lkKQogCiBzdGF0aWMgaW50IHgyYXBpY19waHlzX3Byb2JlKHZvaWQpCiB7Ci0JaWYg
KHgyYXBpY19tb2RlICYmIHgyYXBpY19waHlzKQorCWlmICh4MmFwaWNfbW9kZSAmJiAoeDJhcGlj
X3BoeXMgfHwgeDJhcGljX2ZhZHRfcGh5cygpKSkKIAkJcmV0dXJuIDE7CiAKIAlyZXR1cm4gYXBp
YyA9PSAmYXBpY194MmFwaWNfcGh5czsK
--20cf303ddba6baf5fc04d453ca01--
