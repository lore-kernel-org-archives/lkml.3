Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbaHYMf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:35:59 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61132 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbaHYMf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:35:58 -0400
Date: Mon, 25 Aug 2014 14:35:50 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Bo Shen <voice.shen@atmel.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] PWM: atmel: fix incorrect CDTY value after enabling or
 disabling
Message-ID: <20140825123548.GE4163@ulmo.nvidia.com>
References: <1394823931-2815-1-git-send-email-alexandre.belloni@free-electrons.com>
 <20140825101522.GA16960@ulmo.nvidia.com>
 <20140825115454.GA2077@piout.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TD8GDToEDw0WLGOL"
Content-Disposition: inline
In-Reply-To: <20140825115454.GA2077@piout.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TD8GDToEDw0WLGOL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 25, 2014 at 01:54:54PM +0200, Alexandre Belloni wrote:
> Hi,
>=20
> On 25/08/2014 at 12:15:23 +0200, Thierry Reding wrote :
> > On Fri, Mar 14, 2014 at 08:05:31PM +0100, Alexandre Belloni wrote:
> > > pwm-leds calls .config() and .disable() in a row. This exhibits that =
it may
> > > happen that the channel gets disabled before CDTY has been updated wi=
th CUPD.
> > > The issue gets quite worse with long periods.
> > > So, ensure by reading ISR that at least one period has past before di=
sabling the
> > > channel.
> > >=20
> > > The other issue is that it may happen that CUPD is not flushed before=
 enabling
> > > the channel so it will update CDTY/CPRD just after one period. So we =
always set
> > > CUPD, even when the channel is not enabled.
> > >=20
> > > Tested on at91sam9g45 and sama5d31ek.
> > >=20
> > > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.co=
m>
> > > ---
> > >  drivers/pwm/pwm-atmel.c | 46 +++++++++++++++++++++++++++++----------=
-------
> > >  1 file changed, 29 insertions(+), 17 deletions(-)
> >=20
> > going through the list of unapplied patches I came across this old
> > patch. It was never reviewed nor acked by anyone and you didn't ping me,
> > so I always assumed it must no longer be required. Is that so?
> >=20
>=20
> It is still required but Nicolas is not happy with the polling on
> PWM_ISR and he was supposed to discuss that internally with the IP
> designer to understand if there is a better way.
>=20
> I'll either ping on that one or send a new version when I'll know a bit
> more.

Okay, thanks.

Thierry

--TD8GDToEDw0WLGOL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBAgAGBQJT+y2kAAoJEN0jrNd/PrOhFNsP93TQj/KOzqpjR0oca2Z8Qltn
0Nas+y/OuaIdziEU0gfIB4a656Hos/6Cm/GnATAPQye/lu8hzOvnosZQlgHKL4tL
Q/3fMD/xO7fwatODRwEglOGtgp8ERcXLC8rEx/H++CTzhPvr6EEY4RceGOMwdUSK
CvEE/4iiZqoML+9QEjJEfDNX2YHDjASZ7W6Rz8udnDwRpY6FahQmwo+K8YJRT9tl
wRrgMRmScIPgUVxHn0WUg+kLXC2l10PRqdq35/+85YGIZUI3x+cMhNFs5DLRaO/C
YeP/0fAVBaCywvc6rdzmQMLXrytFwb9aHc72l7o0G6JTF7+HviDCOJuz5af0c1Z6
mz/7Gbs7mUm10k9Z30VUJRogrpRfhJKSUaSYEdY7sn9L8SI2JNW+ZGaWMQjf2WuD
+xT6gyJlrDXXpnMGQq85dk8bi16rp6ENsgAwMWL3qkJCNZpw3FCTged50Dn8DqsW
ftD/2ys3UDNU0QwlGnGnygBwT86YyVWQ/HnqNaYPMZ4RTR9Px27zQAlYKkpQ61ig
Jh//4UfFX9R5UuFgfIh9DuzfknVyPR+I4k5XuswuNMUrKhKD82mcTZnXKZj9uG84
R8EwScZQKRkxogN6ACL/0rDh2H5Qi8JHEp+tsxTEN1nJSp3Xqnjd+TEs/xSci3gc
MfTySKMgYkTDtp+mjAM=
=B1R7
-----END PGP SIGNATURE-----

--TD8GDToEDw0WLGOL--
