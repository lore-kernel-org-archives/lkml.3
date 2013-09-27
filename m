Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab3I0HP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 03:15:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52452 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab3I0HPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 03:15:55 -0400
Message-ID: <524530A4.9060300@ti.com>
Date: Fri, 27 Sep 2013 10:15:48 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: John Tapsell <johnflux@gmail.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Dave Airlie <airlied@redhat.com>, <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbcon: fix deadlock in fbcon_generic_blank()
References: <CAHQ6N+q13YeM60S_QfRF8Bh+Vc_7yHhCMSABQ=GOtOe5V0EXow@mail.gmail.com>
In-Reply-To: <CAHQ6N+q13YeM60S_QfRF8Bh+Vc_7yHhCMSABQ=GOtOe5V0EXow@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="gnvICsxd21nxsqbVavbNslHgRFpjfUIUI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gnvICsxd21nxsqbVavbNslHgRFpjfUIUI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 18/09/13 01:29, John Tapsell wrote:
> Do not lock fb_info when calling sending the FB_EVENT_CONBLANK
> event.
>=20
> In fbmem.c, the semantics are that we acquire the lock_fb_info first,
> and then console_lock.  However when fbcon.c fbcon_generic_blank() is
> called, the console lock could already be held.  Locking fb_info can
> thus cause a deadlock.

So has this happened for you? Or is it just theoretical?

> fbmem.c sends the FB_EVENT_BLANK without locking lock_fb_info first, so=

> this change introduces similar behaviour.

I don't think this is true. FB_EVENT_BLANK is sent in fb_blank(). That
one is called when FBIOBLANK ioctl is called, and it does lock_fb_info().=


I'm not familiar with the console code, but removing a lock makes me
feel rather uneasy... But looking at the code, I can also see that
console_lock could already be held, so something here definitely looks
broken.

The only place using FB_EVENT_CONBLANK seems to be backlight, and if I'm
not mistaken, it has its own lock, and doesn't depend on the fb_info
being locked.

 Tomi



--gnvICsxd21nxsqbVavbNslHgRFpjfUIUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSRTCkAAoJEPo9qoy8lh71PLsP/jDZyST05C3eKDZusDHUpV5b
Q3KapU0A26GqSf6jiGZzCMz2sHVCdfaZFlB+02IS01bmY4Kx2AuFdfAZwgOEb73W
x9RACkqpD9C39Weal0fLhtbpvUcsFxzwGJUYXwOL/ZGkwGW4n7t8QBwVCcANn5o2
xGyrLZeC8H7uiC5EcTfkej0cOHsdkTTLB2ON7tu/+VWZzs5x7ZYo5uYTjO2VC3x2
85zYcV+jV/SaAx74SRuiukcnH3DGgFP5/0ZvWbCyOdjI7XQKjwNMbMoD8zPCAQ57
vRBcfoiztcxuzuu9llOHFSvsilKEFcYVhQpuGhwUaf03MmZFfw8VoG+VckqiUApV
p31UdORFPEbCn0TIJ6SQct8cn4Br69vZkHHZ7IFs+O5YrIF0CKil4NdwDef1hg6/
F4GsnS0iVv1MRFRXJCA/zRKr4XuE2yy/N1EW/hKguoXTwLbhKxH460ditDgI/0mu
hi/QSVw8Ud/jbpUEzZ0Euqs2zXjpZ/IdfGzvLKLa7h4vXW+xzMTGnSQcAcuajewG
gFQD5ks2d3Rp0hLxxqTJQE5zkcoVrHoBRUtyuzuHQ5QRDP5jS3+R/vR8KgiLfgT3
vZsLHlqsDKV+K1AneK2zmqofxR9/zec9nZsEdFZDcZ/yAVm5AGs7YEHNkTp7N6VW
V5xBboDoDdrxJAAPt/Dr
=+yfv
-----END PGP SIGNATURE-----

--gnvICsxd21nxsqbVavbNslHgRFpjfUIUI--
