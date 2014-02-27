Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbaB0DMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:12:14 -0500
Received: from ozlabs.org ([203.10.76.45]:54535 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbaB0DMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:12:12 -0500
Date: Thu, 27 Feb 2014 14:12:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Regression with wait_event_timeout in next-20140226
Message-Id: <20140227141205.257c6dc9ab6da4fc11ee97ce@canb.auug.org.au>
In-Reply-To: <20140226165043.GA22802@laptop.programming.kicks-ass.net>
References: <530E17C7.1030504@free-electrons.com>
	<20140226165043.GA22802@laptop.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Feb_2014_14_12_05_+1100_=qyQd+eR/_8Gve+l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Feb_2014_14_12_05_+1100_=qyQd+eR/_8Gve+l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Wed, 26 Feb 2014 17:50:43 +0100 Peter Zijlstra <peterz@infradead.org> wr=
ote:
>
> On Wed, Feb 26, 2014 at 05:35:19PM +0100, Gregory CLEMENT wrote:
> >=20
> > while testing next-20140226 I got an issue with the function
> > wait_event_timeout. When this function timed out instead of returning
> > 0, it returned the value of the timeout passed in parameter. I found
> > that reverting "sched/wait: Suppress Sparse 'variable shadowing'
> > warning" fixed this regression.
> >=20
> > I got this issue in the driver drivers/i2c/busses/i2c-mv64xxx.c.
>=20
> Ah indeed. We actually rely on the shadowing for ___wait_cond_timeout().
>=20
> We further used the __ret variable in __wait_event_timeout()'s cmd
> argument: __ret =3D schedule_timeout(__ret). That now explicitly uses the
> wrong __ret.
>=20
> Yeah, we need to pull that patch.

I have reverted that commit from linux-next for today pending some other
resolution.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__27_Feb_2014_14_12_05_+1100_=qyQd+eR/_8Gve+l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDq0JAAoJEMDTa8Ir7ZwV6pwP/0GSEP/c6AFLdFOaFxxDFEYW
ouDBlC+cuexvjc+tdDKABKNRtRqhCqAGj5qxMNNlb9jtNVetoFQLlw/I9qWsAt4M
ADmlsHdKiCVmeGL83DhJIcgdqb1AK0PWnjJbIPyiIjXa5KabF2u7sNaRo1N99F7D
WJskvpcZYAavze7Q7ok0yi5sL8kWIcaDF4mNPw0L6chIoDj5Z8GBS8ku94g5GmKI
IG4uUk156R+e3ChJyCmQGHLhCcc68VrhZ0jp4DBoL31/VLnZDuZoJPVrSaL+6rWs
0wreyZIlwNSIV5qfAasdD67kR7ETAFrP8mgAu+xCR+dltoG4K9MXtwUWGH6pxEfG
fONjvQNX3wK4jwoOwaQXMTZAt/VS/0QZwSZt5/xU8zGLlBzYawYR2LCuAfdRA3bW
Q6rN9FX0obHXo41+5K0LREiZQe4ifJzyVfoUr8Pehv6Vp9iVjvP4McfDrlLoyH5r
ZDQiGNAkWOx6ofE9hk4KzqGfeHFTOocNWiieRFi+2/1E37Qntq4q0MqdQ3Qqd+zG
6kBDZpyynTRO7xRCrcl30oWhOI0J2Ep7fUu6GP/Gu8Y+CjY/fiRx4puGhMgUgcs4
s3PpcVu2f4nC0BeBghS6C/5nH2pmiNpWIWhG5zN33vtgfYqlnDQpfSySRvi3hr4Y
umjzd1oIccQLwVdw/4G0
=FGxf
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Feb_2014_14_12_05_+1100_=qyQd+eR/_8Gve+l--
