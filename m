Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaBKMTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:19:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60326 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbaBKMTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:19:04 -0500
Message-ID: <52FA1531.2080109@ti.com>
Date: Tue, 11 Feb 2014 14:18:57 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] fbcon: Clean up fbcon data in fb_info on FB_EVENT_FB_UNBIND
 with 0 fbs
References: <1390253470-23594-1-git-send-email-keithp@keithp.com>
In-Reply-To: <1390253470-23594-1-git-send-email-keithp@keithp.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="qAtSr1hUsLXVD7h6UnOVUIOsS0tXFOEfn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qAtSr1hUsLXVD7h6UnOVUIOsS0tXFOEfn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 20/01/14 23:31, Keith Packard wrote:
> When FB_EVENT_FB_UNBIND is sent, fbcon has two paths, one path taken
> when there is another frame buffer to switch any affected vcs to and
> another path when there isn't.
>=20
> In the case where there is another frame buffer to use,
> fbcon_fb_unbind calls set_con2fb_map to remap all of the affected vcs
> to the replacement frame buffer. set_con2fb_map will eventually call
> con2fb_release_oldinfo when the last vcs gets unmapped from the old
> frame buffer.
>=20
> con2fb_release_oldinfo frees the fbcon data that is hooked off of the
> fb_info structure, including the cursor timer.
>=20
> In the case where there isn't another frame buffer to use,
> fbcon_fb_unbind simply calls fbcon_unbind, which doesn't clear the
> con2fb_map or free the fbcon data hooked from the fb_info
> structure. In particular, it doesn't stop the cursor blink timer. When
> the fb_info structure is then freed, we end up with a timer queue
> pointing into freed memory and "bad things" start happening.
>=20
> This patch first changes con2fb_release_oldinfo so that it can take a
> NULL pointer for the new frame buffer, but still does all of the
> deallocation and cursor timer cleanup.
>=20
> Finally, the patch tries to replicate some of what set_con2fb_map does
> by clearing the con2fb_map for the affected vcs and calling the
> modified con2fb_release_info function to clean up the fb_info structure=
=2E
>=20
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/video/console/fbcon.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)

Thanks, queued for 3.15.

 Tomi



--qAtSr1hUsLXVD7h6UnOVUIOsS0tXFOEfn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS+hUxAAoJEPo9qoy8lh71M5cP/2CVjhWMZArVxAml/DO5kMF6
9avEEBc7pIk50NhQ/YmMRIfW2uNoiv0LNsLtZHXjpbSgE7E2kFFn47uBu8FyiAGc
rwzKeHbV450o47VyWO5bRk8a/ymwX9kSUyZ9juJW8OQSdYiWlxmgIYrL47scImxz
DPkiEIKvDon2ClAYcdAoAi3nBJ6vZLbt4psW7Mqvsq7PCUEoh50RuTvYlxyeAlu9
7NFaIxOb/qPqfdJZE63UivtIU6ARTQDQq4a7K6tiL46fmx8pjj5AjjoNSjNk0Q0N
TjBAQrD8XhnLDcAS5T4Z80nQGT9xqdT8hNf0jwTOlwi8n+VwOhop8vRQvOsLtRgq
rwRNq8on9h5yaWyRq5ODPC3XWm3r/Puw6xLHQ4JyXbdAQn2/SKRfU9pIZG6pSvP0
Y5TZX+YazgYx9edY0+1CDJByuxKSHPTcU6I7UKVjl+fxT3KDuYkBYsrMPUaG+GyA
sfkDsHicf0+4y7dKTsWIYn54/1oJnBujCdvdtvSqSAU0XAQHvVTA8f2zXo5OYLuu
7YKH94Gzl27CFU2xiVjlpsi8EPGSqZ2A6PBPVEiviPqKYwAtwIzfwxNnqn94AUUs
4ZhmIOYHWJ2NGO3RV166/Ul4fxThJx64phz1ou/PQyGEgXV6x0ZlJv0Fw08HCyP+
7OHUOmXwD9LVw1IrJkSC
=fRHj
-----END PGP SIGNATURE-----

--qAtSr1hUsLXVD7h6UnOVUIOsS0tXFOEfn--
