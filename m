Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3JYSV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 14:21:57 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:60192 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab3JYSVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 14:21:55 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Bryan Wu <cooloney@gmail.com>
Subject: Re: [PATCH 00/10] leds: lp5521,5523: restore device attributes for running LED patterns
Date: Fri, 25 Oct 2013 20:21:50 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Milo Kim <woogyom.kim@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Milo Kim <milo.kim@ti.com>
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com> <201310251838.32001@pali> <CAK5ve-JrQhpwx9ZG1Kyhuxdc=dqfAaA6YBOMkDWYWrefeoeUxw@mail.gmail.com>
In-Reply-To: <CAK5ve-JrQhpwx9ZG1Kyhuxdc=dqfAaA6YBOMkDWYWrefeoeUxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1755462.hRsu2P9x4A";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201310252021.51846@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1755462.hRsu2P9x4A
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 25 October 2013 19:10:07 Bryan Wu wrote:
> On Fri, Oct 25, 2013 at 9:38 AM, Pali Roh=C3=A1r=20
<pali.rohar@gmail.com> wrote:
> > On Tuesday 13 August 2013 23:04:14 Bryan Wu wrote:
> >> On Thu, Aug 8, 2013 at 12:59 AM, Milo Kim=20
<woogyom.kim@gmail.com> wrote:
> >> > This patch-set resolves the application conflict by
> >> > restoring sysfs files.
> >> >=20
> >> > For LP5521
> >> >=20
> >> >   engine1/2/3_mode
> >> >   engine1/2/3_load
> >> >=20
> >> > For LP5523
> >> >=20
> >> >   engine1/2/3_mode
> >> >   engine1/2/3_load
> >> >   engine1/2/3_leds
> >> >=20
> >> > Those attributes are accessed when LED pattern is run by
> >> > custom application. Those were removed when LED pattern
> >> > interface was changed to generic firmware interface.
> >> > Please refer to commits below.
> >> >=20
> >> >   git commit 9ce7cb170f97f83a78dc948bf7d25690f15e1328
> >> >   (leds-lp5521: use generic firmware interface)
> >> >  =20
> >> >   git commit db6eaf8388a413a5ee1b4547ce78506b9c6456b0
> >> >   (leds-lp5523: use generic firmware interface)
> >> >=20
> >> > Necessary attributes are restored in this patch-set.
> >> >=20
> >> > (Other changes)
> >> > New data structure is added for handling values from/to
> >> > an application. Few code fixes for reducing writing I2C
> >> > commands.
> >> > Add LP55xx common macros for code refactoring.
> >> > Documentation updates.
> >> >=20
> >> > You can also pull from the location below
> >> > This branch is based on 'for-next' of linux-leds.
> >> >=20
> >> >   https://github.com/milokim/lp55xx.git
> >> >   resolve-missing-sysfs
> >>=20
> >> Thanks, I've already merged the whole patchset in my -devel
> >> branch [1].
> >>=20
> >> Pali, could you please help to test it on your hardware?
> >> Just grab my -devel branch and build then run.
> >>=20
> >> Thanks,
> >> -Bryan
> >=20
> > Hi, I see that all your patches are part of 3.12-rc5 kernel.
> >=20
> > Now I tested this example led program:
> >     # Clearing LED-state to be sure
> >     echo "disabled" >
> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine1_mode echo
> >     "disabled" >
> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine2_mode echo 0
> >     > /sys/class/leds/lp5523:r/brightness
> >     echo 0 > /sys/class/leds/lp5523:g/brightness
> >     echo 0 > /sys/class/leds/lp5523:b/brightness
> >    =20
> >     # Setting yellow light pattern and running it
> >     echo "load" >
> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine1_mode echo
> >     "000001100" >
> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine1_leds echo
> >     "9d804000427f0d7f7f007f0042000000" >
> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine1_load echo
> >     "load" >
> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine2_mode echo
> >     "000000000" >
> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine2_leds echo
> >     "9d800000" >
> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine2_load echo
> >     "run" >
> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine2_mode echo
> >     "run" >
> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine1_mode echo
> >     20 > /sys/class/leds/lp5523:r/led_current
> >     echo 2 > /sys/class/leds/lp5523:g/led_current
> >     echo 0 > /sys/class/leds/lp5523:b/led_current
> >=20
> > All sysfs entries exists and every echo returned 0.
> >=20
> > But led does not start blinking that yellow ligh pattern.
> > So it not working on 3.12-rc5 kernel :-(
>=20
> OK, great! Do you still remember which kernel version works on
> you system? Milo, do you have time to take a look? I bet it's
> a regression somewhere.
>=20
> Thanks,
> -Bryan

I do not know which version. Now I tried pattern example from=20
Documentation/leds/leds-lp55xx.txt which using new API.

echo 2 > /sys/class/i2c-adapter/i2c-2/2-0032/select_engine
echo 1 > /sys/class/firmware/lp5523/loading
echo "9d80400004ff05ff437f0000" > /sys/class/firmware/lp5523/data
echo 0 > /sys/class/firmware/lp5523/loading
echo 1 > /sys/class/i2c-adapter/i2c-2/2-0032/run_engine

But it failed at second command. In directory /sys/class/firmware/=20
I have only one file with name timeout. Nothing more, no lp5523=20
folder.

Any idea who and when creating that lp5523 folder?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1755462.hRsu2P9x4A
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlJqtr8ACgkQi/DJPQPkQ1LTkQCdEiTApnflFZPL+rfZoJYNqulv
n6kAoLMFai6A+aTwpH0+X+hSe9cp0xuh
=+PHs
-----END PGP SIGNATURE-----

--nextPart1755462.hRsu2P9x4A--
