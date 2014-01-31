Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811AbaAaSxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:53:46 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:55643 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932460AbaAaSxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:53:44 -0500
MIME-Version: 1.0
In-Reply-To: <CADZ9YHj4D7aDAznt5rWvn45aVXZ8r-c+G0EeaH6AGdE_TLu9Bg@mail.gmail.com>
References: <1390895840.8373.2.camel@beeld>
	<20140128164320.GB7596@redhat.com>
	<CADZ9YHhx3NkeQp4S=o0ruAd7U20AprFt-uejcqn1oLzJbm3w4A@mail.gmail.com>
	<20140129145535.GA12562@redhat.com>
	<CADZ9YHjEfEWJx5z_5KZnfQAVHXY3u613XV7vdZqjts4zFR3_=g@mail.gmail.com>
	<20140129183204.GA22808@redhat.com>
	<CADZ9YHj4D7aDAznt5rWvn45aVXZ8r-c+G0EeaH6AGdE_TLu9Bg@mail.gmail.com>
Date: Sat, 1 Feb 2014 00:53:42 +0600
Message-ID: <CADZ9YHgYsibaVm9c+Ho+XXZKxZatHY-+pm=w+jj0EQ94qfFt5Q@mail.gmail.com>
Subject: Re: Do we really need curr_target in signal_struct ?
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary=089e0141a0a0610e3d04f148b17f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0141a0a0610e3d04f148b17f
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Jan 30, 2014 at 1:02 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Thu, Jan 30, 2014 at 12:32 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 01/29, Rakib Mullick wrote:
>
>>> Are you thinking that , since things are not broken, then we shouldn't
>>> try to do anything?
>>
>> Hmm. No.
>>
>> I am thinking that, since you misunderstood the purpose of ->curr_target,
>> I should probably try to argue with your patch which blindly removes this
>> optimization ?
>>
> Since the optimization (usages of ->curr_target) isn't perfect, so there's
> chance of being misunderstood. This optimization is misleading too (I think),
> cause curr_target don't have anything to do with wants_signal() and
>  ->curr_target is used only for this optimization and to get this optimization
> needs to maintain it properly, and this maintenance does have cost and if
> we don't get benefited too much, then it doesn't worth it (my pov).
>
>> I also think that this logic doesn't look perfect, but this is another
>> story.
>
> Yes, this logic seems need to improve.
>
As you've made few points about the current logic of thread picking in
complete_signal(), I took a look and found that using while_each_thread()
can make things better than current. Although my initial intent of this thread
wasn't related to complete_signal() logic, but as you've pointed out that
things could be better, so I prepared the attached patch (just to address
complete_signal()'s thread finding logic) not using ->curr_target but it's been
kept. What do you think?


Thanks,
Rakib

--089e0141a0a0610e3d04f148b17f
Content-Type: text/x-patch; charset=US-ASCII; name="signal_completion.patch"
Content-Disposition: attachment; filename="signal_completion.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hr3t6gb00

ZGlmZiAtLWdpdCBhL2tlcm5lbC9zaWduYWwuYyBiL2tlcm5lbC9zaWduYWwuYwppbmRleCA1MmY4
ODFkLi4wNjRmODFmIDEwMDY0NAotLS0gYS9rZXJuZWwvc2lnbmFsLmMKKysrIGIva2VybmVsL3Np
Z25hbC5jCkBAIC05NDQsNyArOTQ0LDcgQEAgc3RhdGljIGlubGluZSBpbnQgd2FudHNfc2lnbmFs
KGludCBzaWcsIHN0cnVjdCB0YXNrX3N0cnVjdCAqcCkKIHN0YXRpYyB2b2lkIGNvbXBsZXRlX3Np
Z25hbChpbnQgc2lnLCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnAsIGludCBncm91cCkKIHsKIAlzdHJ1
Y3Qgc2lnbmFsX3N0cnVjdCAqc2lnbmFsID0gcC0+c2lnbmFsOwotCXN0cnVjdCB0YXNrX3N0cnVj
dCAqdDsKKwlzdHJ1Y3QgdGFza19zdHJ1Y3QgKnQgPSBwOwogCiAJLyoKIAkgKiBOb3cgZmluZCBh
IHRocmVhZCB3ZSBjYW4gd2FrZSB1cCB0byB0YWtlIHRoZSBzaWduYWwgb2ZmIHRoZSBxdWV1ZS4K
QEAgLTk1MiwzMyArOTUyLDI2IEBAIHN0YXRpYyB2b2lkIGNvbXBsZXRlX3NpZ25hbChpbnQgc2ln
LCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnAsIGludCBncm91cCkKIAkgKiBJZiB0aGUgbWFpbiB0aHJl
YWQgd2FudHMgdGhlIHNpZ25hbCwgaXQgZ2V0cyBmaXJzdCBjcmFjay4KIAkgKiBQcm9iYWJseSB0
aGUgbGVhc3Qgc3VycHJpc2luZyB0byB0aGUgYXZlcmFnZSBiZWFyLgogCSAqLwotCWlmICh3YW50
c19zaWduYWwoc2lnLCBwKSkKLQkJdCA9IHA7Ci0JZWxzZSBpZiAoIWdyb3VwIHx8IHRocmVhZF9n
cm91cF9lbXB0eShwKSkKLQkJLyoKLQkJICogVGhlcmUgaXMganVzdCBvbmUgdGhyZWFkIGFuZCBp
dCBkb2VzIG5vdCBuZWVkIHRvIGJlIHdva2VuLgotCQkgKiBJdCB3aWxsIGRlcXVldWUgdW5ibG9j
a2VkIHNpZ25hbHMgYmVmb3JlIGl0IHJ1bnMgYWdhaW4uCi0JCSAqLwotCQlyZXR1cm47Ci0JZWxz
ZSB7Ci0JCS8qCi0JCSAqIE90aGVyd2lzZSB0cnkgdG8gZmluZCBhIHN1aXRhYmxlIHRocmVhZC4K
LQkJICovCi0JCXQgPSBzaWduYWwtPmN1cnJfdGFyZ2V0OwotCQl3aGlsZSAoIXdhbnRzX3NpZ25h
bChzaWcsIHQpKSB7Ci0JCQl0ID0gbmV4dF90aHJlYWQodCk7Ci0JCQlpZiAodCA9PSBzaWduYWwt
PmN1cnJfdGFyZ2V0KQotCQkJCS8qCi0JCQkJICogTm8gdGhyZWFkIG5lZWRzIHRvIGJlIHdva2Vu
LgotCQkJCSAqIEFueSBlbGlnaWJsZSB0aHJlYWRzIHdpbGwgc2VlCi0JCQkJICogdGhlIHNpZ25h
bCBpbiB0aGUgcXVldWUgc29vbi4KLQkJCQkgKi8KLQkJCQlyZXR1cm47CisJaWYgKCFncm91cCB8
fCB0aHJlYWRfZ3JvdXBfZW1wdHkocCkpIHsKKwkJaWYgKHdhbnRzX3NpZ25hbChzaWcsIHQpKQor
CQkJZ290byBmb3VuZDsKKwl9IGVsc2UgeworCQl3aGlsZV9lYWNoX3RocmVhZChwLCB0KSB7CisJ
CQlpZiAod2FudHNfc2lnbmFsKHNpZywgdCkpCisJCQkJZ290byBmb3VuZDsKIAkJfQotCQlzaWdu
YWwtPmN1cnJfdGFyZ2V0ID0gdDsKIAl9CiAKIAkvKgorCSAqIE5vIHRocmVhZCBuZWVkcyB0byBi
ZSB3b2tlbi4KKwkgKiBBbnkgZWxpZ2libGUgdGhyZWFkcyB3aWxsIHNlZQorCSAqIHRoZSBzaWdu
YWwgaW4gdGhlIHF1ZXVlIHNvb24uCisJICovCisJcmV0dXJuOworZm91bmQ6CisJc2lnbmFsLT5j
dXJyX3RhcmdldCA9IHQ7CisKKwkvKgogCSAqIEZvdW5kIGEga2lsbGFibGUgdGhyZWFkLiAgSWYg
dGhlIHNpZ25hbCB3aWxsIGJlIGZhdGFsLAogCSAqIHRoZW4gc3RhcnQgdGFraW5nIHRoZSB3aG9s
ZSBncm91cCBkb3duIGltbWVkaWF0ZWx5LgogCSAqLwo=
--089e0141a0a0610e3d04f148b17f--
