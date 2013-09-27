Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3I0W4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 18:56:37 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:63827 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3I0W4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 18:56:35 -0400
MIME-Version: 1.0
In-Reply-To: <1380321480.27811.53.camel@pasglop>
References: <1380270519.27811.10.camel@pasglop>
	<CAE9FiQVkW7d7vFx_kPJG-FEvO71SZjZmpR+dnwVm61wkYK=0YA@mail.gmail.com>
	<CA+55aFyDfMdAeaniQwkoeW6F-xd3JxrzGYwtFb6N9+NA6aRCMg@mail.gmail.com>
	<1380318405.27811.37.camel@pasglop>
	<CAE9FiQXXvkfTak6oEpUog_RYs_Gwpdji7N5UJ=R11Q61==N97A@mail.gmail.com>
	<1380321480.27811.53.camel@pasglop>
Date: Fri, 27 Sep 2013 15:56:34 -0700
X-Google-Sender-Auth: 0PeqcLgtUb3CS48nMr3O4vme5Dg
Message-ID: <CAE9FiQWm7ALPO5k_2nV+fuZw4oNNiw+_PEx8EWkb52ymN+EYUg@mail.gmail.com>
Subject: Re: Please revert 928bea964827d7824b548c1f8e06eccbbc4d0d7d
From: Yinghai Lu <yinghai@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7bd758daeec56404e765651b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bd758daeec56404e765651b
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Sep 27, 2013 at 3:38 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Fri, 2013-09-27 at 14:54 -0700, Yinghai Lu wrote:
>> On Fri, Sep 27, 2013 at 2:46 PM, Benjamin Herrenschmidt
>> <benh@kernel.crashing.org> wrote:
>>
>> > Wouldn't it be better to simply have pci_enable_device() always set bus
>> > master on a bridge? I don't see any case where it makes sense to have
>> > an enabled bridge without the master bit set on it...
>>
>> Do you mean attached?
>
> So this patch works and fixes the problem. I think it makes the whole
> thing more robust and should be applied.

good.

>
> I still don't know why the bridge doesn't get enabled properly without
> it yes, tracking it down (the machine in question takes a LONG time to
> reboot :-)

ok, please if you are ok attached one instead. It will print some warning about
driver skipping pci_set_master, so we can catch more problem with drivers.

Thanks

Yinghai

--047d7bd758daeec56404e765651b
Content-Type: application/octet-stream; name="pci_set_master_again_v2.patch"
Content-Disposition: attachment; filename="pci_set_master_again_v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hm40exvl0

U3ViamVjdDogW1BBVENIXSBQQ0k6IFdvcmthcm91bmQgbWlzc2luZyBwY2lfc2V0X21hc3RlciBp
biBwY2kgZHJpdmVycwoKQmVuSCBmb3VuZDoKfCA5MjhiZWE5NjQ4MjdkNzgyNGI1NDhjMWY4ZTA2
ZWNjYmJjNGQwZDdkCnwgUENJOiBEZWxheSBlbmFibGluZyBicmlkZ2VzIHVudGlsIHRoZXkncmUg
bmVlZGVkCgpicmVhayBQQ0kgb24gcG93ZXJwYy4gIFRoZSByZWFzb24gaXMgdGhhdCB0aGUgUENJ
ZSBwb3J0IGRyaXZlciB3aWxsCmNhbGwgcGNpX2VuYWJsZV9kZXZpY2UoKSBvbiB0aGUgYnJpZGdl
LCBzbyBkZXZpY2UgZW5hYmxlZCAoYnV0IHNraXAKcGNpX3NldF9tYXN0ZXIgc29tZWhvdykuCgpC
ZWNhdXNlIG9mIHRoYXQsIHBjaV9lbmFibGVfYnJpZGdlKCkgbGF0ZXIgb24gKGNhbGxlZCBhcyBh
IHJlc3VsdCBvZiB0aGUKY2hpbGQgZGV2aWNlIGRyaXZlciBkb2luZyBwY2lfZW5hYmxlX2Rldmlj
ZSkgd2lsbCBzZWUgdGhlIGJyaWRnZSBhcwphbHJlYWR5IGVuYWJsZWQgYW5kIHdpbGwgbm90IGNh
bGwgcGNpX3NldF9tYXN0ZXIoKSBvbiBpdC4KCkZpeGVkIGJ5IGFkZCBjaGVja2luZyBpbiBwY2lf
ZW5hYmxlX2JyaWRnZSwgYW5kIGNhbGwgcGNpX3NldF9tYXN0ZXIKaWYgZHJpdmVyIHNraXAgdGhh
dC4KClJlcG9ydGVkLWJ5OiBCZW5qYW1pbiBIZXJyZW5zY2htaWR0IDxiZW5oQGtlcm5lbC5jcmFz
aGluZy5vcmc+ClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4K
Ci0tLQogZHJpdmVycy9wY2kvcGNpLmMgfCAgICA4ICsrKysrKystCiAxIGZpbGUgY2hhbmdlZCwg
NyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMv
cGNpL3BjaS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvcGNpL3BjaS5j
CisrKyBsaW51eC0yLjYvZHJpdmVycy9wY2kvcGNpLmMKQEAgLTExNTYsOCArMTE1NiwxNCBAQCBz
dGF0aWMgdm9pZCBwY2lfZW5hYmxlX2JyaWRnZShzdHJ1Y3QgcGNpCiAKIAlwY2lfZW5hYmxlX2Jy
aWRnZShkZXYtPmJ1cy0+c2VsZik7CiAKLQlpZiAocGNpX2lzX2VuYWJsZWQoZGV2KSkKKwlpZiAo
cGNpX2lzX2VuYWJsZWQoZGV2KSkgeworCQlpZiAoIWRldi0+aXNfYnVzbWFzdGVyKSB7CisJCQlk
ZXZfd2FybigmZGV2LT5kZXYsICJkcml2ZXIgc2tpcCBwY2lfc2V0X21hc3RlciwgZml4IGl0IVxu
Iik7CisJCQlwY2lfc2V0X21hc3RlcihkZXYpOworCQl9CiAJCXJldHVybjsKKwl9CisKIAlyZXR2
YWwgPSBwY2lfZW5hYmxlX2RldmljZShkZXYpOwogCWlmIChyZXR2YWwpCiAJCWRldl9lcnIoJmRl
di0+ZGV2LCAiRXJyb3IgZW5hYmxpbmcgYnJpZGdlICglZCksIGNvbnRpbnVpbmdcbiIsCg==
--047d7bd758daeec56404e765651b--
