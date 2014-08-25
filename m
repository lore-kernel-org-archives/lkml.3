Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaHYKPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:15:36 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:37393 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaHYKPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:15:33 -0400
Date: Mon, 25 Aug 2014 12:15:23 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Bo Shen <voice.shen@atmel.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] PWM: atmel: fix incorrect CDTY value after enabling or
 disabling
Message-ID: <20140825101522.GA16960@ulmo.nvidia.com>
References: <1394823931-2815-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <1394823931-2815-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2014 at 08:05:31PM +0100, Alexandre Belloni wrote:
> pwm-leds calls .config() and .disable() in a row. This exhibits that it m=
ay
> happen that the channel gets disabled before CDTY has been updated with C=
UPD.
> The issue gets quite worse with long periods.
> So, ensure by reading ISR that at least one period has past before disabl=
ing the
> channel.
>=20
> The other issue is that it may happen that CUPD is not flushed before ena=
bling
> the channel so it will update CDTY/CPRD just after one period. So we alwa=
ys set
> CUPD, even when the channel is not enabled.
>=20
> Tested on at91sam9g45 and sama5d31ek.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/pwm/pwm-atmel.c | 46 +++++++++++++++++++++++++++++--------------=
---
>  1 file changed, 29 insertions(+), 17 deletions(-)

Hi Alexandre,

going through the list of unapplied patches I came across this old
patch. It was never reviewed nor acked by anyone and you didn't ping me,
so I always assumed it must no longer be required. Is that so?

Thierry

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT+wy6AAoJEN0jrNd/PrOhJdMQAIgIVva/nF7M2Ap5hisoU1QO
cZTDElki07eMI1tS1ecgz98a/+zu435982JtqjT5q4+Lj6AgeHfnG/ANwnVGuOZs
22ugvboFbLCn9GBOSOtQSYzKaKLr+a2ScXktlcFL9ehy0KeXj9djI3BgW2FmqZUV
xCT0HRzp7Euc6TwxAWauNXN4XwAEds4mRDqmP8sAzeraWHW0QpUUK9SZBoNuUWDv
OYlgL2jIyk4rTom0nMNjp33npkP2z5b14TmBW3twIl25veQf6r8dpA8dw8a+5qyr
vKmCaS/NEKlIQjvxJXBPduGauxB5cSQcw1ImuWIKF6LKj9tiV0n8J0o0gssw76k0
yBAB47DaFzuOul+2oRrSD/0lL1ls5Jf432QNee6usZbQMjmTwaKoioq/3umtPXvk
13zH4XzqpB1vH/8M/faUJnt23wdwqSK7bOcM+PYfNjxp4Q6dV5+dbaB1PmqKD7N6
raouMcQa6itO4UeJ+CwXGJnS7BBGs+UqQ2lNFJa3n+qtn2PVwnF9w/HJ80OGkR7/
m4WR+5pAda/JbILkKZq79y3BHGy3oWLcIbj9Ny2UWzqSFk4QktZ+7UrFodOOHVM9
FVW7b5KFWm2P2QBdQTU7yU7C8cyYqk5AC0NeiFo1lamJrqwgRLPlij+Ya9a99zln
KKJFTFQYZ9ESVEWjCkZ+
=5s5N
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
