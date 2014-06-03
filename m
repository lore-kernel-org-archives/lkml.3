Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbaFCJ05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:26:57 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61266 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaFCJ0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:26:55 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUUiirxYnoL7pg5TvFEy6pQ+5Q3CuJ0jonJMXTOwhT-LDw@mail.gmail.com>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
	<28592.1401382081@warthog.procyon.org.uk>
	<11446.1401420931@jrobl>
	<7184.1401439773@warthog.procyon.org.uk>
	<CA+icZUV5P=fVwe_MJJHixwBOBoj7HoKSFuySLdS6AU5L++S=4g@mail.gmail.com>
	<15839.1401786056@warthog.procyon.org.uk>
	<CA+icZUUiirxYnoL7pg5TvFEy6pQ+5Q3CuJ0jonJMXTOwhT-LDw@mail.gmail.com>
Date: Tue, 3 Jun 2014 11:26:53 +0200
Message-ID: <CA+icZUU8BqGUoQdtuqt403NdCBnJnH1-k64bxTM0b_GSfQr1hQ@mail.gmail.com>
Subject: Re: Unionmount and overlayfs testsuite
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: "J. R. Okajima" <hooanon05g@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Felix Fietkau <nbd@openwrt.org>, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, mszeredi@suse.cz
Content-Type: multipart/mixed; boundary=047d7b873a30bed10204faeb1cc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b873a30bed10204faeb1cc2
Content-Type: text/plain; charset=UTF-8

On Tue, Jun 3, 2014 at 11:18 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> [...]
>>> [ NOTE-2: The call-trace I have seen once (TERMSLASH=0). ]
>>
>> Do you know for which operation?
>>
>
> # echo $TESTS
> open-plain.test open-trunc.test open-creat.test open-creat-trunc.test
> open-creat-excl.test open-creat-excl-trunc.test noent-plain.test
> noent-trunc.test noent-creat.test noent-creat-trunc.test
> noent-creat-excl.test noent-creat-excl-trunc.test sym1-plain.test
> sym1-trunc.test sym1-creat.test sym1-creat-excl.test sym2-plain.test
> sym2-trunc.test sym2-creat.test sym2-creat-excl.test symx-plain.test
> symx-trunc.test symx-creat.test symx-creat-excl.test
> symx-creat-trunc.test truncate.test dir-open.test dir-weird-open.test
> dir-open-dir.test dir-weird-open-dir.test dir-sym1-open.test
> dir-sym1-weird-open.test dir-sym2-open.test dir-sym2-weird-open.test
> readlink.test impermissible.test
>
> # for i in $TESTS ; do echo [ $i ] ; LC_ALL=C TEST_OVERLAYFS=1
> TERMSLASH=1 ./run.sh $i 2>&1 | tee ../run-sh-log_${i}.txt ; dmesg
>>dmesg_${i}.txt ; done
>
> # for i in $TESTS ; do echo [ $i ] ; grep "INFO: possible recursive
> locking detected" dmesg_${i}.txt ; done
> ...
> [ symx-creat-trunc.test ]
> [ truncate.test ]
> [ 1910.007203] [ INFO: possible recursive locking detected ]
> ...
>
> LAST-GOOD: dmesg_symx-creat-trunc.test.txt
>
> FIRST-BAD: dmesg_truncate.test.txt
>
> dmesg files attached.
>

The lockdep appears one time in the logs... I tried several...

     # LC_ALL=C TEST_OVERLAYFS=1 ./run.sh truncate.test

...and see the only lockdep.

Sorry, I cannot say which of the test-no (is that what you mean by
operation?) is causing the lockdep.

Truncate-test results attached.

- Sedat -

--047d7b873a30bed10204faeb1cc2
Content-Type: text/plain; charset=US-ASCII; name="run-sh-log_truncate-test.txt"
Content-Disposition: attachment; filename="run-sh-log_truncate-test.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hvz03tet2

KioqCioqKiBURVNUX09WRVJMQVlGUz0xIFRFUk1TTEFTSD0wIC4vcnVuLnNoIHRydW5jYXRlLnRl
c3QKKioqClRFU1QxMjk6IFByZXBhcmUgY29tcGFyaXNvbgoxNiswIHJlY29yZHMgaW4KMTYrMCBy
ZWNvcmRzIG91dApURVNUMTAwOiBUcnVuY2F0ZSB0byAwCiAtIGZzX29wIHRydW5jYXRlIC9tbnQv
YS9mb28xMDAgMApURVNUMTAxOiBUcnVuY2F0ZSB0byAxCiAtIGZzX29wIHRydW5jYXRlIC9tbnQv
YS9mb28xMDEgMQpURVNUMTAyOiBUcnVuY2F0ZSB0byAyCiAtIGZzX29wIHRydW5jYXRlIC9tbnQv
YS9mb28xMDIgMgpURVNUMTAzOiBUcnVuY2F0ZSB0byAzCiAtIGZzX29wIHRydW5jYXRlIC9tbnQv
YS9mb28xMDMgMwpURVNUMTA0OiBUcnVuY2F0ZSB0byA0CiAtIGZzX29wIHRydW5jYXRlIC9tbnQv
YS9mb28xMDQgNApURVNUMTA1OiBUcnVuY2F0ZSB0byA1CiAtIGZzX29wIHRydW5jYXRlIC9tbnQv
YS9mb28xMDUgNQpURVNUMTA2OiBUcnVuY2F0ZSB0byA2CiAtIGZzX29wIHRydW5jYXRlIC9tbnQv
YS9mb28xMDYgNgpURVNUMTA3OiBUcnVuY2F0ZSB0byA3CiAtIGZzX29wIHRydW5jYXRlIC9tbnQv
YS9mb28xMDcgNwpURVNUMTA4OiBUcnVuY2F0ZSB0byA4CiAtIGZzX29wIHRydW5jYXRlIC9tbnQv
YS9mb28xMDggOApURVNUMTA5OiBUcnVuY2F0ZSB0byA5CiAtIGZzX29wIHRydW5jYXRlIC9tbnQv
YS9mb28xMDkgOQpURVNUMTEwOiBUcnVuY2F0ZSB0byAxMAogLSBmc19vcCB0cnVuY2F0ZSAvbW50
L2EvZm9vMTEwIDEwClRFU1QxMTE6IFRydW5jYXRlIHRvIDExCiAtIGZzX29wIHRydW5jYXRlIC9t
bnQvYS9mb28xMTEgMTEKVEVTVDExMjogVHJ1bmNhdGUgdG8gMTIKIC0gZnNfb3AgdHJ1bmNhdGUg
L21udC9hL2ZvbzExMiAxMgpURVNUMTEzOiBUcnVuY2F0ZSB0byAxMwogLSBmc19vcCB0cnVuY2F0
ZSAvbW50L2EvZm9vMTEzIDEzClRFU1QxMTQ6IFRydW5jYXRlIHRvIDE0CiAtIGZzX29wIHRydW5j
YXRlIC9tbnQvYS9mb28xMTQgMTQKVEVTVDExNTogVHJ1bmNhdGUgdG8gMTUKIC0gZnNfb3AgdHJ1
bmNhdGUgL21udC9hL2ZvbzExNSAxNQpURVNUMTE2OiBUcnVuY2F0ZSB0byAxNgogLSBmc19vcCB0
cnVuY2F0ZSAvbW50L2EvZm9vMTE2IDE2ClRFU1QxMTc6IFRydW5jYXRlIHRvIDE3CiAtIGZzX29w
IHRydW5jYXRlIC9tbnQvYS9mb28xMTcgMTcKVEVTVDExODogVHJ1bmNhdGUgdG8gMTgKIC0gZnNf
b3AgdHJ1bmNhdGUgL21udC9hL2ZvbzExOCAxOApURVNUMTE5OiBUcnVuY2F0ZSB0byAxOQogLSBm
c19vcCB0cnVuY2F0ZSAvbW50L2EvZm9vMTE5IDE5ClRFU1QxMjA6IFRydW5jYXRlIHRvIDIwCiAt
IGZzX29wIHRydW5jYXRlIC9tbnQvYS9mb28xMjAgMjAKVEVTVDEyMTogVHJ1bmNhdGUgdG8gMjEK
IC0gZnNfb3AgdHJ1bmNhdGUgL21udC9hL2ZvbzEyMSAyMQpURVNUMTIyOiBUcnVuY2F0ZSB0byAy
MgogLSBmc19vcCB0cnVuY2F0ZSAvbW50L2EvZm9vMTIyIDIyClRFU1QxMjM6IFRydW5jYXRlIHRv
IDIzCiAtIGZzX29wIHRydW5jYXRlIC9tbnQvYS9mb28xMjMgMjMKVEVTVDEyNDogVHJ1bmNhdGUg
dG8gMjQKIC0gZnNfb3AgdHJ1bmNhdGUgL21udC9hL2ZvbzEyNCAyNApURVNUMTI1OiBUcnVuY2F0
ZSB0byAyNQogLSBmc19vcCB0cnVuY2F0ZSAvbW50L2EvZm9vMTI1IDI1ClRFU1QxMjY6IFRydW5j
YXRlIHRvIDI2CiAtIGZzX29wIHRydW5jYXRlIC9tbnQvYS9mb28xMjYgMjYKVEVTVDEyNzogVHJ1
bmNhdGUgdG8gMjcKIC0gZnNfb3AgdHJ1bmNhdGUgL21udC9hL2ZvbzEyNyAyNwpURVNUMTI4OiBU
cnVuY2F0ZSB0byAyOAogLSBmc19vcCB0cnVuY2F0ZSAvbW50L2EvZm9vMTI4IDI4CioqKgoqKiog
VEVTVF9PVkVSTEFZRlM9MSBURVJNU0xBU0g9MSAuL3J1bi5zaCB0cnVuY2F0ZS50ZXN0CioqKgpU
RVNUMTI5OiBQcmVwYXJlIGNvbXBhcmlzb24KMTYrMCByZWNvcmRzIGluCjE2KzAgcmVjb3JkcyBv
dXQKVEVTVDEwMDogVHJ1bmNhdGUgdG8gMAogLSBmc19vcCB0cnVuY2F0ZSAvbW50L2EvZm9vMTAw
LyAwIC1FIEVOT1RESVIgLUUgRU5PVERJUgpURVNUMTAxOiBUcnVuY2F0ZSB0byAxCiAtIGZzX29w
IHRydW5jYXRlIC9tbnQvYS9mb28xMDEvIDEgLUUgRU5PVERJUiAtRSBFTk9URElSClRFU1QxMDI6
IFRydW5jYXRlIHRvIDIKIC0gZnNfb3AgdHJ1bmNhdGUgL21udC9hL2ZvbzEwMi8gMiAtRSBFTk9U
RElSIC1FIEVOT1RESVIKVEVTVDEwMzogVHJ1bmNhdGUgdG8gMwogLSBmc19vcCB0cnVuY2F0ZSAv
bW50L2EvZm9vMTAzLyAzIC1FIEVOT1RESVIgLUUgRU5PVERJUgpURVNUMTA0OiBUcnVuY2F0ZSB0
byA0CiAtIGZzX29wIHRydW5jYXRlIC9tbnQvYS9mb28xMDQvIDQgLUUgRU5PVERJUiAtRSBFTk9U
RElSClRFU1QxMDU6IFRydW5jYXRlIHRvIDUKIC0gZnNfb3AgdHJ1bmNhdGUgL21udC9hL2ZvbzEw
NS8gNSAtRSBFTk9URElSIC1FIEVOT1RESVIKVEVTVDEwNjogVHJ1bmNhdGUgdG8gNgogLSBmc19v
cCB0cnVuY2F0ZSAvbW50L2EvZm9vMTA2LyA2IC1FIEVOT1RESVIgLUUgRU5PVERJUgpURVNUMTA3
OiBUcnVuY2F0ZSB0byA3CiAtIGZzX29wIHRydW5jYXRlIC9tbnQvYS9mb28xMDcvIDcgLUUgRU5P
VERJUiAtRSBFTk9URElSClRFU1QxMDg6IFRydW5jYXRlIHRvIDgKIC0gZnNfb3AgdHJ1bmNhdGUg
L21udC9hL2ZvbzEwOC8gOCAtRSBFTk9URElSIC1FIEVOT1RESVIKVEVTVDEwOTogVHJ1bmNhdGUg
dG8gOQogLSBmc19vcCB0cnVuY2F0ZSAvbW50L2EvZm9vMTA5LyA5IC1FIEVOT1RESVIgLUUgRU5P
VERJUgpURVNUMTEwOiBUcnVuY2F0ZSB0byAxMAogLSBmc19vcCB0cnVuY2F0ZSAvbW50L2EvZm9v
MTEwLyAxMCAtRSBFTk9URElSIC1FIEVOT1RESVIKVEVTVDExMTogVHJ1bmNhdGUgdG8gMTEKIC0g
ZnNfb3AgdHJ1bmNhdGUgL21udC9hL2ZvbzExMS8gMTEgLUUgRU5PVERJUiAtRSBFTk9URElSClRF
U1QxMTI6IFRydW5jYXRlIHRvIDEyCiAtIGZzX29wIHRydW5jYXRlIC9tbnQvYS9mb28xMTIvIDEy
IC1FIEVOT1RESVIgLUUgRU5PVERJUgpURVNUMTEzOiBUcnVuY2F0ZSB0byAxMwogLSBmc19vcCB0
cnVuY2F0ZSAvbW50L2EvZm9vMTEzLyAxMyAtRSBFTk9URElSIC1FIEVOT1RESVIKVEVTVDExNDog
VHJ1bmNhdGUgdG8gMTQKIC0gZnNfb3AgdHJ1bmNhdGUgL21udC9hL2ZvbzExNC8gMTQgLUUgRU5P
VERJUiAtRSBFTk9URElSClRFU1QxMTU6IFRydW5jYXRlIHRvIDE1CiAtIGZzX29wIHRydW5jYXRl
IC9tbnQvYS9mb28xMTUvIDE1IC1FIEVOT1RESVIgLUUgRU5PVERJUgpURVNUMTE2OiBUcnVuY2F0
ZSB0byAxNgogLSBmc19vcCB0cnVuY2F0ZSAvbW50L2EvZm9vMTE2LyAxNiAtRSBFTk9URElSIC1F
IEVOT1RESVIKVEVTVDExNzogVHJ1bmNhdGUgdG8gMTcKIC0gZnNfb3AgdHJ1bmNhdGUgL21udC9h
L2ZvbzExNy8gMTcgLUUgRU5PVERJUiAtRSBFTk9URElSClRFU1QxMTg6IFRydW5jYXRlIHRvIDE4
CiAtIGZzX29wIHRydW5jYXRlIC9tbnQvYS9mb28xMTgvIDE4IC1FIEVOT1RESVIgLUUgRU5PVERJ
UgpURVNUMTE5OiBUcnVuY2F0ZSB0byAxOQogLSBmc19vcCB0cnVuY2F0ZSAvbW50L2EvZm9vMTE5
LyAxOSAtRSBFTk9URElSIC1FIEVOT1RESVIKVEVTVDEyMDogVHJ1bmNhdGUgdG8gMjAKIC0gZnNf
b3AgdHJ1bmNhdGUgL21udC9hL2ZvbzEyMC8gMjAgLUUgRU5PVERJUiAtRSBFTk9URElSClRFU1Qx
MjE6IFRydW5jYXRlIHRvIDIxCiAtIGZzX29wIHRydW5jYXRlIC9tbnQvYS9mb28xMjEvIDIxIC1F
IEVOT1RESVIgLUUgRU5PVERJUgpURVNUMTIyOiBUcnVuY2F0ZSB0byAyMgogLSBmc19vcCB0cnVu
Y2F0ZSAvbW50L2EvZm9vMTIyLyAyMiAtRSBFTk9URElSIC1FIEVOT1RESVIKVEVTVDEyMzogVHJ1
bmNhdGUgdG8gMjMKIC0gZnNfb3AgdHJ1bmNhdGUgL21udC9hL2ZvbzEyMy8gMjMgLUUgRU5PVERJ
UiAtRSBFTk9URElSClRFU1QxMjQ6IFRydW5jYXRlIHRvIDI0CiAtIGZzX29wIHRydW5jYXRlIC9t
bnQvYS9mb28xMjQvIDI0IC1FIEVOT1RESVIgLUUgRU5PVERJUgpURVNUMTI1OiBUcnVuY2F0ZSB0
byAyNQogLSBmc19vcCB0cnVuY2F0ZSAvbW50L2EvZm9vMTI1LyAyNSAtRSBFTk9URElSIC1FIEVO
T1RESVIKVEVTVDEyNjogVHJ1bmNhdGUgdG8gMjYKIC0gZnNfb3AgdHJ1bmNhdGUgL21udC9hL2Zv
bzEyNi8gMjYgLUUgRU5PVERJUiAtRSBFTk9URElSClRFU1QxMjc6IFRydW5jYXRlIHRvIDI3CiAt
IGZzX29wIHRydW5jYXRlIC9tbnQvYS9mb28xMjcvIDI3IC1FIEVOT1RESVIgLUUgRU5PVERJUgpU
RVNUMTI4OiBUcnVuY2F0ZSB0byAyOAogLSBmc19vcCB0cnVuY2F0ZSAvbW50L2EvZm9vMTI4LyAy
OCAtRSBFTk9URElSIC1FIEVOT1RESVIK
--047d7b873a30bed10204faeb1cc2--
