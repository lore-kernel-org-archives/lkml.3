Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3AOEpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:45:47 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:59267 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3AOEpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:45:45 -0500
MIME-Version: 1.0
In-Reply-To: <1824463.EWDqkMLC4N@hammer82.arch.suse.de>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
	<201301141605.43428.trenn@suse.de>
	<CAE9FiQVQvj1TPokoCgx_jbp0VACC8cgtFibH4KoqOssEc6JSPw@mail.gmail.com>
	<1824463.EWDqkMLC4N@hammer82.arch.suse.de>
Date: Mon, 14 Jan 2013 20:45:43 -0800
X-Google-Sender-Auth: PRn2oCOzgO6c2Xs04Dq66t50Zzc
Message-ID: <CAE9FiQUgqRLO4O4HFBC_D5o8TQhnouEaDNq82wdwuu57=OsoZQ@mail.gmail.com>
Subject: Re: [PATCH] x86 e820: only void usable memory areas in
 memmap=exactmap case
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org, horms@verge.net.au
Content-Type: multipart/mixed; boundary=00151750e4c039d07904d34c6f6d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151750e4c039d07904d34c6f6d
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Jan 14, 2013 at 4:54 PM, Thomas Renninger <trenn@suse.de> wrote:
> On Monday, January 14, 2013 11:04:36 AM Yinghai Lu wrote:
>> On Mon, Jan 14, 2013 at 7:05 AM, Thomas Renninger <trenn@suse.de> wrote:
>> > What is this for?:
>> > @@ -871,6 +879,11 @@ static int __init parse_memmap_one(char
>> >
>> >         userdef = 1;
>> >         if (*p == '@') {
>> >
>> >                 start_at = memparse(p+1, &p);
>> >
>> > +               if (exactusablemap_parsed) {
>> > +                       /* remove all range with other types */
>> > +                       e820_remove_range(start_at, mem_size,
>> > +                                                E820_RAM, 0);
>> > +               }
>> >
>> >                 e820_add_region(start_at, mem_size, E820_RAM);
>> >
>> >         } else if (*p == '#') {
>> >
>> >                 start_at = memparse(p+1, &p);
>>
>> remove all old renges before add E820_RAM, otherwise new add E820
>> ranges could be ignored.
> But this is intended?
> kexec must never request reserved memory to be used as ordinary E820_RAM
> by the kdump kernel.
> This also reverts what exactusablemap is all about:
> Keep all reserved memory ranges of the original BIOS map.
>
> Above would again wrongly remove the mmconf and other reserved regions
> if kexec passes memmap=exactuseablemap,x@y
>
> From what I can see the patch looks fine, but above part should
> simply be left out.

then, I would like to rename it to resetusablemap instead.

like attached.

Thanks

Yinghai

--00151750e4c039d07904d34c6f6d
Content-Type: application/octet-stream; name="e820_resetusablemap.patch"
Content-Disposition: attachment; filename="e820_resetusablemap.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hbyk694g0

LS0tCiBhcmNoL3g4Ni9rZXJuZWwvZTgyMC5jIHwgICAxMyArKysrKysrKysrKy0tCiAxIGZpbGUg
Y2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51eC0y
LjYvYXJjaC94ODYva2VybmVsL2U4MjAuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9h
cmNoL3g4Ni9rZXJuZWwvZTgyMC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2U4MjAu
YwpAQCAtODQ1LDcgKzg0NSw3IEBAIHN0YXRpYyBpbnQgX19pbml0IHBhcnNlX21lbW1hcF9vbmUo
Y2hhcgogCWlmICghcCkKIAkJcmV0dXJuIC1FSU5WQUw7CiAKLQlpZiAoIXN0cm5jbXAocCwgImV4
YWN0bWFwIiwgOCkpIHsKKwlpZiAoIXN0cm5jbXAocCwgImV4YWN0bWFwIiwgOCkgfHwgIXN0cm5j
bXAocCwgInJlc2V0dXNhYmxlbWFwIiwgMTQpKSB7CiAJCWlmIChleGFjdG1hcF9wYXJzZWQpCiAJ
CQlyZXR1cm4gMDsKIApAQCAtODU4LDcgKzg1OCwxMSBAQCBzdGF0aWMgaW50IF9faW5pdCBwYXJz
ZV9tZW1tYXBfb25lKGNoYXIKIAkJICovCiAJCXNhdmVkX21heF9wZm4gPSBlODIwX2VuZF9vZl9y
YW1fcGZuKCk7CiAjZW5kaWYKLQkJZTgyMC5ucl9tYXAgPSAwOworCQlpZiAoIXN0cm5jbXAocCwg
InJlc2V0dXNhYmxlbWFwIiwgMTQpKSB7CisJCQkvKiByZW1vdmUgYWxsIG9sZCBFODIwX1JBTSBy
YW5nZXMgKi8KKwkJCWU4MjBfcmVtb3ZlX3JhbmdlKDAsIFVMTE9OR19NQVgsIEU4MjBfUkFNLCAx
KTsKKwkJfSBlbHNlCisJCQllODIwLm5yX21hcCA9IDA7CiAJCXVzZXJkZWYgPSAxOwogCQlyZXR1
cm4gMDsKIAl9CkBAIC04OTAsNiArODk0LDExIEBAIHN0YXRpYyBpbnQgX19pbml0IHBhcnNlX21l
bW1hcF9vcHQoY2hhcgogCXAgPSBzdHJzdHIocCwgImV4YWN0bWFwIik7CiAJaWYgKHApCiAJCXBh
cnNlX21lbW1hcF9vbmUoImV4YWN0bWFwIik7CisJZWxzZSB7CisJCXAgPSBzdHJzdHIoYm9vdF9j
b21tYW5kX2xpbmUsICJyZXNldHVzYWJsZW1hcCIpOworCQlpZiAocCkKKwkJCXBhcnNlX21lbW1h
cF9vbmUoInJlc2V0dXNhYmxlbWFwIik7CisJfQogCiAJd2hpbGUgKHN0cikgewogCQljaGFyICpr
ID0gc3RyY2hyKHN0ciwgJywnKTsK
--00151750e4c039d07904d34c6f6d--
