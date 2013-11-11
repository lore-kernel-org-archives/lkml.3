Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3KKN7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:59:42 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59457 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3KKN7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:59:35 -0500
Message-ID: <5280E2BF.7040602@ti.com>
Date: Mon, 11 Nov 2013 15:59:27 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH 1/2] fb: reorder the lock sequence to fix potential
 dead lock
References: <5278C1D9.9030101@cn.fujitsu.com>
In-Reply-To: <5278C1D9.9030101@cn.fujitsu.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="nJt3jp1DomlXBHcfhEVR3rrMtN36rrti8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nJt3jp1DomlXBHcfhEVR3rrMtN36rrti8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-11-05 12:00, Gu Zheng wrote:
> Following commits:
> 50e244cc79 fb: rework locking to fix lock ordering on takeover
> e93a9a8687 fb: Yet another band-aid for fixing lockdep mess
> 054430e773 fbcon: fix locking harder
> reworked locking to fix related lock ordering on takeover, and introduc=
ed console_lock
> into fbmem, but it seems that the new lock sequence(fb_info->lock ---> =
console_lock)
> is against with the one in console_callback(console_lock ---> fb_info->=
lock), and leads to
> a potential dead lock as following:

<snip>

> so we reorder the lock sequence the same as it in console_callback() to=

> avoid this issue. And following Tomi's suggestion, fix these similar
> issues all in fb subsystem.
>=20
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  drivers/video/fbmem.c            |   50 ++++++++++++++++++++++++------=
-------
>  drivers/video/fbsysfs.c          |   19 ++++++++++----
>  drivers/video/sh_mobile_lcdcfb.c |   10 ++++---
>  3 files changed, 51 insertions(+), 28 deletions(-)

I'll apply this for 3.13. It's a bit difficult to verify if the locking
is now correct, but looks fine to me. And we can revert this easily if
things break badly.

 Tomi



--nJt3jp1DomlXBHcfhEVR3rrMtN36rrti8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSgOK/AAoJEPo9qoy8lh71/bkP/2KxMXpFvNl5ETWJo0xwSiE0
HREPejr2vLa2GBhZdzcmn5e52rtUly88Mvxl6vIUKYHWJuxKzR0vlcWCggw7UrNi
q3TTMn7QdfDyWAEzMJV435Ii3U5ZevoksupW/V+LRErzuq/Recd5Mq4AaofSd4+w
SqGkz68Ho1u2Y/oHaDAMpMsscpbQM+3TYOMTbFb75awkFb/9ubL6kvRNasdz9FJz
d/4GjaHPnxAkxMrn9iwvf6TJWxKyQqVrDW//Qsvyeh+FiiPEOGrfSwsoob5+mtcE
yhk54DGsEf9r1anPzdaTXOz0EULKfyVWxXQ9EEUWnF2iG99MpIetS92vkuOgYvfd
50THGhmUlyyWIleQ0sZ4ukrNQIW47LPRQbK5YZSADRm9Do5FEsMEK+GupIiDOFIc
Qm/Kaz4+fCcVS0ZhhDj0PE5DAWXmrD6p6Hqz4KUdXxPlg9sI/Zgoa3om8ld7ZC+R
vQBie+ZNg+3W1PKYzloLqUCpKgImV1oEK8XiT3VHV0vU7+iSO5YuLFGgM5yhQjMT
Y+cZwbh48DFDNQB9sznDk5EshIBJnXFcSAF+aDmuPTLcnGWVE7CcXvLI3New16rf
PHwuzGAxAzCQkWY8S420psPJSKjBvDZgV+8aGwAxYJeOTlVSgdnOPKJP8fnZ84um
m+Okbm7dBDz4O/8BAUE2
=tTk5
-----END PGP SIGNATURE-----

--nJt3jp1DomlXBHcfhEVR3rrMtN36rrti8--
