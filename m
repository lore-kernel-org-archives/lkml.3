Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031828Ab3HJCVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 22:21:22 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:65144 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031798Ab3HJCVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 22:21:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVvo+saJFpx=6A8O7GOns0cR302_GBe4A0a10a4Z0mZyw@mail.gmail.com>
References: <520578D0.7020607@intel.com>
	<CAE9FiQUuPmZfhsHvmsS+_O_VOWMA_OBAexGyRF3eZR1_D3EehA@mail.gmail.com>
	<52059508.3090405@sr71.net>
	<CAE9FiQVvo+saJFpx=6A8O7GOns0cR302_GBe4A0a10a4Z0mZyw@mail.gmail.com>
Date: Fri, 9 Aug 2013 19:21:19 -0700
X-Google-Sender-Auth: ieblTbaDfuIWgUt_2G9hemIk0OM
Message-ID: <CAE9FiQWn5+XH7cjUjRJNuB747u2-aq3ZpXoPwyZEFYALCxZ30Q@mail.gmail.com>
Subject: Re: x86: early boot crash: "alloc_low_page: ran out of memory" (bisected)
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: multipart/mixed; boundary=001a11335194ed950f04e38e8b4b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11335194ed950f04e38e8b4b
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Aug 9, 2013 at 7:10 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Aug 9, 2013 at 6:19 PM, Dave Hansen <dave@sr71.net> wrote:
>> On 08/09/2013 04:23 PM, Yinghai Lu wrote:
>>> On Fri, Aug 9, 2013 at 4:18 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>>>> I'm getting a 100% reproducible panic early in boot:
>> ...
>>>>> early console in setup code
>>>>> [    0.000000] Initializing cgroup subsys cpuset
>>>>> [    0.000000] Initializing cgroup subsys cpu
>>>>> [    0.000000] Linux version 3.8.0-rc5-00059-g8170e6b
>>>
>>> so how about v3.10?
>>>
>>> We should have some fixes in 3.10 already.
>>
>> I was hitting it on Linus's current tree today (3.11-rcwhatever).  I
>> pasted the panic() from your patch's commit specifically, but the same
>> behavior is happening on current kernels, and it looked consistent as I
>> bisected between the 3.11-rc's and your commit.
>
> Can you post 3.11-rc with "debug ignore_loglevel memblock=debug" ?
>

Can you try attached patch ?

Thanks

Yinghai

--001a11335194ed950f04e38e8b4b
Content-Type: application/octet-stream; name="fix_dave_machine.patch"
Content-Disposition: attachment; filename="fix_dave_machine.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hk675xc80

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL2luaXQuYyBiL2FyY2gveDg2L21tL2luaXQuYwppbmRl
eCAyZWMyOWFjLi5mOWVlYzgwIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9tbS9pbml0LmMKKysrIGIv
YXJjaC94ODYvbW0vaW5pdC5jCkBAIC03OCw4ICs3OCw4IEBAIF9fcmVmIHZvaWQgKmFsbG9jX2xv
d19wYWdlcyh1bnNpZ25lZCBpbnQgbnVtKQogCXJldHVybiBfX3ZhKHBmbiA8PCBQQUdFX1NISUZU
KTsKIH0KIAotLyogbmVlZCA0IDRrIGZvciBpbml0aWFsIFBNRF9TSVpFLCA0ayBmb3IgMC1JU0Ff
RU5EX0FERFJFU1MgKi8KLSNkZWZpbmUgSU5JVF9QR1RfQlVGX1NJWkUJKDUgKiBQQUdFX1NJWkUp
CisvKiBuZWVkIDQgNGsgZm9yIGluaXRpYWwgUE1EX1NJWkUsICAzIDRrIGZvciAwLUlTQV9FTkRf
QUREUkVTUyAqLworI2RlZmluZSBJTklUX1BHVF9CVUZfU0laRQkoNyAqIFBBR0VfU0laRSkKIFJF
U0VSVkVfQlJLKGVhcmx5X3BndF9hbGxvYywgSU5JVF9QR1RfQlVGX1NJWkUpOwogdm9pZCAgX19p
bml0IGVhcmx5X2FsbG9jX3BndF9idWYodm9pZCkKIHsK
--001a11335194ed950f04e38e8b4b--
