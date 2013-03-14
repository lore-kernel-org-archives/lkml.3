Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab3CNPLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:11:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab3CNPLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:11:45 -0400
Date: Thu, 14 Mar 2013 16:11:22 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/3] pwm: davinci: Add Kconfig support for ECAP & EHRPWM
 devices
Message-ID: <20130314151121.GA12656@avionic-0098.mockup.avionic-design.de>
References: <1363257158-11615-1-git-send-email-avinashphilip@ti.com>
 <1363257158-11615-2-git-send-email-avinashphilip@ti.com>
 <5141B6D8.2050308@ti.com>
 <518397C60809E147AF5323E0420B992E3EA96FA6@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3EA96FA6@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:IsMurA/WB+90xqYSL6cvrT1qyXIcBFeCPClsJWsRnNY
 7HNeuN+yjSTcVs7Soc6UfGkIrMCtKENvh4KV3FMOBX+uFS1s7k
 mbw8gOrt1sQKodlKmRGhQaDkWfSOGbsgema+HxAkmn/g2k7XZq
 3/+MJSP5BXy/NBNWFyOb5YfBrbYBOkAm54qBTqTw2D/0A/aD4v
 OSuWrOQwEBqu+MPEA5w5kBOGBoWXq3gA5w6VtrbhXJj/f2nnzd
 nBKry3eNKf96OMvOfPq1RfTv0OOaGgQ624jEAnP/jyMb67MpeV
 xtj1qmlMg2yKbqSPqWksEKdCRx2n3zK8t6Pq1otiagK8LGXDwd
 QWMwH2C8FIy1sOH+2I9J7LtDWZ8Is4vjN9UhXwTVBGyDJhjSMm
 aq4zxXKU/EjjZbZsqO1IYpA0CPa+M1eLY4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2013 at 12:54:08PM +0000, Philip, Avinash wrote:
> On Thu, Mar 14, 2013 at 17:09:04, Nori, Sekhar wrote:
> > On 3/14/2013 4:02 PM, Philip Avinash wrote:
> > > Add EHRPWM and ECAP support build support for DAVINCI_DA850 platforms.
> > >=20
> > > Also, since DAVINCI platforms doesn't support TI-PWM-Subsystem module,
> > > remove the select option for CONFIG_PWM_TIPWMSS.
> > >=20
> > > Also, update CONFIG_PWM_TIPWMSS compiler directive appropriately in
> > > pwm-tipwmss.h to fix the below compiler error upon removal of
> > > CONFIG_PWM_TIPWMSS for Davinci platforms.
> > >=20
> > > 	drivers/pwm/pwm-tiecap.c: In function 'ecap_pwm_probe':
> > > 	drivers/pwm/pwm-tiecap.c:263:4: error: 'PWMSS_ECAPCLK_EN' undeclared
> > > 	(first use in this function)
> > > 	drivers/pwm/pwm-tiecap.c:263:4: note: each undeclared identifier
> > > 	is reported only once for each function it appears in
> > > 	drivers/pwm/pwm-tiecap.c:264:17: error: 'PWMSS_ECAPCLK_EN_ACK'
> > > 	undeclared (first use in this function)
> > > 	drivers/pwm/pwm-tiecap.c: In function 'ecap_pwm_remove':
> > > 	drivers/pwm/pwm-tiecap.c:291:49: error: 'PWMSS_ECAPCLK_STOP_REQ'
> > > 	undeclared (first use in this function)
> > > 	make[2]: *** [drivers/pwm/pwm-tiecap.o] Error 1
> > > 	make[1]: *** [drivers/pwm] Error 2
> > > 	make: *** [drivers] Error 2
> > >=20
> > > Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> >=20
> > >  config  PWM_TIECAP
> > >  	tristate "ECAP PWM support"
> > > -	depends on SOC_AM33XX
> > > -	select PWM_TIPWMSS
> > > +	depends on SOC_AM33XX || ARCH_DAVINCI_DA850
> >=20
> > Having such narrow dependencies is wrong. The same device is present on
> > DaVinci DA830 too. A depends on should not be required at all since the
> > driver should build on all architectures. But I have seen resistance to
> > doing that since users don't like to see configuration options totally
> > irrelevant for the architecture they are building for. So may be take a
> > middle path and do 'depends on ARCH_ARM'?
>=20
> I will add dependency only on ARCH_ARM and submit another version.

Perhaps SOC_AM33XX || ARCH_DAVINCI_DA8XX would be an alternative?

Thierry

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRQeiZAAoJEN0jrNd/PrOh48kP/2WASeSBvAjd30RYacBrWrKL
sqjs6fM3X7m+GpoITTmLsEaqNBTAz5JsZQKtpy7KPSw9rMbBZOiuTK+YrKyDUgO+
4T0hT7b+FSyZ/4gwY+OvvDLHHkrCrKAEnlPeQKzoxuRIIILvnWRDGuACRxVc5fSZ
0HzOK6YTXABr7RRI2Vje5UpoetprfPPHQkZ72q5xwuwh4psvxa9f3/7SHG5A+//V
XcMEmq47NK9cQ/YOm+R78Joxo6KCxrP/esojXRoSO00OJp+XAdTgEUk8gk1L7PYW
hZa2Eopc2Z96v9WpZFYuf67IA6Z8PbkO6d6JuOE+IkiZBApDi/RGlITJIUrXZqZv
2Rft4+CBiR3ZM6ygfUHKsjAV8Auwfb+JMuzd7v1cXi2DccI10j22c/cfpSBNOiEz
iPYaOxX+WtOaDm4dShW95jeb1663lpwJodTMR12XQUU1E5YXQ+7RH68Rf6jw+EYM
WWp/BByewkzniJ8XXxngh56lkqaYMmat7sEIFHSvfg18QbVbwY4hfQGSK2UDThhg
hZGy8abJhU0HGM4QmDTD6jI118Z417S0UQTmUkLZIUI946YLZ395ReGfidlsG5fn
ru6Lj4nlZLgWuW5dXYuYUZ5a0dEpG9r8OMYhoogGwFEWhP1oIpBD4Co0LRVTln51
hHecWBR5vTbS/JJJSgNB
=50KT
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
