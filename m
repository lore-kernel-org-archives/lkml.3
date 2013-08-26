Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3HZSH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 14:07:57 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:58342 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3HZSHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 14:07:55 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzcPFXei5j-i49+3kXZ5L9S-v66vrzU091EuXkSeg1G7A@mail.gmail.com>
References: <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
	<CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
	<20130822201530.GL31117@1wt.eu>
	<CALCETrXX--FWeoDMOTYNDOWkTKcWk=LcGs2oY7CQ9GU63CMLRg@mail.gmail.com>
	<CA+55aFzR71kJOOVzHKKaXW2Ph7wb6ivtVHPeR49PPcqpiCfPsA@mail.gmail.com>
	<CALCETrXXxRksU-YTY8WFJzeET9cWsPKo_=6e9RD=F+TS7xVMyQ@mail.gmail.com>
	<CA+55aFxqdV6CQ8UWkB1Z7HUB9GmRH4Jpw_UmmFqDqG01_DmsWw@mail.gmail.com>
	<20130823010726.GP27005@ZenIV.linux.org.uk>
	<20130825033741.GX27005@ZenIV.linux.org.uk>
	<CA+55aFxaKGcpdxKXK_axqyFz_oCvFm1Q=_fJLq8di97x_-cCig@mail.gmail.com>
	<20130825200605.GC27005@ZenIV.linux.org.uk>
	<CA+55aFyXq9kry7EtcnXOd_DWDVkDvVRWKLAfLOYHVsdY4RRJ8A@mail.gmail.com>
	<CA+55aFzcPFXei5j-i49+3kXZ5L9S-v66vrzU091EuXkSeg1G7A@mail.gmail.com>
Date: Mon, 26 Aug 2013 11:07:54 -0700
X-Google-Sender-Auth: FigFJRTO7UkWWkRE_kG7q1dfyys
Message-ID: <CA+55aFw20W9L8HV+VbTRNeQQM-_+aeUhvT9AAod5LGfb-7hE9g@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>, Willy Tarreau <w@1wt.eu>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: multipart/mixed; boundary=047d7b343244a58f7704e4dda218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b343244a58f7704e4dda218
Content-Type: text/plain; charset=UTF-8

On Mon, Aug 26, 2013 at 10:37 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'm playing with a patch that then in addition to the ptrace check
> *also* requires that the file was opened with the same credentials as
> the follower _or_ the task being followed. I'll see if that works out.

Chrome sandboxing still _works_ with the attached patch, but there's a
few audit messages about the sandbox being denied dac_read_search. And
I'm really not very happy with this anyway.

So I'm going to send it out (using email to archive things and see if
anybody has any comments), and then forget about it.

                  Linus

--047d7b343244a58f7704e4dda218
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hku00xa10

IGZzL3Byb2MvZmQuYyB8IDM0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0KIDEg
ZmlsZSBjaGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2ZzL3Byb2MvZmQuYyBiL2ZzL3Byb2MvZmQuYwppbmRleCAwZmY4MGY5YjkzMGYuLjdhOTdk
ZmJiNDIxNyAxMDA2NDQKLS0tIGEvZnMvcHJvYy9mZC5jCisrKyBiL2ZzL3Byb2MvZmQuYwpAQCAt
MTM3LDYgKzEzNywzMyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGRlbnRyeV9vcGVyYXRpb25zIHRp
ZF9mZF9kZW50cnlfb3BlcmF0aW9ucyA9IHsKIAkuZF9kZWxldGUJPSBwaWRfZGVsZXRlX2RlbnRy
eSwKIH07CiAKK3N0YXRpYyBpbmxpbmUgaW50IG1hdGNoX2NyZWQoY29uc3Qgc3RydWN0IGNyZWQg
KmEsIGNvbnN0IHN0cnVjdCBjcmVkICpiKQoreworCXJldHVybiBhLT5mc3VpZCA9PSBiLT5mc3Vp
ZCAmJiBhLT5mc2dpZCA9PSBiLT5mc2dpZDsKK30KKworLyoKKyAqIFRvIGdldCBoZXJlLCB3ZSBo
YXZlIHB0cmFjZSgpIGFjY2VzcyB0byB0aGUgdGFzayBpbiBxdWVzdGlvbi4KKyAqCisgKiBCdXQg
d2Ugc3RpbGwgcmVxdWlyZSB0aGF0IHRoZSBmaWxlIGl0c2VsZiB3YXMgZWl0aGVyIG9wZW5lZCBi
eSB0aGF0CisgKiB0YXNrIG9yIGJ5IG91cnNlbHZlcywgb3IgdGhhdCB3ZSBoYXZlIHBhdGggc2Vh
cmNoIGNhcGFiaWxpdHkuCisgKi8KK3N0YXRpYyBpbnQgZ2V0X2ZkX3BhdGgoc3RydWN0IHRhc2tf
c3RydWN0ICp0YXNrLCBzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IHBhdGggKnBhdGgpCit7CisJ
aWYgKCFtYXRjaF9jcmVkKGZpbGUtPmZfY3JlZCwgY3VycmVudF9jcmVkKCkpKSB7CisJCWludCBt
YXRjaDsKKworCQlyY3VfcmVhZF9sb2NrKCk7CisJCW1hdGNoID0gbWF0Y2hfY3JlZChmaWxlLT5m
X2NyZWQsIF9fdGFza19jcmVkKHRhc2spKTsKKwkJcmN1X3JlYWRfdW5sb2NrKCk7CisJCWlmICgh
bWF0Y2ggJiYgIWNhcGFibGUoQ0FQX0RBQ19SRUFEX1NFQVJDSCkpCisJCQlyZXR1cm4gLUVBQ0NF
UzsKKwl9CisJKnBhdGggPSBmaWxlLT5mX3BhdGg7CisJcGF0aF9nZXQoJmZpbGUtPmZfcGF0aCk7
CisJcmV0dXJuIDA7Cit9CisKIHN0YXRpYyBpbnQgcHJvY19mZF9saW5rKHN0cnVjdCBkZW50cnkg
KmRlbnRyeSwgc3RydWN0IHBhdGggKnBhdGgpCiB7CiAJc3RydWN0IGZpbGVzX3N0cnVjdCAqZmls
ZXMgPSBOVUxMOwpAQCAtMTU1LDExICsxODIsOCBAQCBzdGF0aWMgaW50IHByb2NfZmRfbGluayhz
dHJ1Y3QgZGVudHJ5ICpkZW50cnksIHN0cnVjdCBwYXRoICpwYXRoKQogCiAJCXNwaW5fbG9jaygm
ZmlsZXMtPmZpbGVfbG9jayk7CiAJCWZkX2ZpbGUgPSBmY2hlY2tfZmlsZXMoZmlsZXMsIGZkKTsK
LQkJaWYgKGZkX2ZpbGUpIHsKLQkJCSpwYXRoID0gZmRfZmlsZS0+Zl9wYXRoOwotCQkJcGF0aF9n
ZXQoJmZkX2ZpbGUtPmZfcGF0aCk7Ci0JCQlyZXQgPSAwOwotCQl9CisJCWlmIChmZF9maWxlKQor
CQkJcmV0ID0gZ2V0X2ZkX3BhdGgodGFzaywgZmRfZmlsZSwgcGF0aCk7CiAJCXNwaW5fdW5sb2Nr
KCZmaWxlcy0+ZmlsZV9sb2NrKTsKIAkJcHV0X2ZpbGVzX3N0cnVjdChmaWxlcyk7CiAJfQo=
--047d7b343244a58f7704e4dda218--
