Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaLEJUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 04:20:41 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47662 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaLEJUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 04:20:39 -0500
MIME-Version: 1.0
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
Date: Fri, 5 Dec 2014 13:20:37 +0400
Message-ID: <CALYGNiOuBKz8shHSrFCp0BT5AV6XkNOCHj+LJedQQ-2YdZtM7w@mail.gmail.com>
Subject: Re: [RFC] mm:add KPF_ZERO_PAGE flag for /proc/kpageflags
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>
Content-Type: multipart/mixed; boundary=047d7bfcfd4cfc5758050974963b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bfcfd4cfc5758050974963b
Content-Type: text/plain; charset=UTF-8

On Fri, Dec 5, 2014 at 11:57 AM, Wang, Yalin <Yalin.Wang@sonymobile.com> wrote:
> This patch add KPF_ZERO_PAGE flag for zero_page,
> so that userspace process can notice zero_page from
> /proc/kpageflags, and then do memory analysis more accurately.

It would be nice to mark also huge_zero_page. See (completely
untested) patch in attachment.

>
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> ---
>  fs/proc/page.c                         | 3 +++
>  include/uapi/linux/kernel-page-flags.h | 1 +
>  2 files changed, 4 insertions(+)
>
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 1e3187d..120dbf7 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -136,6 +136,9 @@ u64 stable_page_flags(struct page *page)
>         if (PageBalloon(page))
>                 u |= 1 << KPF_BALLOON;
>
> +       if (is_zero_pfn(page_to_pfn(page)))
> +               u |= 1 << KPF_ZERO_PAGE;
> +
>         u |= kpf_copy_bit(k, KPF_LOCKED,        PG_locked);
>
>         u |= kpf_copy_bit(k, KPF_SLAB,          PG_slab);
> diff --git a/include/uapi/linux/kernel-page-flags.h b/include/uapi/linux/kernel-page-flags.h
> index 2f96d23..a6c4962 100644
> --- a/include/uapi/linux/kernel-page-flags.h
> +++ b/include/uapi/linux/kernel-page-flags.h
> @@ -32,6 +32,7 @@
>  #define KPF_KSM                        21
>  #define KPF_THP                        22
>  #define KPF_BALLOON            23
> +#define KPF_ZERO_PAGE          24
>
>
>  #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
> --
> 2.1.3

--047d7bfcfd4cfc5758050974963b
Content-Type: application/octet-stream; name=kpageflags-zero-huge-page
Content-Disposition: attachment; filename=kpageflags-zero-huge-page
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3bcdl3g0

a3BhZ2VmbGFncy16ZXJvLWh1Z2UtcGFnZQoKRnJvbTogS29uc3RhbnRpbiBLaGVibmlrb3YgPGto
bGVibmlrb3ZAeWFuZGV4LXRlYW0ucnU+CgoKLS0tCiBmcy9wcm9jL3BhZ2UuYyAgICAgICAgICB8
ICAgMTIgKysrKysrKysrLS0tCiBpbmNsdWRlL2xpbnV4L2h1Z2VfbW0uaCB8ICAgMTIgKysrKysr
KysrKysrCiBtbS9odWdlX21lbW9yeS5jICAgICAgICB8ICAgIDcgKy0tLS0tLQogMyBmaWxlcyBj
aGFuZ2VkLCAyMiBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Zz
L3Byb2MvcGFnZS5jIGIvZnMvcHJvYy9wYWdlLmMKaW5kZXggMWUzMTg3ZC4uY2FkNWNkNCAxMDA2
NDQKLS0tIGEvZnMvcHJvYy9wYWdlLmMKKysrIGIvZnMvcHJvYy9wYWdlLmMKQEAgLTUsNiArNSw3
IEBACiAjaW5jbHVkZSA8bGludXgva3NtLmg+CiAjaW5jbHVkZSA8bGludXgvbW0uaD4KICNpbmNs
dWRlIDxsaW51eC9tbXpvbmUuaD4KKyNpbmNsdWRlIDxsaW51eC9odWdlX21tLmg+CiAjaW5jbHVk
ZSA8bGludXgvcHJvY19mcy5oPgogI2luY2x1ZGUgPGxpbnV4L3NlcV9maWxlLmg+CiAjaW5jbHVk
ZSA8bGludXgvaHVnZXRsYi5oPgpAQCAtMTIxLDkgKzEyMiwxNCBAQCB1NjQgc3RhYmxlX3BhZ2Vf
ZmxhZ3Moc3RydWN0IHBhZ2UgKnBhZ2UpCiAJICoganVzdCBjaGVja3MgUEdfaGVhZC9QR190YWls
LCBzbyB3ZSBuZWVkIHRvIGNoZWNrIFBhZ2VMUlUvUGFnZUFub24KIAkgKiB0byBtYWtlIHN1cmUg
YSBnaXZlbiBwYWdlIGlzIGEgdGhwLCBub3QgYSBub24taHVnZSBjb21wb3VuZCBwYWdlLgogCSAq
LwotCWVsc2UgaWYgKFBhZ2VUcmFuc0NvbXBvdW5kKHBhZ2UpICYmIChQYWdlTFJVKGNvbXBvdW5k
X2hlYWQocGFnZSkpIHx8Ci0JCQkJCSAgICAgUGFnZUFub24oY29tcG91bmRfaGVhZChwYWdlKSkp
KQotCQl1IHw9IDEgPDwgS1BGX1RIUDsKKwllbHNlIGlmIChQYWdlVHJhbnNDb21wb3VuZChwYWdl
KSkgeworCQlzdHJ1Y3QgcGFnZSAqaGVhZCA9IGNvbXBvdW5kX2hlYWQocGFnZSk7CisKKwkJaWYg
KFBhZ2VMUlUoaGVhZCkgfHwgUGFnZUFub24oaGVhZCkpCisJCQl1IHw9IDEgPDwgS1BGX1RIUDsK
KwkJZWxzZSBpZiAoaXNfaHVnZV96ZXJvX3BhZ2UoaGVhZCkpCisJCQl1IHw9IDEgPDwgS1BGX1pF
Uk9fUEFHRTsKKwl9CiAKIAkvKgogCSAqIENhdmVhdHMgb24gaGlnaCBvcmRlciBwYWdlczogcGFn
ZS0+X2NvdW50IHdpbGwgb25seSBiZSBzZXQKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvaHVn
ZV9tbS5oIGIvaW5jbHVkZS9saW51eC9odWdlX21tLmgKaW5kZXggYWQ5MDUxYi4uZjEwYjIwZiAx
MDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9odWdlX21tLmgKKysrIGIvaW5jbHVkZS9saW51eC9o
dWdlX21tLmgKQEAgLTE1Nyw2ICsxNTcsMTMgQEAgc3RhdGljIGlubGluZSBpbnQgaHBhZ2VfbnJf
cGFnZXMoc3RydWN0IHBhZ2UgKnBhZ2UpCiBleHRlcm4gaW50IGRvX2h1Z2VfcG1kX251bWFfcGFn
ZShzdHJ1Y3QgbW1fc3RydWN0ICptbSwgc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsCiAJCQkJ
dW5zaWduZWQgbG9uZyBhZGRyLCBwbWRfdCBwbWQsIHBtZF90ICpwbWRwKTsKIAorZXh0ZXJuIHN0
cnVjdCBwYWdlICpodWdlX3plcm9fcGFnZTsKKworc3RhdGljIGlubGluZSBib29sIGlzX2h1Z2Vf
emVyb19wYWdlKHN0cnVjdCBwYWdlICpwYWdlKQoreworCXJldHVybiBBQ0NFU1NfT05DRShodWdl
X3plcm9fcGFnZSkgPT0gcGFnZTsKK30KKwogI2Vsc2UgLyogQ09ORklHX1RSQU5TUEFSRU5UX0hV
R0VQQUdFICovCiAjZGVmaW5lIEhQQUdFX1BNRF9TSElGVCAoeyBCVUlMRF9CVUcoKTsgMDsgfSkK
ICNkZWZpbmUgSFBBR0VfUE1EX01BU0sgKHsgQlVJTERfQlVHKCk7IDA7IH0pCkBAIC0yMDYsNiAr
MjEzLDExIEBAIHN0YXRpYyBpbmxpbmUgaW50IGRvX2h1Z2VfcG1kX251bWFfcGFnZShzdHJ1Y3Qg
bW1fc3RydWN0ICptbSwgc3RydWN0IHZtX2FyZWFfc3RyCiAJcmV0dXJuIDA7CiB9CiAKK3N0YXRp
YyBpbmxpbmUgYm9vbCBpc19odWdlX3plcm9fcGFnZShzdHJ1Y3QgcGFnZSAqcGFnZSkKK3sKKwly
ZXR1cm4gZmFsc2U7Cit9CisKICNlbmRpZiAvKiBDT05GSUdfVFJBTlNQQVJFTlRfSFVHRVBBR0Ug
Ki8KIAogI2VuZGlmIC8qIF9MSU5VWF9IVUdFX01NX0ggKi8KZGlmZiAtLWdpdCBhL21tL2h1Z2Vf
bWVtb3J5LmMgYi9tbS9odWdlX21lbW9yeS5jCmluZGV4IGRlOTg0MTUuLmQ3YmM3YTUgMTAwNjQ0
Ci0tLSBhL21tL2h1Z2VfbWVtb3J5LmMKKysrIGIvbW0vaHVnZV9tZW1vcnkuYwpAQCAtMTcxLDEy
ICsxNzEsNyBAQCBzdGF0aWMgaW50IHN0YXJ0X2todWdlcGFnZWQodm9pZCkKIH0KIAogc3RhdGlj
IGF0b21pY190IGh1Z2VfemVyb19yZWZjb3VudDsKLXN0YXRpYyBzdHJ1Y3QgcGFnZSAqaHVnZV96
ZXJvX3BhZ2UgX19yZWFkX21vc3RseTsKLQotc3RhdGljIGlubGluZSBib29sIGlzX2h1Z2VfemVy
b19wYWdlKHN0cnVjdCBwYWdlICpwYWdlKQotewotCXJldHVybiBBQ0NFU1NfT05DRShodWdlX3pl
cm9fcGFnZSkgPT0gcGFnZTsKLX0KK3N0cnVjdCBwYWdlICpodWdlX3plcm9fcGFnZSBfX3JlYWRf
bW9zdGx5OwogCiBzdGF0aWMgaW5saW5lIGJvb2wgaXNfaHVnZV96ZXJvX3BtZChwbWRfdCBwbWQp
CiB7Cg==
--047d7bfcfd4cfc5758050974963b--
