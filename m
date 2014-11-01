Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaKAXaK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:30:10 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:47341 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaKAXaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 19:30:04 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/3] input: alps: Reset mouse before identifying it
Date: Sun, 2 Nov 2014 00:29:59 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Tommy Will <tommywill2011@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com> <201410191307.41313@pali> <20141023154404.GA18714@dtor-ws>
In-Reply-To: <20141023154404.GA18714@dtor-ws>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart14741770.eN6J8Djt2a";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411020029.59838@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart14741770.eN6J8Djt2a
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 23 October 2014 17:44:04 Dmitry Torokhov wrote:
> On Sun, Oct 19, 2014 at 01:07:41PM +0200, Pali Roh=C3=A1r wrote:
> > On Wednesday 15 October 2014 20:22:56 Dmitry Torokhov wrote:
> > > On Wed, Oct 15, 2014 at 08:10:39PM +0200, Pali Roh=C3=A1r wrote:
> > > > On Wednesday 15 October 2014 20:00:11 Dmitry Torokhov=20
wrote:
> > > > > On Wed, Oct 15, 2014 at 07:57:37PM +0200, Pali Roh=C3=A1r=20
wrote:
> > > > > > On Wednesday 15 October 2014 19:43:15 Dmitry
> > > > > > Torokhov
> >=20
> > wrote:
> > > > > > > On Wed, Oct 15, 2014 at 02:53:11PM +0200, Pali
> > > > > > > Roh=C3=A1r
> >=20
> > wrote:
> > > > > > > > On Tuesday 14 October 2014 08:08:34 Dmitry
> > > > > > > > Torokhov
> > > >=20
> > > > wrote:
> > > > > > > > > On Fri, Oct 03, 2014 at 11:47:59AM +0200, Hans
> > > > > > > > > de Goede
> > > > > >=20
> > > > > > wrote:
> > > > > > > > > > Hi,
> > > > > > > > > >=20
> > > > > > > > > > Thanks for working on this!
> > > > > > > > > >=20
> > > > > > > > > > On 10/03/2014 11:43 AM, Pali Roh=C3=A1r wrote:
> > > > > > > > > > > On some systems after starting computer
> > > > > > > > > > > function alps_identify() does not detect
> > > > > > > > > > > dual ALPS touchpad+trackstick device
> > > > > > > > > > > correctly and detect only touchpad.
> > > > > > > > > > >=20
> > > > > > > > > > > Resetting ALPS device before identifiying
> > > > > > > > > > > it fixing this problem and both parts
> > > > > > > > > > > touchpad and trackstick are detected.
> > > > > > > > > > >=20
> > > > > > > > > > > Signed-off-by: Pali Roh=C3=A1r
> > > > > > > > > > > <pali.rohar@gmail.com> Tested-by: Pali
> > > > > > > > > > > Roh=C3=A1r <pali.rohar@gmail.com>
> > > > > > > > > >=20
> > > > > > > > > > Looks good and seems sensible:
> > > > > > > > > >=20
> > > > > > > > > > Acked-by: Hans de Goede
> > > > > > > > > > <hdegoede@redhat.com>
> > > > > > > > >=20
> > > > > > > > > *sigh* I am not really happy about this, as we
> > > > > > > > > making boot longer and longer for people
> > > > > > > > > without ALPS touchpads. It would be better if
> > > > > > > > > we only reset the mouse when we knew we are
> > > > > > > > > dealing with ALPS, and even better if we only
> > > > > > > > > reset it when we suspected that we missed
> > > > > > > > > trackstick. Any chance of doing this?
> > > > > > > > >=20
> > > > > > > > > Thanks.
> > > > > > > >=20
> > > > > > > > Dmitry, problem is that function check which
> > > > > > > > detecting trackstick does not working when I
> > > > > > > > start my laptop from power-off state and do not
> > > > > > > > reset PS/2 device. But detecting ALPS touchpad
> > > > > > > > looks like working. So if do not like this
> > > > > > > > idea, what about doing something like this in
> > > > > > > > alps_dectect function?
> > > > > > > >=20
> > > > > > > > int alps_detect(...)
> > > > > > > > {
> > > > > > > > ...
> > > > > > > > /* detect if device is ALPS */
> > > > > > > > if (alps_identify(...) < 0)
> > > > > > > > return -1;
> > > > > > > > /* now we know that device is ALPS */
> > > > > > > > if (!(flags & ALPS_DUALPOINT)) {
> > > > > > > > /* reset it and identify again, maybe there is
> > > > > > > > trackstick */ psmouse_reset(...);
> > > > > > > > alps_identify(...);
> > > > > > > > }
> > > > > > > > ...
> > > > > > > > }
> > > > > > > >=20
> > > > > > > > It will does not affect non ALPS devices
> > > > > > > > (because first identify call will fail), but
> > > > > > > > will affect ALPS devices without trackstick
> > > > > > > > (because identify will be called twice and
> > > > > > > > reset too).
> > > > > > >=20
> > > > > > > I think this is a step in right direction. Do you
> > > > > > > know what exactly fails in alps_identify() on
> > > > > > > your box if you do not call psmouse_reset?
> > > > > > >=20
> > > > > > > Thanks.
> > > > > >=20
> > > > > > Yes, I know. It is failing in
> > > > > > alps_probe_trackstick_v3(). It calls
> > > > > > alps_command_mode_read_reg(...) and it returns 0
> > > > > > which means trackstick is not there.
> > > > >=20
> > > > > OK, so can we try sticking psmouse_reset() there? This
> > > > > will limit the exposure of the new delay.
> > > > >=20
> > > > > Thanks.
> > > >=20
> > > > Sorry, but I think this is not safe. Function
> > > > psmouse_reset will reset device (set it to relative
> > > > mode, etc...) and before and after
> > > > alps_probe_trackstick_v3() are called other functions.
> > > > So it could break something else.
> > >=20
> > > We might need to repeat bits of alps_identify() after
> > > resetting the mouse, you are right. It should still be
> > > doable though.
> >=20
> > What about checking "E6 report" and if that pass reset
> > device and do full alps_identify? With check for "E6
> > report" we can filter probably all PS/2 devices which are
> > not ALPS.
>=20
> Why don't you pull alps_probe_trackstick_v3() from
> alps_identify(), rename it into __alps_identify() and then
> have real alps_identify be:
>=20
> static int alps_identfy(struct psmouse *psmouse, struct
> alps_data *priv) {
> 	int error;
>=20
> 	error =3D __alps_identify(psmouse, priv);
> 	if (error)
> 		return error;
>=20
> 	if (priv->proto_version =3D=3D ALPS_PROTO_V3 &&
> 	    (priv->flags & ALPS_IS_RUSHMORE)) {
> 		/*
> 		 * Some Dell Lattitudes may not always recognize
> 		 * tracksticks without resetting the device.
> 		 */
> 		psmouse_reset(psmouse);
>=20
> 		error =3D  __alps_identify(psmouse, priv);
> 		if (error)
> 			return error;
>=20
> 		if (alps_probe_trackstick_v3(psmouse,
> 					     ALPS_REG_BASE_RUSHMORE))
> 			priv->flags &=3D ~ALPS_DUALPOINT;
> 	}
>=20
> 	return 0;
> }
>=20
> This way you minimize number of devices exposed to extra
> reset.
>=20
> Thanks.

Hello Dmitry,

I sent new patch series v3 with another solution for fixing this=20
problem. It just effectively move more parts of alps code and=20
trackstick detection should work. It does not introduce new reset=20
call (like in this version) so it is better.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart14741770.eN6J8Djt2a
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRVbPcACgkQi/DJPQPkQ1LSCQCgnpIok32Dp0uSZjWrpaDjVpG1
w04AoIh8rS4ZgpvFb+nffNVGh4Jju5PP
=KqLo
-----END PGP SIGNATURE-----

--nextPart14741770.eN6J8Djt2a--
