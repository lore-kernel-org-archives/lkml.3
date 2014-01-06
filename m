Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbaAFWap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:30:45 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:57492 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaAFWam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:30:42 -0500
MIME-Version: 1.0
In-Reply-To: <20140103212413.GA18987@google.com>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
	<1388707565-16535-25-git-send-email-yinghai@kernel.org>
	<20140103212413.GA18987@google.com>
Date: Mon, 6 Jan 2014 14:30:41 -0800
X-Google-Sender-Auth: EjLUoG3NpLS2ohrL01-huCvmK2E
Message-ID: <CAE9FiQU2SEj7L=pjtTOewxExKJhoG3LbJ+YsVbNJ2O_9Kevz5A@mail.gmail.com>
Subject: Re: [PATCH v5 24/33] x86: Move declaration for mp_register_ioapic()
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiang Liu <jiang.liu@huawei.com>
Content-Type: multipart/mixed; boundary=001a1134c7925c25b304ef54cf8b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a1134c7925c25b304ef54cf8b
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Jan 3, 2014 at 1:24 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, Jan 02, 2014 at 04:05:56PM -0800, Yinghai Lu wrote:
>> Address compiling problem that Fengguang report.
>
> Does this fix a problem that's already in the upstream tree?
>
> If it merely fixes a problem that was added somewhere in your patches,
> why don't you fold this fix into the patch that added the problem?
>
> If you included more details, like the exact problem report, I could
> probably have figured this out myself.

please check updated changelog:

---
Subject: [PATCH] x86: Move declaration for mp_register_ioapic()

Preparing patch for ioapic hotplug:
        PCI, x86, ACPI: Link acpi ioapic register to ioapic
as it adds calling in
        arch/x86/kernel/acpi/boot.c::acpi_register_ioapic()
                                     acpi_unregister_ioapic()

Address compiling problem when
 CONFIG_ACPI is defined
 CONFIG_X86_IOAPIC is not defined.

Change condition to X86_IO_APIC instead of ACPI.

-v2: update changelog requested by Bjorn.

-----

--001a1134c7925c25b304ef54cf8b
Content-Type: text/x-patch; charset=US-ASCII; name="move_mp_register.patch"
Content-Disposition: attachment; filename="move_mp_register.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hq4as3vf0

U3ViamVjdDogW1BBVENIXSB4ODY6IE1vdmUgZGVjbGFyYXRpb24gZm9yIG1wX3JlZ2lzdGVyX2lv
YXBpYygpCgpQcmVwYXJpbmcgcGF0Y2ggZm9yIGlvYXBpYyBob3RwbHVnOgoJUENJLCB4ODYsIEFD
UEk6IExpbmsgYWNwaSBpb2FwaWMgcmVnaXN0ZXIgdG8gaW9hcGljCmFzIGl0IGFkZHMgY2FsbGlu
ZyBpbgoJYXJjaC94ODYva2VybmVsL2FjcGkvYm9vdC5jOjphY3BpX3JlZ2lzdGVyX2lvYXBpYygp
CgkJCQkgICAgIGFjcGlfdW5yZWdpc3Rlcl9pb2FwaWMoKQoKQWRkcmVzcyBjb21waWxpbmcgcHJv
YmxlbSB3aGVuCiBDT05GSUdfQUNQSSBpcyBkZWZpbmVkCiBDT05GSUdfWDg2X0lPQVBJQyBpcyBu
b3QgZGVmaW5lZC4KCkNoYW5nZSBjb25kaXRpb24gdG8gWDg2X0lPX0FQSUMgaW5zdGVhZCBvZiBB
Q1BJLgoKLXYyOiB1cGRhdGUgY2hhbmdlbG9nIHJlcXVlc3RlZCBieSBCam9ybi4KClJlcG9ydGVk
LWJ5OiBGZW5nZ3VhbmcgV3UgPHdmZ0BsaW51eC5pbnRlbC5jb20+ClNpZ25lZC1vZmYtYnk6IFlp
bmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KQ2M6IFBhdWwgR29ydG1ha2VyIDxwYXVsLmdv
cnRtYWtlckB3aW5kcml2ZXIuY29tPgpDYzogSmlhbmcgTGl1IDxqaWFuZy5saXVAaHVhd2VpLmNv
bT4KCi0tLQogYXJjaC94ODYvaW5jbHVkZS9hc20vaW9fYXBpYy5oIHwgICAgMSAtCiBhcmNoL3g4
Ni9pbmNsdWRlL2FzbS9tcHNwZWMuaCAgfCAgIDE4ICsrKysrKysrKysrKysrKysrLQogMiBmaWxl
cyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4
LTIuNi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tcHNwZWMuaAo9PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0y
LjYub3JpZy9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tcHNwZWMuaAorKysgbGludXgtMi42L2FyY2gv
eDg2L2luY2x1ZGUvYXNtL21wc3BlYy5oCkBAIC05NSwxMCArOTUsMjYgQEAgc3RhdGljIGlubGlu
ZSB2b2lkIGVhcmx5X3Jlc2VydmVfZTgyMF9tcAogI2VuZGlmCiAKIGludCBnZW5lcmljX3Byb2Nl
c3Nvcl9pbmZvKGludCBhcGljaWQsIGludCB2ZXJzaW9uKTsKLSNpZmRlZiBDT05GSUdfQUNQSQor
I2lmZGVmIENPTkZJR19YODZfSU9fQVBJQwogaW50IF9fbXBfcmVnaXN0ZXJfaW9hcGljKGludCBp
ZCwgdTMyIGFkZHJlc3MsIHUzMiBnc2lfYmFzZSwgYm9vbCBob3QpOwogaW50IG1wX3VucmVnaXN0
ZXJfaW9hcGljKHUzMiBnc2lfYmFzZSk7CiBleHRlcm4gdm9pZCBtcF9yZWdpc3Rlcl9pb2FwaWMo
aW50IGlkLCB1MzIgYWRkcmVzcywgdTMyIGdzaV9iYXNlKTsKKyNlbHNlCitzdGF0aWMgaW5saW5l
IGludCBfX21wX3JlZ2lzdGVyX2lvYXBpYyhpbnQgaWQsIHUzMiBhZGRyZXNzLCB1MzIgZ3NpX2Jh
c2UsCisJCQkJCSBib29sIGhvdCkKK3sKKwlyZXR1cm4gMDsKK30KK3N0YXRpYyBpbmxpbmUgaW50
IG1wX3VucmVnaXN0ZXJfaW9hcGljKHUzMiBnc2lfYmFzZSkKK3sKKwlyZXR1cm4gMDsKK30KK3N0
YXRpYyBpbmxpbmUgdm9pZCBtcF9yZWdpc3Rlcl9pb2FwaWMoaW50IGlkLCB1MzIgYWRkcmVzcywg
dTMyIGdzaV9iYXNlKQoreworfQorI2VuZGlmCisKKyNpZmRlZiBDT05GSUdfQUNQSQogZXh0ZXJu
IHZvaWQgbXBfb3ZlcnJpZGVfbGVnYWN5X2lycSh1OCBidXNfaXJxLCB1OCBwb2xhcml0eSwgdTgg
dHJpZ2dlciwKIAkJCQkgICB1MzIgZ3NpKTsKIGV4dGVybiB2b2lkIG1wX2NvbmZpZ19hY3BpX2xl
Z2FjeV9pcnFzKHZvaWQpOwpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2luY2x1ZGUvYXNtL2lv
X2FwaWMuaAo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9pb19hcGljLmgKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9pb19hcGljLmgK
QEAgLTE4OSw3ICsxODksNiBAQCBleHRlcm4gdTMyIGdzaV90b3A7CiBpbnQgaW9hcGljX2dzaV90
b19pcnEodTMyIGdzaSk7CiBpbnQgbXBfZmluZF9pb2FwaWModTMyIGdzaSk7CiBpbnQgbXBfZmlu
ZF9pb2FwaWNfcGluKGludCBpb2FwaWMsIHUzMiBnc2kpOwotdm9pZCBfX2luaXQgbXBfcmVnaXN0
ZXJfaW9hcGljKGludCBpZCwgdTMyIGFkZHJlc3MsIHUzMiBnc2lfYmFzZSk7CiBleHRlcm4gdm9p
ZCBfX2luaXQgcHJlX2luaXRfYXBpY19JUlEwKHZvaWQpOwogCiBleHRlcm4gdm9pZCBtcF9zYXZl
X2lycShzdHJ1Y3QgbXBjX2ludHNyYyAqbSk7Cg==
--001a1134c7925c25b304ef54cf8b--
