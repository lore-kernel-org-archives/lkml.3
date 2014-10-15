Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbaJOR5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:57:44 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47688 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaJOR5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:57:42 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/3] input: alps: Reset mouse before identifying it
Date: Wed, 15 Oct 2014 19:57:37 +0200
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com> <201410151453.12115@pali> <20141015174315.GA1968@dtor-ws>
In-Reply-To: <20141015174315.GA1968@dtor-ws>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1463637.NoubF65mUi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201410151957.37855@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1463637.NoubF65mUi
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 15 October 2014 19:43:15 Dmitry Torokhov wrote:
> On Wed, Oct 15, 2014 at 02:53:11PM +0200, Pali Roh=C3=A1r wrote:
> > On Tuesday 14 October 2014 08:08:34 Dmitry Torokhov wrote:
> > > On Fri, Oct 03, 2014 at 11:47:59AM +0200, Hans de Goede=20
wrote:
> > > > Hi,
> > > >=20
> > > > Thanks for working on this!
> > > >=20
> > > > On 10/03/2014 11:43 AM, Pali Roh=C3=A1r wrote:
> > > > > On some systems after starting computer function
> > > > > alps_identify() does not detect dual ALPS
> > > > > touchpad+trackstick device correctly and detect only
> > > > > touchpad.
> > > > >=20
> > > > > Resetting ALPS device before identifiying it fixing
> > > > > this problem and both parts touchpad and trackstick
> > > > > are detected.
> > > > >=20
> > > > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > > > Tested-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > >=20
> > > > Looks good and seems sensible:
> > > >=20
> > > > Acked-by: Hans de Goede <hdegoede@redhat.com>
> > >=20
> > > *sigh* I am not really happy about this, as we making boot
> > > longer and longer for people without ALPS touchpads. It
> > > would be better if we only reset the mouse when we knew
> > > we are dealing with ALPS, and even better if we only
> > > reset it when we suspected that we missed trackstick. Any
> > > chance of doing this?
> > >=20
> > > Thanks.
> >=20
> > Dmitry, problem is that function check which detecting
> > trackstick does not working when I start my laptop from
> > power-off state and do not reset PS/2 device. But detecting
> > ALPS touchpad looks like working. So if do not like this
> > idea, what about doing something like this in alps_dectect
> > function?
> >=20
> > int alps_detect(...)
> > {
> > ...
> > /* detect if device is ALPS */
> > if (alps_identify(...) < 0)
> > return -1;
> > /* now we know that device is ALPS */
> > if (!(flags & ALPS_DUALPOINT)) {
> > /* reset it and identify again, maybe there is trackstick */
> > psmouse_reset(...);
> > alps_identify(...);
> > }
> > ...
> > }
> >=20
> > It will does not affect non ALPS devices (because first
> > identify call will fail), but will affect ALPS devices
> > without trackstick (because identify will be called twice
> > and reset too).
>=20
> I think this is a step in right direction. Do you know what
> exactly fails in alps_identify() on your box if you do not
> call psmouse_reset?
>=20
> Thanks.

Yes, I know. It is failing in alps_probe_trackstick_v3(). It=20
calls alps_command_mode_read_reg(...) and it returns 0 which=20
means trackstick is not there.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1463637.NoubF65mUi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlQ+tZEACgkQi/DJPQPkQ1LGKQCeLa6ANKEYU7zJrywwKGryGIvu
ZQEAn2/4Fsa9Q9W0e584PrsNmg0KgRMy
=lzgw
-----END PGP SIGNATURE-----

--nextPart1463637.NoubF65mUi--
