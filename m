Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbaJaNwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:52:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49776 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863AbaJaNwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:52:45 -0400
Date: Fri, 31 Oct 2014 08:49:51 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kever Yang <kever.yang@rock-chips.com>
CC: <dinguyen@opensource.altera.com>, <paulz@synopsys.com>, <balbi@ti.com>,
        <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 6/8] usb: dwc2: gadget: Do not fail probe if there
 isn't a clock node
Message-ID: <20141031134951.GG1273@saruman>
Reply-To: <balbi@ti.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
 <1414538749-14735-7-git-send-email-dinguyen@opensource.altera.com>
 <5452F624.709@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uc35eWnScqDcQrv5"
Content-Disposition: inline
In-Reply-To: <5452F624.709@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uc35eWnScqDcQrv5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2014 at 10:38:28AM +0800, Kever Yang wrote:
> Hi Dinh,
>=20
> On 10/29/2014 07:25 AM, dinguyen@opensource.altera.com wrote:
> >From: Dinh Nguyen <dinguyen@opensource.altera.com>
> >
> >Since the dwc2 hcd driver is currently not looking for a clock node duri=
ng
> >init, we should not completely fail if there isn't a clock provided.
> >For dual-role mode, we will only fail init for a non-clock node error. We
> >then update the HCD to only call gadget funtions if there is a proper cl=
ock
> >node.
> We have to add clock management for hcd, and I think it is better to
> do it before more Socs use this driver, isn't it?
> I have do something in my RFC patches, but I think I still do it in a wro=
ng
> way.
> Can we just handle all the clock thing in platform?
>=20
> Balbi suggested in my patch that we can "hide" clk_enable()/disable() und=
er
> ->runtime_resume()/->runtime_suspend() and linux driver model.
> Can this be in platform driver?

it can and it probably should. Implement
->runtime_resume()/->runtime_suspend()/runtime_idle() in platform.c and
call pm_runtime_enable()/get()/put()/mark_last_busy()/autosuspend()
properly.

--=20
balbi

--uc35eWnScqDcQrv5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUU5N/AAoJEIaOsuA1yqRE5qIP/jjxA0JhXDBpCoqXB++S6beN
Us38Lr32KG35FGpW6Yl3npXa9r4YPGwQr5YRFssP1b8gWccrswVPPtbDsAjnxT5A
q1bYDZDVK8NTmnNnjdWFW5xA0jeOtj1h+ktg/SMKzraxMarEG57noit3aX/+AWm9
a5FmWgosAI+pH3vyyGEIzP5z53ph1wdE3Hv2jF8cZI1n4Wv4RurxcHzumqrzR3ZV
DsMzVzUJkpEy7Fj2AZWUvRtICCg+/mLN0kgkHsjiFqrAGXWhauCTw4G/xWj03mVh
4pg1Cd1p04u36jXpuRpN9gFC2Em13QUbZF/i6V/Z7RPxE0gUILU6w3Zxw7axWbgT
T6zv/JWlVUYq0mxxLbwG9fzS70pqkkaEkIDLGqsVDiIrhvlB+uBO2s5gjb1zvKfe
Xpclc6LHBlKp5rj2OvDdbVh7q09IRubYzGUeaZn1Etaw1/E14WJ/JlGtGp49VKv2
HoOJdW5iO73h7PWw2cHrVj9EiW+n9wMUbJn+mmsOpXGs8KNUZ6UL+wk99O77K8Zn
Tn58X0av32UdAaCMotbpF/K90kdH1LDIErLrJH/+jsW34BbPmxEmlUynQckIxu67
wHRZPdmJgHgUlEEoyQm6AO1gpwHVj0GEnGS3sE3ibPHwCiSkUoSdrHUUOSwU7Eb0
qFR1culmoii8cR5MMpVC
=sA4m
-----END PGP SIGNATURE-----

--uc35eWnScqDcQrv5--
