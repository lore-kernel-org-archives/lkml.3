Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaCIIAJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:00:09 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:42574 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaCIIAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:00:07 -0400
MIME-Version: 1.0
X-Originating-IP: [112.161.134.227]
In-Reply-To: <CAH4bKb02r2Co08u8nSVOw2eFVCF-5r_bA33B8RGDwW1BLtjoKA@mail.gmail.com>
References: <1394250361-5151-1-git-send-email-yong@gnoy.org>
	<1394250953.6972.16.camel@joe-AO722>
	<CAH4bKb02r2Co08u8nSVOw2eFVCF-5r_bA33B8RGDwW1BLtjoKA@mail.gmail.com>
Date: Sun, 9 Mar 2014 17:00:04 +0900
Message-ID: <CAH4bKb0Di7cQoaE5cytcRM4mGLHkHP10oFuOu97cZu_z=gfvmw@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix Coding style
From: =?EUC-KR?B?w9YoQ2hvaSmx4r/rKEdpLXlvbmcp?= <yong@gnoy.org>
To: Joe Perches <joe@perches.com>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=089e0160b618f0003504f427dfc7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0160b618f0003504f427dfc7
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: quoted-printable

>Please run your suggested patches through checkpatch.


> @@ -715,7 +715,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t =
align, bool reserved)
>
>       if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZ=
E)) {
>               WARN(true, "illegal size (%zu) or align (%zu) for "
> -                  "percpu allocation\n", size, align);
> +                             "percpu allocation\n", size, align);

>It'd be better to coalesce the format fragments


> @@ -968,8 +968,8 @@ bool is_kernel_percpu_address(unsigned long addr)
>               void *start =3D per_cpu_ptr(base, cpu);
>
>               if ((void *)addr >=3D start && (void *)addr < start + stati=
c_size)
> -                     return true;
> -        }
> +             return true;
> +       }

>Not an improvement.
>Why do you think it's better?

I thought it would be better indent when return operation is fit in there.
but it wouldn't sorry for my mistake.

>> @@ -1929,8 +1929,7 @@ void __init setup_per_cpu_areas(void)
>>   */
>>  void __init percpu_init_late(void)
>>  {
>> -     struct pcpu_chunk *target_chunks[] =3D
>> -             { pcpu_first_chunk, pcpu_reserved_chunk, NULL };
> +     struct pcpu_chunk *target_chunks[] =3D { pcpu_first_chunk, pcpu_res=
erved_chunk, NULL };

>This exceeds 80 columns.

>This would be better as:

>      struct pcpu_chunk *target_chunks[] =3D {
>               pcpu_first_chunk, pcpu_reserved_chunk, NULL
>      };

>And perhaps this should be static const

I couldn't fix 717 line exceed problem.
What can i do?

Sorry for my e-mail was rejected by vger.kernel.org server.


--=20

=C3=D6     =B1=E2=BF=EB
Choi Gi-yong

2014-03-09 16:55 GMT+09:00 =C3=D6(Choi)=B1=E2=BF=EB(Gi-yong) <yong@gnoy.org=
>:
> Please run your suggested patches through checkpatch.
>
>
>> @@ -715,7 +715,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t
>> align, bool reserved)
>>
>>       if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align >
>> PAGE_SIZE)) {
>>               WARN(true, "illegal size (%zu) or align (%zu) for "
>> -                  "percpu allocation\n", size, align);
>> +                             "percpu allocation\n", size, align);
>
>>It'd be better to coalesce the format fragments
>
>
>> @@ -968,8 +968,8 @@ bool is_kernel_percpu_address(unsigned long addr)
>>               void *start =3D per_cpu_ptr(base, cpu);
>>
>>               if ((void *)addr >=3D start && (void *)addr < start +
>> static_size)
>> -                     return true;
>> -        }
>> +             return true;
>> +       }
>
>>Not an improvement.
>>Why do you think it's better?
>
> I thought it would be better indent when return operation is fit in there=
.
> but it wouldn't sorry for my mistake.
>
>>> @@ -1929,8 +1929,7 @@ void __init setup_per_cpu_areas(void)
>>>   */
>>>  void __init percpu_init_late(void)
>>>  {
>>> -     struct pcpu_chunk *target_chunks[] =3D
>>> -             { pcpu_first_chunk, pcpu_reserved_chunk, NULL };
>> +     struct pcpu_chunk *target_chunks[] =3D { pcpu_first_chunk,
>> pcpu_reserved_chunk, NULL };
>
>>This exceeds 80 columns.
>
>>This would be better as:
>
>>      struct pcpu_chunk *target_chunks[] =3D {
>>               pcpu_first_chunk, pcpu_reserved_chunk, NULL
>>      };
>
>>And perhaps this should be static const
>
> I couldn't fix 717 line exceed problem.
> What can i do?
>
>
>
> --
>
> =C3=D6     =B1=E2=BF=EB
> Choi Gi-yong



--=20

=C3=D6     =B1=E2=BF=EB
Choi Gi-yong

--089e0160b618f0003504f427dfc7
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-mm-Fixed-coding-style-and-added-static-const-keyword.patch"
Content-Disposition: attachment; 
	filename="0001-mm-Fixed-coding-style-and-added-static-const-keyword.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hsk16g6k1

RnJvbSBmYThlNzRlYTY5MTk1OTQxODQxZTIwZDYwNmQ0ODBhOGFkMTNmMTViIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDaG9pIEdpLXlvbmcgPHlvbmdAZ25veS5vcmc+CkRhdGU6IFN1
biwgOSBNYXIgMjAxNCAxNjo1MToyOCArMDkwMApTdWJqZWN0OiBbUEFUQ0hdIG1tOiBGaXhlZCBj
b2Rpbmcgc3R5bGUgYW5kIGFkZGVkIHN0YXRpYyBjb25zdCBrZXl3b3JkcwoKU2lnbmVkLW9mZi1i
eTogQ2hvaSBHaS15b25nIDx5b25nQGdub3kub3JnPgotLS0KIG1tL3BlcmNwdS5jIHwgMTEgKysr
KysrLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvbW0vcGVyY3B1LmMgYi9tbS9wZXJjcHUuYwppbmRleCBkY2EyODRmLi5m
ZjZjY2UyIDEwMDY0NAotLS0gYS9tbS9wZXJjcHUuYworKysgYi9tbS9wZXJjcHUuYwpAQCAtNzE0
LDggKzcxNCw3IEBAIHN0YXRpYyB2b2lkIF9fcGVyY3B1ICpwY3B1X2FsbG9jKHNpemVfdCBzaXpl
LCBzaXplX3QgYWxpZ24sIGJvb2wgcmVzZXJ2ZWQpCiAJdm9pZCBfX3BlcmNwdSAqcHRyOwogCiAJ
aWYgKHVubGlrZWx5KCFzaXplIHx8IHNpemUgPiBQQ1BVX01JTl9VTklUX1NJWkUgfHwgYWxpZ24g
PiBQQUdFX1NJWkUpKSB7Ci0JCVdBUk4odHJ1ZSwgImlsbGVnYWwgc2l6ZSAoJXp1KSBvciBhbGln
biAoJXp1KSBmb3IgIgotCQkJCSJwZXJjcHUgYWxsb2NhdGlvblxuIiwgc2l6ZSwgYWxpZ24pOwor
CQlXQVJOKHRydWUsICJpbGxlZ2FsIHNpemUgKCV6dSkgb3IgYWxpZ24gKCV6dSkgZm9yIHBlcmNw
dSBhbGxvY2F0aW9uXG4iLCBzaXplLCBhbGlnbik7CiAJCXJldHVybiBOVUxMOwogCX0KIApAQCAt
OTY4LDcgKzk2Nyw3IEBAIGJvb2wgaXNfa2VybmVsX3BlcmNwdV9hZGRyZXNzKHVuc2lnbmVkIGxv
bmcgYWRkcikKIAkJdm9pZCAqc3RhcnQgPSBwZXJfY3B1X3B0cihiYXNlLCBjcHUpOwogCiAJCWlm
ICgodm9pZCAqKWFkZHIgPj0gc3RhcnQgJiYgKHZvaWQgKilhZGRyIDwgc3RhcnQgKyBzdGF0aWNf
c2l6ZSkKLQkJcmV0dXJuIHRydWU7CisJCQlyZXR1cm4gdHJ1ZTsKICAgICAgICB9CiAjZW5kaWYK
IAkvKiBvbiBVUCwgY2FuJ3QgZGlzdGluZ3Vpc2ggZnJvbSBvdGhlciBzdGF0aWMgdmFycywgYWx3
YXlzIGZhbHNlICovCkBAIC0xNDgzLDcgKzE0ODIsNyBAQCBzdGF0aWMgc3RydWN0IHBjcHVfYWxs
b2NfaW5mbyAqIF9faW5pdCBwY3B1X2J1aWxkX2FsbG9jX2luZm8oCiAJLyogZ3JvdXAgY3B1cyBh
Y2NvcmRpbmcgdG8gdGhlaXIgcHJveGltaXR5ICovCiAJZm9yX2VhY2hfcG9zc2libGVfY3B1KGNw
dSkgewogCQlncm91cCA9IDA7Ci0JbmV4dF9ncm91cDoKK25leHRfZ3JvdXA6CiAJCWZvcl9lYWNo
X3Bvc3NpYmxlX2NwdSh0Y3B1KSB7CiAJCQlpZiAoY3B1ID09IHRjcHUpCiAJCQkJYnJlYWs7CkBA
IC0xOTI5LDcgKzE5MjgsOSBAQCB2b2lkIF9faW5pdCBzZXR1cF9wZXJfY3B1X2FyZWFzKHZvaWQp
CiAgKi8KIHZvaWQgX19pbml0IHBlcmNwdV9pbml0X2xhdGUodm9pZCkKIHsKLQlzdHJ1Y3QgcGNw
dV9jaHVuayAqdGFyZ2V0X2NodW5rc1tdID0geyBwY3B1X2ZpcnN0X2NodW5rLCBwY3B1X3Jlc2Vy
dmVkX2NodW5rLCBOVUxMIH07CisJc3RhdGljIGNvbnN0IHN0cnVjdCBwY3B1X2NodW5rICp0YXJn
ZXRfY2h1bmtzW10gPSB7CisJCXBjcHVfZmlyc3RfY2h1bmssIHBjcHVfcmVzZXJ2ZWRfY2h1bmss
IE5VTEwKKwl9OwogCXN0cnVjdCBwY3B1X2NodW5rICpjaHVuazsKIAl1bnNpZ25lZCBsb25nIGZs
YWdzOwogCWludCBpOwotLSAKMS44LjMuMgoK
--089e0160b618f0003504f427dfc7--
