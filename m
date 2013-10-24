Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3JXPP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:15:28 -0400
Received: from forward16.mail.yandex.net ([95.108.253.141]:39427 "EHLO
	forward16.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3JXPP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:15:27 -0400
From: Konstantin Tokarev <annulen@yandex.ru>
To: Yann Collet <yann.collet.73@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Brent Taylor <motobud@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
In-Reply-To: <237221382623942@web21m.yandex.ru>
References: <55541379679397@web20h.yandex.ru>
 <CAP+RiCAVuUEfyjg02+ZjeFXgUuaRW+fuMB490Ce2Hq_4qHBL=A@mail.gmail.com>
 <loom.20131023T201657-894@post.gmane.org> <237221382623942@web21m.yandex.ru>
Subject: Re: lz4hc compression in UBIFS?
MIME-Version: 1.0
Message-Id: <106621382627723@web13g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 24 Oct 2013 19:15:23 +0400
Content-Type: multipart/mixed;
	boundary="----==--bound.10663.web13g.yandex.ru"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


------==--bound.10663.web13g.yandex.ru
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r



24.10.2013, 18:20, "Konstantin Tokarev" <annulen@yandex.ru>:
> 23.10.2013, 22:26, "Yann Collet" <yann.collet.73@gmail.com>:
>
>> šUBIFS error (pid 4288): ubifs_decompress: cannot decompress 12 bytes,
>> š(...)
>> šššššššššdata size ššššš12
>> šššššššššdata:
>> ššššššššš00000000: 1f 00 01 00 ff e8 50 00 00 00 00 00
>>
>> šThe compressed format is correct.
>> šIt describes a flow of 00, of size ~500.
>>
>> šSo the problem seems more likely on the decompression side.
>>
>> šAre you sure you are providing "12" as the "input size" parameter ? and that
>> šthe "maximum output size" parameter is correctly provided ? (i.e. >= to
>> šoriginal data size)
>
> Decompression code in kernel[1] is heavily modified. In particular, lz4_uncompress
> function (used in this case) does not have input size parameter at all,
> while it's present in lz4_uncompress_unknownoutputsize.
>
> [1] lib/lz4/lz4_decompress.c

Attached patch to crypto API wrapper for lz4hc seems to fix the issue. I can save
and read files on LZ4HC-compressed volume, and I'm running on LZ4HC-compressed rootfs,
flashed from mkfs.ubifs generated image (patch by Elie De Brauwer). My software
works correctly.

Unfortunately, on my board LZ4HC-compressed UBIFS volume performs noticeable worse
than LZO, while still faster than zlib. I guess the reason is that CPU is no longer a
bottleneck for my system, but NAND speed.

Thank you all for your help!

-- 
Regards,
Konstantin
------==--bound.10663.web13g.yandex.ru
Content-Disposition: attachment;
	filename="crypto_lz4.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-diff;
	name="crypto_lz4.patch"

ZGlmZiAtLWdpdCBhL2NyeXB0by9sejQuYyBiL2NyeXB0by9sejQuYwppbmRleCA0NTg2ZGQxLi45
MWEwNjEzIDEwMDY0NAotLS0gYS9jcnlwdG8vbHo0LmMKKysrIGIvY3J5cHRvL2x6NC5jCkBAIC02
Niw5ICs2Niw4IEBAIHN0YXRpYyBpbnQgbHo0X2RlY29tcHJlc3NfY3J5cHRvKHN0cnVjdCBjcnlw
dG9fdGZtICp0Zm0sIGNvbnN0IHU4ICpzcmMsCiB7CiAJaW50IGVycjsKIAlzaXplX3QgdG1wX2xl
biA9ICpkbGVuOwotCXNpemVfdCBfX3NsZW4gPSBzbGVuOwogCi0JZXJyID0gbHo0X2RlY29tcHJl
c3Moc3JjLCAmX19zbGVuLCBkc3QsIHRtcF9sZW4pOworCWVyciA9IGx6NF9kZWNvbXByZXNzX3Vu
a25vd25vdXRwdXRzaXplKHNyYywgc2xlbiwgZHN0LCAmdG1wX2xlbik7CiAJaWYgKGVyciA8IDAp
CiAJCXJldHVybiAtRUlOVkFMOwogCmRpZmYgLS1naXQgYS9jcnlwdG8vbHo0aGMuYyBiL2NyeXB0
by9sejRoYy5jCmluZGV4IDE1MWJhMzEuLjk5ODc3NDEgMTAwNjQ0Ci0tLSBhL2NyeXB0by9sejRo
Yy5jCisrKyBiL2NyeXB0by9sejRoYy5jCkBAIC02Niw5ICs2Niw4IEBAIHN0YXRpYyBpbnQgbHo0
aGNfZGVjb21wcmVzc19jcnlwdG8oc3RydWN0IGNyeXB0b190Zm0gKnRmbSwgY29uc3QgdTggKnNy
YywKIHsKIAlpbnQgZXJyOwogCXNpemVfdCB0bXBfbGVuID0gKmRsZW47Ci0Jc2l6ZV90IF9fc2xl
biA9IHNsZW47CiAKLQllcnIgPSBsejRfZGVjb21wcmVzcyhzcmMsICZfX3NsZW4sIGRzdCwgdG1w
X2xlbik7CisJZXJyID0gbHo0X2RlY29tcHJlc3NfdW5rbm93bm91dHB1dHNpemUoc3JjLCBzbGVu
LCBkc3QsICZ0bXBfbGVuKTsKIAlpZiAoZXJyIDwgMCkKIAkJcmV0dXJuIC1FSU5WQUw7CiAK
------==--bound.10663.web13g.yandex.ru--
