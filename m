Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab3CFUA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:00:29 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:51634 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3CFUA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:00:27 -0500
MIME-Version: 1.0
In-Reply-To: <20130306195457.GA449@polaris.bitmath.org>
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
	<20130306080642.GA535@polaris.bitmath.org>
	<51370990.5040508@linux.intel.com>
	<20130306100743.GA407@polaris.bitmath.org>
	<CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com>
	<20130306193612.GA513@polaris.bitmath.org>
	<51379A4F.4020200@linux.intel.com>
	<20130306195457.GA449@polaris.bitmath.org>
Date: Wed, 6 Mar 2013 12:00:27 -0800
X-Google-Sender-Auth: 6KnVJnMgJ7AvUnvPB2ZXCdFY_1A
Message-ID: <CAE9FiQWK0ZnG9o8WgU-pcTPpir=PUyULQqk-TRVC+sh6UpU8VA@mail.gmail.com>
Subject: Re: Linux 3.9-rc1
From: Yinghai Lu <yinghai@kernel.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d04462e0a9a47da04d7470a96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d04462e0a9a47da04d7470a96
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Mar 6, 2013 at 11:54 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> >> Can you check bootloader like grub.efi ?
>> >
>> > I checked, same story. I tried without EFI_STUB, no joy. I ran with
>> > and without nouveau, just in case. Without the patch, everything
>> > works. With the patch, nothing works, and no output at all.
>> >
>> > With a bit of luck, I could maybe get the first lines of output using
>> > grub.efi, but frankly I cannot remember if that ever worked on this
>> > machine.

Found one bug about real_end calculating, it should be PMD_SIZE align.
Otherwise in extreme case we could have less then 2M for the first step.
In your case is about only (1M - 32k) for first step.

Please try attached patch.

Thanks

Yinghai

--f46d04462e0a9a47da04d7470a96
Content-Type: application/octet-stream; name="fix_real_end.patch"
Content-Disposition: attachment; filename="fix_real_end.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdywv3ch0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL2luaXQuYyBiL2FyY2gveDg2L21tL2luaXQuYwppbmRl
eCAyMzkzZDAwLi43YmQ1NTA5IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9tbS9pbml0LmMKKysrIGIv
YXJjaC94ODYvbW0vaW5pdC5jCkBAIC0zNjQsNyArMzY0LDcgQEAgdm9pZCBfX2luaXQgaW5pdF9t
ZW1fbWFwcGluZyh2b2lkKQogCiAJLyogeGVuIGhhcyBiaWcgcmFuZ2UgaW4gcmVzZXJ2ZWQgbmVh
ciBlbmQgb2YgcmFtLCBza2lwIGl0IGF0IGZpcnN0ICovCiAJYWRkciA9IG1lbWJsb2NrX2ZpbmRf
aW5fcmFuZ2UoSVNBX0VORF9BRERSRVNTLCBlbmQsIFBNRF9TSVpFLAotCQkJIFBBR0VfU0laRSk7
CisJCQkgUE1EX1NJWkUpOwogCXJlYWxfZW5kID0gYWRkciArIFBNRF9TSVpFOwogCiAJLyogc3Rl
cF9zaXplIG5lZWQgdG8gYmUgc21hbGwgc28gcGd0X2J1ZiBmcm9tIEJSSyBjb3VsZCBjb3ZlciBp
dCAqLwo=
--f46d04462e0a9a47da04d7470a96--
