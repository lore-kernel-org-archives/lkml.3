Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab3BWBjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 20:39:13 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:52103 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3BWBjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 20:39:12 -0500
MIME-Version: 1.0
In-Reply-To: <20130223012716.GA28377@phenom.dumpdata.com>
References: <CAE9FiQX5r02Prsw-f0HsgLVJ0FZeYL9aggXebwWR-E5oYsj6cw@mail.gmail.com>
	<5127C620.2040605@linux.intel.com>
	<alpine.DEB.2.02.1302221929040.22997@kaball.uk.xensource.com>
	<5127CE65.5010703@linux.intel.com>
	<CAE9FiQXHHFb0W+aJCsefRNj4p+X1+m8JOLUDz74w-nAjnhym+A@mail.gmail.com>
	<5127DDB3.2010309@zytor.com>
	<CAE9FiQWctM60VwXJYtOXwPBNLUoz966Fr1g6MPsPoJBiye88YQ@mail.gmail.com>
	<5127FBA4.1040506@zytor.com>
	<20130223003738.GA23545@phenom.dumpdata.com>
	<CAE9FiQVTbDkvU8KQGVoYv3kn6UeCTcdiPA2hvw21OKtNbM=XKg@mail.gmail.com>
	<20130223012716.GA28377@phenom.dumpdata.com>
Date: Fri, 22 Feb 2013 17:39:11 -0800
X-Google-Sender-Auth: oK4S3o7A9z15DIVOK6WuGEjowNU
Message-ID: <CAE9FiQUcJiDOjv-XYYUfQAAHaZCq2Q1heR5YakGf13SYJjxyxA@mail.gmail.com>
Subject: Re: [GIT PULL] x86/mm changes for v3.9-rc1
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d044788d9ed038304d65a5f4b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d044788d9ed038304d65a5f4b
Content-Type: text/plain; charset=ISO-8859-1

[ trim cc list]

On Fri, Feb 22, 2013 at 5:27 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> >  static int xen_pgd_alloc(struct mm_struct *mm)
>> >  {
>> >         pgd_t *pgd = mm->pgd;
>> > @@ -2105,7 +2143,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
>> >  #ifdef CONFIG_X86_32
>> >         .write_cr3 = xen_write_cr3_init,
>> >  #else
>> > -       .write_cr3 = xen_write_cr3,
>> > +       .write_cr3 = xen_write_cr3_init,
>> >  #endif
>>
>> ah, why do you still keep the #ifdef here?
>>
>> how about if we call load_cr3 early several times?
>> assume you should make xen_write_cr3 more robust,
>> like bailing out early when cr3 writing same value.
>
> I would welcome such patch - but at this point I just want a
> patch for Linus so that I am not blocking him - and this
> one works.

come on, you produce

  #ifdef CONFIG_X86_32
         .write_cr3 = xen_write_cr3_init,
  #else
         .write_cr3 = xen_write_cr3_init,
  #endif

for the fix, Linus should just apply attached patch instead.

>>
>> Also you should check condition about calling xen_get_user_pgd().
>
> Could you elaborate please?

only call xen_get_user_pgd() when it should be called.

Yinghai

--f46d044788d9ed038304d65a5f4b
Content-Type: application/octet-stream; name="fix_xen_cr3.patch"
Content-Disposition: attachment; filename="fix_xen_cr3.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdi3np5k0

LS0tCiBhcmNoL3g4Ni9tbS9pbml0LmMgfCAgICAzICsrLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9tbS9p
bml0LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvbW0vaW5pdC5jCisr
KyBsaW51eC0yLjYvYXJjaC94ODYvbW0vaW5pdC5jCkBAIC00NDgsNyArNDQ4LDggQEAgdm9pZCBf
X2luaXQgaW5pdF9tZW1fbWFwcGluZyh2b2lkKQogCWVhcmx5X2lvcmVtYXBfcGFnZV90YWJsZV9y
YW5nZV9pbml0KCk7CiAjZW5kaWYKIAotCWxvYWRfY3IzKHN3YXBwZXJfcGdfZGlyKTsKKwlpZiAo
cmVhZF9jcjMoKSAhPSBfX3BhKHN3YXBwZXJfcGdfZGlyKSkKKwkJbG9hZF9jcjMoc3dhcHBlcl9w
Z19kaXIpOwogCV9fZmx1c2hfdGxiX2FsbCgpOwogCiAJZWFybHlfbWVtdGVzdCgwLCBtYXhfcGZu
X21hcHBlZCA8PCBQQUdFX1NISUZUKTsK
--f46d044788d9ed038304d65a5f4b--
