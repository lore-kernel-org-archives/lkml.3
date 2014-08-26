Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaHZStk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:49:40 -0400
Received: from omr1.cc.vt.edu ([198.82.141.52]:40815 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbaHZSti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:49:38 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
        Sabrina Dubroca <sd@queasysnail.net>,
        Vincent Donnefort <vdonnefort@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH][input-led] Defer input led work to workqueue
In-Reply-To: Your message of "Tue, 26 Aug 2014 03:54:53 +0200."
             <20140826015453.GA5235@type.youpi.perso.aquilenet.fr>
From: Valdis.Kletnieks@vt.edu
References: <20140826015453.GA5235@type.youpi.perso.aquilenet.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1409078958_3277P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 26 Aug 2014 14:49:18 -0400
Message-ID: <3942.1409078958@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1409078958_3277P
Content-Type: text/plain; charset=us-ascii

On Tue, 26 Aug 2014 03:54:53 +0200, Samuel Thibault said:
> This changeset defers the second led_trigger_event call into a
> workqueue, which avoids the nested locking altogether.  This does
> not prevent the user from shooting himself in the foot by creating a
> vt::capsl <-> vt-capsl loop, but the only consequence is the workqueue
> threads eating some CPU until the user breaks the loop, which is not too
> bad.
>
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
>
> --- a/drivers/input/leds.c
> +++ b/drivers/input/leds.c
> @@ -100,13 +100,25 @@ static unsigned long vt_led_registered[B

I admit having zero understanding of the code, but I can confirm that
next-20140825 still throws the lockdep whine I was seeing, but the same
tree with this patch on top of it boots without warning. Soo...

Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--==_Exmh_1409078958_3277P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU/zWrgdmEQWDXROgAQLgbA/9EPe/Gp1GWhNacssYXTeeUxyM0wOLBVYm
6Eeh1VwOOXc4b/P9rEMzGYeF+dPhRCZy2rWUyRy8ZCyG3tV3xtL4t+mvplxWLerD
A7CIw8BBdl4BTGDqEcCLmXV85wonkOcp/SOAhAZFRMH0ZOpZFm1nF28Lk+pdLe64
EDYUrbT/W1BlrmEmclpFe+iOwT+0hoZoamu12MgnF17dli41Jurk0ML4izoAIGHC
a9fu+NmA/OylPe4fc/Q6GKbXpcJ16hSv9RD0e+RPm0VHAChhuqxFSebrcOJI+Cwf
q0BgdMk1KHWfxPMYFWlc+2mcvvNyQdR/UAFz/H1qbbVqkGBfY5D59WcwaIfkktiz
ZebpVRQ60MSf8oSUAkGpJNsaw1Q7nxc1gfPZwJZJOOKlZwiXGQsfuwLj1Bzdlp/g
gud/Awzf1eEOQi6GuPl/fTV7fdLZJCSXL3Nte9HySYTGpBQkB4CqFEh0sHNRMUlm
kmvia7yBJuJx98YsL1KFwHCq43HyKfRVW/9RY5E+e3FIApy7W+FlDDhIk/wXFw/r
yK8+r8O/6l85UvdVaHL56an6Y651EWD3YOkRpXAyY5fJauGIXTs/9dzu5xzN8Nbd
EV6vO0aowTjL8mlTrxXH4FZs2bxitGnU2yi+0aZ3LF6rlPyTDFGEEgrrdByAlJ5q
fyRkNux2CJw=
=A81B
-----END PGP SIGNATURE-----

--==_Exmh_1409078958_3277P--
