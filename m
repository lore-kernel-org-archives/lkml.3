Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714Ab3GDIku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:40:50 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38125 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933435Ab3GDIkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:40:46 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUV8Nw2eY7aJg0qSCmg+Pk_EdRT2joUqxiL8y77rUsBGHg@mail.gmail.com>
References: <20130704160652.4f76f0ee43877a6e726d6c8b@canb.auug.org.au>
	<CA+icZUXchb2H=ZZ0Zv+vA43x0CNVSbLvPptawnBR+OUpOzqP6A@mail.gmail.com>
	<CA+icZUV8Nw2eY7aJg0qSCmg+Pk_EdRT2joUqxiL8y77rUsBGHg@mail.gmail.com>
Date: Thu, 4 Jul 2013 10:40:44 +0200
Message-ID: <CA+icZUVdfmmUSTFHmjr7uym59WNQE=YPwJU8cw9rVXMw9O13TQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 4
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary=001a11c24c64bd307604e0ab88c8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c24c64bd307604e0ab88c8
Content-Type: text/plain; charset=UTF-8

On Thu, Jul 4, 2013 at 10:21 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, Jul 4, 2013 at 9:41 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Thu, Jul 4, 2013 at 8:06 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> Hi all,
>>>
>>> Changes since 20130703:
>>>
>>> The net-next tree lost its build failure.
>>>
>>> The akpm tree gained a conflict against the kbuild tree and lost lots of
>>> patches that turned up elsewhere.
>>>
>>> ----------------------------------------------------------------------------
>>>
>>
>> Just FYI:
>> People building with "CONFIG_MEMCG_KMEM=n" (still) need an extra patch
>> pending in mmots-tree [1].
>> ( Unfortunately, it does not cleanly apply against next-20130704. )
>>
>
> I have compared both mm/memcontrol.c files from
> next-20130703/next-20130704 - they are identical.
>
> These hunks...
>
> [ From Li Zefan ]
> @@ -6332,8 +6341,7 @@ static void mem_cgroup_css_free(struct cgroup *cont)
>  {
>         struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
>
> -       mem_cgroup_sockets_destroy(memcg);
> -
> +       memcg_destroy_kmem(memcg);
>         __mem_cgroup_free(memcg);
>  }
>
> [ From mmots ]
> @@ -6399,8 +6408,7 @@ static void mem_cgroup_css_free(struct c
>  {
>         struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
>
> -       mem_cgroup_sockets_destroy(memcg);
> -
> +       memcg_destroy_kmem(memcg);
>         mem_cgroup_put(memcg);
>  }
>
> ...seems to differ.
>
> In both mentioned -next releases there exist no mem_cgroup_put() in
> mm/memcontrol.c.
> So the hunk in mmots seems to be wrong in my eyes.
>
> Andrew? ^^^
>

Attached v2 patch applies against next-20130704.

- Sedat -

> - Sedat -
>
>> - Sedat -
>>
>> [1] http://ozlabs.org/~akpm/mmots/broken-out/memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix.patch

--001a11c24c64bd307604e0ab88c8
Content-Type: application/octet-stream; 
	name="memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix-v2.patch"
Content-Disposition: attachment; 
	filename="memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hippf1qw0

RnJvbTogTGkgWmVmYW4gPGxpemVmYW5AaHVhd2VpLmNvbT4KU3ViamVjdDogbWVtY2c6IGZpeCBi
dWlsZCBlcnJvciBpZiBDT05GSUdfTUVNQ0dfS01FTT1uCgpGaXggdGhpcyBidWlsZCBlcnJvcjoK
Cm1tL2J1aWx0LWluLm86IEluIGZ1bmN0aW9uIGBtZW1fY2dyb3VwX2Nzc19mcmVlJzoKbWVtY29u
dHJvbC5jOigudGV4dCsweDVjYWE2KTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byAnbWVtX2Nncm91
cF9zb2NrZXRzX2Rlc3Ryb3knCgpNYXliZSBpdCdzIGJldHRlciB0byBhZGQgbWVtY2dfZGVzdHJv
eV9rbWVtKCksIHRvIHBhaXIgd2l0aCBtZW1jZ19pbml0X2ttZW0oKS4KClRoaXMgcGF0Y2ggY2Fu
IGJlIGZvbGRlZCBpbnRvICJtZW1jZzogdXNlIGNzc19nZXQvcHV0IHdoZW4gY2hhcmdpbmcvdW5j
aGFyZ2luZyBrbWVtIi4KClJlbmFtZSB0aGUgcGF0Y2ggYXMgaXQgaXMgYSBmb2xsb3ctdXAgZm9y
IHRoZSBtbW90bSB0cmVlOgoibWVtY2ctdXNlLWNzc19nZXQtcHV0LXdoZW4tY2hhcmdpbmctdW5j
aGFyZ2luZy1rbWVtLWZpeC1maXgucGF0Y2giCgpTZWUgWzFdIGZvciB0aGUgb3JpZ2luYWwgcGF0
Y2ggYW5kIGZvbGxvdyB0aGUgZGlzY3Vzc2lvbiBpbiBbMl0uCgpbMV0gaHR0cDovL21hcmMuaW5m
by8/bD1saW51eC1tbSZtPTEzNzI4NTU5MDEyMzQzMCZ3PTIKWzJdIGh0dHA6Ly9tYXJjLmluZm8v
P3Q9MTM3Mjg1Mzc4NTAwMDA1JnI9MSZ3PTIKClJlcG9ydGVkLWJ5OiBGZW5nZ3VhbmcgV3UgPGZl
bmdndWFuZy53dUBpbnRlbC5jb20+ClJlcG9ydGVkLWJ5OiBTdGVwaGVuIFJvdGh3ZWxsIDxzZnJA
Y2FuYi5hdXVnLm9yZy5hdT4KUmVwb3J0ZWQtYnk6IFNlZGF0IERpbGVrIDxzZWRhdC5kaWxla0Bn
bWFpbC5jb20+ClRlc3RlZC1ieTogU2VkYXQgRGlsZWsgPHNlZGF0LmRpbGVrQGdtYWlsLmNvbT4K
QWNrZWQtYnk6IE1pY2hhbCBIb2NrbyA8bWhvY2tvQHN1c2UuY3o+ClNpZ25lZC1vZmYtYnk6IExp
IFplZmFuIDxsaXplZmFuQGh1YXdlaS5jb20+ClNpZ25lZC1vZmYtYnk6IEFuZHJldyBNb3J0b24g
PGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+Ci0tLQpbIGRpbGVrczogdjI6CiAgKiBDb3JyZWN0
IGxhc3QgaHVuayBhcyBtZW1fY2dyb3VwX3B1dCgpIGV4aXN0cyBubyBtb3JlCiAgKiBSZW5hbWUg
cGF0Y2gtbmFtZSBzLy1maXgtMi8tZml4LWZpeCBdCgogbW0vbWVtY29udHJvbC5jIHwgICAxMiAr
KysrKysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQoKZGlmZiAtcHVOIG1tL21lbWNvbnRyb2wuY35tZW1jZy11c2UtY3NzX2dldC1wdXQtd2hl
bi1jaGFyZ2luZy11bmNoYXJnaW5nLWttZW0tZml4LWZpeCBtbS9tZW1jb250cm9sLmMKLS0tIGEv
bW0vbWVtY29udHJvbC5jfm1lbWNnLXVzZS1jc3NfZ2V0LXB1dC13aGVuLWNoYXJnaW5nLXVuY2hh
cmdpbmcta21lbS1maXgtZml4CisrKyBhL21tL21lbWNvbnRyb2wuYwpAQCAtNTkxNiw2ICs1OTE2
LDExIEBAIHN0YXRpYyBpbnQgbWVtY2dfaW5pdF9rbWVtKHN0cnVjdCBtZW1fY2cKIAlyZXR1cm4g
bWVtX2Nncm91cF9zb2NrZXRzX2luaXQobWVtY2csIHNzKTsKIH0KIAorc3RhdGljIHZvaWQgbWVt
Y2dfZGVzdHJveV9rbWVtKHN0cnVjdCBtZW1fY2dyb3VwICptZW1jZykKK3sKKwltZW1fY2dyb3Vw
X3NvY2tldHNfZGVzdHJveShtZW1jZyk7Cit9CisKIHN0YXRpYyB2b2lkIGttZW1fY2dyb3VwX2Nz
c19vZmZsaW5lKHN0cnVjdCBtZW1fY2dyb3VwICptZW1jZykKIHsKIAlpZiAoIW1lbWNnX2ttZW1f
aXNfYWN0aXZlKG1lbWNnKSkKQEAgLTU5NTUsNiArNTk2MCwxMCBAQCBzdGF0aWMgaW50IG1lbWNn
X2luaXRfa21lbShzdHJ1Y3QgbWVtX2NnCiAJcmV0dXJuIDA7CiB9CiAKK3N0YXRpYyB2b2lkIG1l
bWNnX2Rlc3Ryb3lfa21lbShzdHJ1Y3QgbWVtX2Nncm91cCAqbWVtY2cpCit7Cit9CisKIHN0YXRp
YyB2b2lkIGttZW1fY2dyb3VwX2Nzc19vZmZsaW5lKHN0cnVjdCBtZW1fY2dyb3VwICptZW1jZykK
IHsKIH0KQEAgLTYzOTksOCArNjQwOCw3IEBAIHN0YXRpYyB2b2lkIG1lbV9jZ3JvdXBfY3NzX2Zy
ZWUoc3RydWN0IGMKIHsKIAlzdHJ1Y3QgbWVtX2Nncm91cCAqbWVtY2cgPSBtZW1fY2dyb3VwX2Zy
b21fY29udChjb250KTsKIAotCW1lbV9jZ3JvdXBfc29ja2V0c19kZXN0cm95KG1lbWNnKTsKLQor
CW1lbWNnX2Rlc3Ryb3lfa21lbShtZW1jZyk7CiAJX19tZW1fY2dyb3VwX2ZyZWUobWVtY2cpOwog
fQogCl8K
--001a11c24c64bd307604e0ab88c8--
