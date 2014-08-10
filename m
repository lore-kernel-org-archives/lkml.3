Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226AbaHJFzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 01:55:07 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:60561 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaHJFzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 01:55:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
References: <53E62EEF.9040801@gmail.com>
	<CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
	<20140809192302.GJ15082@console-pimps.org>
	<CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
Date: Sat, 9 Aug 2014 22:55:03 -0700
X-Google-Sender-Auth: L-UgRMIRkrT0pQOy5Ywg13oMXyo
Message-ID: <CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>
Subject: Re: Loading initrd above 4G causes freeze on boot
From: Yinghai Lu <yinghai@kernel.org>
To: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf3036405b673236050040140d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3036405b673236050040140d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 9, 2014 at 3:45 PM, Mantas Mikul=C4=97nas <grawity@gmail.com> w=
rote:
> On Sat, Aug 9, 2014 at 10:23 PM, Matt Fleming <matt@console-pimps.org> wr=
ote:
> [However... Whether it's five chunks, four (after making the initrd
> smaller), or just one (with your efi=3Dnochunk), I noticed that it
> *always* hangs during the *last* read, and the allocated memory always
> ends at roughly the same address (0x137fffXXX). I wonder if it's
> selecting a memory location already in use, or something like that...]
>
> (The laptop is Asus K52JT, AMI firmware v206, no updates available.)

wonder if  efi_file_read return with wrong chunksize.

Can you try attached patch ?

Thanks

Yinghai

--20cf3036405b673236050040140d
Content-Type: text/x-patch; charset=US-ASCII; name="efi_file_read_debug.patch"
Content-Disposition: attachment; filename="efi_file_read_debug.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hynx35dq0

LS0tCiBkcml2ZXJzL2Zpcm13YXJlL2VmaS9saWJzdHViL2VmaS1zdHViLWhlbHBlci5jIHwgICAg
MyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCklu
ZGV4OiBsaW51eC0yLjYvZHJpdmVycy9maXJtd2FyZS9lZmkvbGlic3R1Yi9lZmktc3R1Yi1oZWxw
ZXIuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL2Zpcm13YXJlL2VmaS9s
aWJzdHViL2VmaS1zdHViLWhlbHBlci5jCisrKyBsaW51eC0yLjYvZHJpdmVycy9maXJtd2FyZS9l
ZmkvbGlic3R1Yi9lZmktc3R1Yi1oZWxwZXIuYwpAQCAtNDMxLDcgKzQzMSw4IEBAIGVmaV9zdGF0
dXNfdCBoYW5kbGVfY21kbGluZV9maWxlcyhlZmlfc3kKIAkJCQlzdGF0dXMgPSBlZmlfZmlsZV9y
ZWFkKGZpbGVzW2pdLmhhbmRsZSwKIAkJCQkJCSAgICAgICAmY2h1bmtzaXplLAogCQkJCQkJICAg
ICAgICh2b2lkICopYWRkcik7Ci0JCQkJaWYgKHN0YXR1cyAhPSBFRklfU1VDQ0VTUykgeworCQkJ
CWlmIChzdGF0dXMgIT0gRUZJX1NVQ0NFU1MgfHwKKwkJCQkgICAgY2h1bmtzaXplID4gc2l6ZSB8
fCAhY2h1bmtzaXplKSB7CiAJCQkJCXByX2VmaV9lcnIoc3lzX3RhYmxlX2FyZywgIkZhaWxlZCB0
byByZWFkIGZpbGVcbiIpOwogCQkJCQlnb3RvIGZyZWVfZmlsZV90b3RhbDsKIAkJCQl9Cg==
--20cf3036405b673236050040140d--
