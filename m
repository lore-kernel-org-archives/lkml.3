Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3KBQ7L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 12:59:11 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:50688 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab3KBQ7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 12:59:07 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: =?utf-8?B?0KDRg9GB0YLQsNGE0LAg0JTQttCw0LzRg9GA0LDRhdC80LXRgtC+0LI=?= 
	<zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: w1: make w1_slave::flags long to avoid casts
In-Reply-To: <7061383365433@web15j.yandex.ru>
References: <5083d6c8452b765cb33acdf03fa9b20b1d15c452.1382788496.git.mina86@mina86.com> <20131030155938.0f5416fe3c5c2cbd3f9cd319@linux-foundation.org> <xa1teh71iz3a.fsf@mina86.com> <212981383321699@web5m.yandex.ru> <20131101123041.d08adc9739cf6e733d822770@linux-foundation.org> <7061383365433@web15j.yandex.ru>
User-Agent: Notmuch/0.16+80~g81ee785 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Sat, 02 Nov 2013 17:58:57 +0100
Message-ID: <87y556wxim.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> 01.11.2013, 23:30, "Andrew Morton" <akpm@linux-foundation.org>:
>> set_bit() operates on longs. =C2=A0So if we do
>>
>> struct foo { u32 a; u32 b; } f;
>> set_bit(0, (long *)&f.a);
>>
>> then we'll scribble on f.b on a big-endian 64-bit machine.

On Sat, Nov 02 2013, =D0=A0=D1=83=D1=81=D1=82=D0=B0=D1=84=D0=B0 =D0=94=D0=
=B6=D0=B0=D0=BC=D1=83=D1=80=D0=B0=D1=85=D0=BC=D0=B5=D1=82=D0=BE=D0=B2 <zbr@=
ioremap.net> wrote:
> Argh, why would we just don't do that? Its in-memory field, it can be
> anything, I wouldn't be surprised if it even can be non-atomic because
> of proper locks already being held

If the driver does not require an atomic set_bit operation for setting
and testing the flag, feel free to prepare a patch replacing the whole
thing with a plain bool.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSdS9TAAoJECBgQBJQdR/0LqQP/Aiqje9FKuTZCLozpEbZxKjb
dGfcFlWcuqM6dmiC/5MqE8X0I9iQbQCVK9CY0W+YsqFwpwiY9UOeJoukleaFpmH8
C33egFdgFLTawTTT05vJhUxnfJJYJsH2OlrgHqmS0kB5AGZpBsq7gG11ouPY2aSH
oMaAZ0fngTf+ZP+s/QssbFxXzSjHwh/NUfMfqdnq5Ve+qNqGKYFRjeKyoUf3atwy
g7mCwcZDKMN2E45wd4RDsF9+M0KVhCntiy9FsWVQA7PK4vvsPpXKgCDgDqkAOZVf
qfEAmaHcpPVFe5L/Ft/NnlJ1cKaP1Hfqq387e/q765/HfkXKGEVyCk0qeofp/AGV
WiK11YS44u2TZ1K63jXoLxsnLVRZiJCRQ5kO+0+Oyg2liRkeI8RFIBegI3E7+e2Y
1Q88J1uNIC+eG2vxfHrTcGDjBYWZRfOYIdeGg1iyuugUa7f+b89Zz9qcRzMwvzu0
8D01kN75TODv5ZGAkyVMHRHtBHc6cgd9EgrPTq2L0mu8ePBxPr6SWSMWRD8D7pNt
m5NMepervj4e0uEUNJrBx3NYoG38IvdRigOrdaFXb6avwFxBwn6tXLg5M6uwUK2F
iAJcVkwVLS1RW6VjGSNwD64Psw5emSOVVg3wjsZicuOfg3knrv62kSDmEwvvwifU
g++V8WeMu6nInvUdghtI
=WXT+
-----END PGP SIGNATURE-----
--=-=-=--
