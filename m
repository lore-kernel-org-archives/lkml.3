Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935647Ab3DINeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:34:04 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33215 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760658Ab3DINeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:34:03 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUU2dHLz_iWCiJkgnU8HpkWeWbGL0niAoBzoE55CLuvRiQ@mail.gmail.com>
References: <CA+icZUX-RMW=pHzhOumB2_R99BRAf2qGC4n5bzyLqU6pOCMDFw@mail.gmail.com>
	<CA+icZUU2dHLz_iWCiJkgnU8HpkWeWbGL0niAoBzoE55CLuvRiQ@mail.gmail.com>
Date: Tue, 9 Apr 2013 15:34:01 +0200
Message-ID: <CA+icZUVpJcBCOOd7zC=mi_2U+aC8u+WCBfDBZNnut7XVX3Ps7Q@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 9
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7bfd0c2e335e6c04d9ed9b40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bfd0c2e335e6c04d9ed9b40
Content-Type: text/plain; charset=UTF-8

On Tue, Apr 9, 2013 at 2:37 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Apr 9, 2013 at 12:56 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> Hi,
>>
>> I still did not get the original posting...
>>
>> This version hangs... I started in rescue-mode and see that udev,
>> premount and init scripts are run.
>
> ... udevd ....
> /scripts/init-premount ... done
> /scripts/pre-premount ... done
> /scripts/local-bottom ... done
> /scripts/init-bottom ... <--- hanging here!
>

Looks like a problem with udev.

# ll
insgesamt 16
drwxr-xr-x  4 root root 4096 Apr  9 15:31 ./
drwxr-xr-x  4 root root 4096 Apr  9 15:31 ../
drwxr-xr-x 10 root root 4096 Apr  9 15:31 initrd-unpacked/
drwxr-xr-x  2 root root 4096 Apr  9 15:31 original/

# ll original/
insgesamt 3216
drwxr-xr-x 2 root root    4096 Apr  9 15:31 ./
drwxr-xr-x 4 root root    4096 Apr  9 15:31 ../
-rw-r--r-- 1 root root 3277802 Apr  9 12:36
initrd.img-3.9.0-rc6-next20130409-1-iniza-small

# cd initrd-unpacked/

# ll scripts/init-bottom/
insgesamt 16
drwxr-xr-x 2 root root 4096 Apr  9 15:30 ./
drwxr-xr-x 8 root root 4096 Apr  9 15:27 ../
-rw-r--r-- 1 root root   72 Apr  9 15:27 ORDER
-rwxr-xr-x 1 root root  396 Apr  9 15:27 udev*

Both files attached.

> - Sedat -
>
>> Currently, I have no glue why when what...
>> Lemme see if I get k(g)bd started.
>>
>> Unfortunately, there was a "quiet" boot-param for grub2 here but it's gone.
>> With "text" I don't see more.
>>
>> Maybe, someone has a hint.
>>
>> Regards,
>> - Sedat -
>>
>>
>>
>> [1] http://marc.info/?l=linux-next&m=136549987718448&w=2

--047d7bfd0c2e335e6c04d9ed9b40
Content-Type: application/octet-stream; name=ORDER
Content-Disposition: attachment; filename=ORDER
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfb40xxz0

L3NjcmlwdHMvaW5pdC1ib3R0b20vdWRldgpbIC1lIC9jb25mL3BhcmFtLmNvbmYgXSAmJiAuIC9j
b25mL3BhcmFtLmNvbmYK
--047d7bfd0c2e335e6c04d9ed9b40
Content-Type: application/octet-stream; name=udev
Content-Disposition: attachment; filename=udev
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfb411rp1

IyEvYmluL3NoIC1lCiMgaW5pdHJhbWZzIGluaXQtYm90dG9tIHNjcmlwdCBmb3IgdWRldgoKUFJF
UkVRPSIiCgojIE91dHB1dCBwcmUtcmVxdWlzaXRlcwpwcmVyZXFzKCkKewoJZWNobyAiJFBSRVJF
USIKfQoKY2FzZSAiJDEiIGluCiAgICBwcmVyZXFzKQoJcHJlcmVxcwoJZXhpdCAwCgk7Owplc2Fj
CgoKIyBTdG9wIHVkZXZkLCB3ZSdsbCBtaXNzIGEgZmV3IGV2ZW50cyB3aGlsZSB3ZSBydW4gaW5p
dCwgYnV0IHdlIGNhdGNoIHVwCnVkZXZhZG0gY29udHJvbCAtLXRpbWVvdXQ9MTIxIC0tZXhpdCB8
fCBcCgllY2hvICJ1ZGV2IGV4aXQgZmFpbGVkIC0tIHJjPSQ/IgoKIyBNb3ZlIC9kZXYgdG8gdGhl
IHJlYWwgZmlsZXN5c3RlbQptb3VudCAtbiAtbyBtb3ZlIC9kZXYgJHtyb290bW50fS9kZXYK
--047d7bfd0c2e335e6c04d9ed9b40--
