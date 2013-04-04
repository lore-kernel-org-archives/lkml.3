Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764304Ab3DDUDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:03:19 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:57773 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761013Ab3DDUDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:03:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130404182742.GU9425@htj.dyndns.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
	<1362897887-30808-7-git-send-email-yinghai@kernel.org>
	<20130404182742.GU9425@htj.dyndns.org>
Date: Thu, 4 Apr 2013 13:03:15 -0700
X-Google-Sender-Auth: RQ1eN9W6Yb_a1jXmchmhpCfLhRA
Message-ID: <CAE9FiQU2WPpgMxvRDvKZtbo5QfDf55Ar2pxjEMd-XA+L7ZF8Tg@mail.gmail.com>
Subject: Re: [PATCH v2 06/20] x86, ACPI: Store override acpi tables phys addr
 in cpio files info array
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b3a9ad208ae1804d98e7696
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b3a9ad208ae1804d98e7696
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Apr 4, 2013 at 11:27 AM, Tejun Heo <tj@kernel.org> wrote:
>>       for (no = 0; no < ACPI_OVERRIDE_TABLES; no++) {
>> +             /*
>> +              * have to use unsigned long, otherwise 32bit spit warning
>> +              * and it is ok to unsigned long, as bootloader would not
>> +              * load initrd above 4G for 32bit kernel.
>> +              */
>> +             unsigned long addr = (unsigned long)acpi_initrd_files[no].data;
>
> I can't say I like this.  It's stuffing phys_addr_t into void *.  It
> might work okay but the code is a bit misleading / confusing.  "void
> *" shouldn't contain a physical address.  Maybe the alternatives are
> uglier, I don't know.  If you can think of a reasonable way to not do
> this, it would be great.

Please check if you are happy with attached.

-v2: introduce file_pos to save phys address instead of abusing cpio_data
        that tj is not happy with.

--047d7b3a9ad208ae1804d98e7696
Content-Type: application/octet-stream; name="fix_acpi_override_2.patch"
Content-Disposition: attachment; filename="fix_acpi_override_2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hf4cpuwl0

U3ViamVjdDogW1BBVENIXSB4ODYsIEFDUEk6IFN0b3JlIG92ZXJyaWRlIGFjcGkgdGFibGVzIHBo
eXMgYWRkciBpbiBjcGlvIGZpbGVzIGluZm8gYXJyYXkKCkluIDMyYml0IHdlIHdpbGwgZmluZCB0
YWJsZSB3aXRoIHBoeXMgYWRkcmVzcyBkdXJpbmcgMzJiaXQgZmxhdCBtb2RlCmluIGhlYWRfMzIu
UywgYmVjYXVzZSBhdCB0aGF0IHRpbWUgd2UgZG9uJ3QgbmVlZCBzZXQgcGFnZSB0YWJsZSB0bwph
Y2Nlc3MgaW5pdHJkLgoKRm9yIGNvcHlpbmcgd2UgY291bGQgdXNlIGVhcmx5X2lvcmVtYXAoKSB3
aXRoIHBoeXMgZGlyZWN0bHkgYmVmb3JlIG1lbSBtYXBwaW5nCmlzIHNldC4KClRvIGtlZXAgMzJi
aXQgYW5kIDY0Yml0IGNvbnNpc3RlbnQsIHVzZSBwaHlzX2FkZHIgZm9yIGFsbC4KCi12MjogaW50
cm9kdWNlIGZpbGVfcG9zIHRvIHNhdmUgcGh5cyBhZGRyZXNzIGluc3RlYWQgb2YgYWJ1c2luZyBj
cGlvX2RhdGEKCXRoYXQgdGogaXMgbm90IGhhcHB5IHdpdGguCgpTaWduZWQtb2ZmLWJ5OiBZaW5n
aGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+CkNjOiBSYWZhZWwgSi4gV3lzb2NraSA8cmp3QHNp
c2sucGw+CkNjOiBsaW51eC1hY3BpQHZnZXIua2VybmVsLm9yZwoKLS0tCiBkcml2ZXJzL2FjcGkv
b3NsLmMgfCAgIDE1ICsrKysrKysrKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlv
bnMoKyksIDQgZGVsZXRpb25zKC0pCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvYWNwaS9vc2wu
Ywo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL2FjcGkvb3NsLmMKKysrIGxp
bnV4LTIuNi9kcml2ZXJzL2FjcGkvb3NsLmMKQEAgLTU3MCw3ICs1NzAsMTEgQEAgc3RhdGljIGNv
bnN0IGNoYXIgKiBjb25zdCB0YWJsZV9zaWdzW10gPQogI2RlZmluZSBBQ1BJX0hFQURFUl9TSVpF
IHNpemVvZihzdHJ1Y3QgYWNwaV90YWJsZV9oZWFkZXIpCiAKICNkZWZpbmUgQUNQSV9PVkVSUklE
RV9UQUJMRVMgNjQKLXN0YXRpYyBzdHJ1Y3QgY3Bpb19kYXRhIF9faW5pdGRhdGEgYWNwaV9pbml0
cmRfZmlsZXNbQUNQSV9PVkVSUklERV9UQUJMRVNdOworc3RydWN0IGZpbGVfcG9zIHsKKwlwaHlz
X2FkZHJfdCBkYXRhOworCXBoeXNfYWRkcl90IHNpemU7Cit9Oworc3RhdGljIHN0cnVjdCBmaWxl
X3BvcyBfX2luaXRkYXRhIGFjcGlfaW5pdHJkX2ZpbGVzW0FDUElfT1ZFUlJJREVfVEFCTEVTXTsK
IAogdm9pZCBfX2luaXQgYWNwaV9pbml0cmRfb3ZlcnJpZGVfZmluZCh2b2lkICpkYXRhLCBzaXpl
X3Qgc2l6ZSkKIHsKQEAgLTYxNSw3ICs2MTksNyBAQCB2b2lkIF9faW5pdCBhY3BpX2luaXRyZF9v
dmVycmlkZV9maW5kKHZvCiAJCQl0YWJsZS0+c2lnbmF0dXJlLCBjcGlvX3BhdGgsIGZpbGUubmFt
ZSwgdGFibGUtPmxlbmd0aCk7CiAKIAkJYWxsX3RhYmxlc19zaXplICs9IHRhYmxlLT5sZW5ndGg7
Ci0JCWFjcGlfaW5pdHJkX2ZpbGVzW3RhYmxlX25yXS5kYXRhID0gZmlsZS5kYXRhOworCQlhY3Bp
X2luaXRyZF9maWxlc1t0YWJsZV9ucl0uZGF0YSA9IF9fcGFfbm9kZWJ1ZyhmaWxlLmRhdGEpOwog
CQlhY3BpX2luaXRyZF9maWxlc1t0YWJsZV9ucl0uc2l6ZSA9IGZpbGUuc2l6ZTsKIAkJdGFibGVf
bnIrKzsKIAl9CkBAIC02MjQsNyArNjI4LDcgQEAgdm9pZCBfX2luaXQgYWNwaV9pbml0cmRfb3Zl
cnJpZGVfZmluZCh2bwogdm9pZCBfX2luaXQgYWNwaV9pbml0cmRfb3ZlcnJpZGVfY29weSh2b2lk
KQogewogCWludCBubywgdG90YWxfb2Zmc2V0ID0gMDsKLQljaGFyICpwOworCWNoYXIgKnAsICpx
OwogCiAJaWYgKCFhbGxfdGFibGVzX3NpemUpCiAJCXJldHVybjsKQEAgLTY1OSwxMiArNjYzLDE1
IEBAIHZvaWQgX19pbml0IGFjcGlfaW5pdHJkX292ZXJyaWRlX2NvcHkodm8KIAkgKiBvbmUgYnkg
b25lIGR1cmluZyBjb3B5aW5nLgogCSAqLwogCWZvciAobm8gPSAwOyBubyA8IEFDUElfT1ZFUlJJ
REVfVEFCTEVTOyBubysrKSB7CisJCXBoeXNfYWRkcl90IGFkZHIgPSBhY3BpX2luaXRyZF9maWxl
c1tub10uZGF0YTsKIAkJcGh5c19hZGRyX3Qgc2l6ZSA9IGFjcGlfaW5pdHJkX2ZpbGVzW25vXS5z
aXplOwogCiAJCWlmICghc2l6ZSkKIAkJCWJyZWFrOworCQlxID0gZWFybHlfaW9yZW1hcChhZGRy
LCBzaXplKTsKIAkJcCA9IGVhcmx5X2lvcmVtYXAoYWNwaV90YWJsZXNfYWRkciArIHRvdGFsX29m
ZnNldCwgc2l6ZSk7Ci0JCW1lbWNweShwLCBhY3BpX2luaXRyZF9maWxlc1tub10uZGF0YSwgc2l6
ZSk7CisJCW1lbWNweShwLCBxLCBzaXplKTsKKwkJZWFybHlfaW91bm1hcChxLCBzaXplKTsKIAkJ
ZWFybHlfaW91bm1hcChwLCBzaXplKTsKIAkJdG90YWxfb2Zmc2V0ICs9IHNpemU7CiAJfQo=
--047d7b3a9ad208ae1804d98e7696--
