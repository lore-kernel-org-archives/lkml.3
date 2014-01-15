Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaAOS4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:56:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54872 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaAOS43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:56:29 -0500
Date: Wed, 15 Jan 2014 18:56:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, lgirdwood@gmail.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Message-ID: <20140115185621.GL15567@sirena.org.uk>
References: <20140115191831.5965d17e@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="171LwGa4zcdgM9o6"
Content-Disposition: inline
In-Reply-To: <20140115191831.5965d17e@armhf>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Problems with simple-card
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--171LwGa4zcdgM9o6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 15, 2014 at 07:18:31PM +0100, Jean-Francois Moine wrote:

> The main problem is about sysclk: when there is no clock in the DT,
> you get the clock of the CPU or CODEC DAI. In my system, two clocks
> are declared in the controller CPU DAI, but there is no .set_sysclk
> pointer. So, snd_soc_dai_set_sysclk() returns -EINVAL and the card is
> not created.

set_sysclk() should be returning -ENOTSUPP in this case as with
set_fmt() and the generic code then ignoring that error.

> As I don't know why you need these fmt and sysclk, may you have a
> look at these problems?

The overwhelming majority of combinations of devices need a format
specifying (usually one will be imposed by the system design even if
both devices could be master).

--171LwGa4zcdgM9o6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1tnRAAoJELSic+t+oim9sCwP/08HzC8zw41IlGDD7nJ+pb5f
G3hKT2XHFYeosvHl5IJPVhPN32HyrWDy/RbWAmzFL9kY/eOiUKbjVtuwzxwXYZDt
ozplzooErY2IExK7rMkmHfprQ0R8dCubor3/IuSOsUDtU64bD56NEOc7yY3Evq5W
CzeM7XSKbDwJj4DFZxycXsDpXuoVzqY6myWPflt6RF5EII6AzEArLZlRBodeWTs/
lHHZUMLKMYNZbAZDDABXDEnevXkxy8OssGAdjmm+DPVhcA520MIy9tJ+KnluMiII
qYWfbltYSHg/WvbaUQWmiYaTRjCFKplCLE3FcXVkG0xEb/EFZ4igkzcPLs+SfGay
3KQPG/zomXua1f59bDwgacGKYegGmxG1ztJeJ3W4HMZlBcucXiIPsw0e7nmPbicI
dqEqDAJI11NUIXuOWfWbX+458qV47VVyYtS7lYf9hHZ5HSNi5uh+Xq8GFwOO4Dhe
0ySwQG14cHBpZ1VIao53DyCH+87eW7Z/HIrs9lGh1j6YRx3RmL4tSWRwtk+KTPjU
qwuGkLiI6E9NzvRy5pbdqT81xl29YNafekoWaSebnnXmilPYGdufqSFDOpCuy/nG
2fKvV7jV3rAVVk1eAUc2GC2yZz7PJ0eDq2H6/SttgGzjYoWcDaPK7LwrxU/S3Nko
8Tdfb1SC/ypp+YXmy3BL
=0Umh
-----END PGP SIGNATURE-----

--171LwGa4zcdgM9o6--
