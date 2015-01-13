Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbbAMLrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:47:23 -0500
Received: from sauhun.de ([89.238.76.85]:35174 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbbAMLrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:47:21 -0500
Date: Tue, 13 Jan 2015 12:47:14 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: max.schwarz@online.de, heiko@sntech.de, u.kleine-koenig@pengutronix.de,
        addy.ke@rock-chips.com, hl@rock-chips.com, cyw@rock-chips.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3] i2c: rk3x: Account for repeated start time requirement
Message-ID: <20150113114714.GD7660@katana>
References: <1418924647-23795-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
Content-Disposition: inline
In-Reply-To: <1418924647-23795-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2014 at 09:44:07AM -0800, Doug Anderson wrote:
> On Rockchip I2C the controller drops SDA low slightly too soon to meet
> the "repeated start" requirements.
>=20
> From my own experimentation over a number of rates:
>  - controller appears to drop SDA at .875x (7/8) programmed clk high.
>  - controller appears to keep SCL high for 2x programmed clk high.
>=20
> The first rule isn't enough to meet tSU;STA requirements in
> Standard-mode on the system I tested on.  The second rule is probably
> enough to meet tHD;STA requirements in nearly all cases (especially
> after accounting for the first), but it doesn't hurt to account for it
> anyway just in case.
>=20
> Even though the repeated start requirement only need to be accounted
> for during a small part of the transfer, we'll adjust the timings for
> the whole transfer to meet it.  I believe that adjusting the timings
> in just the right place to switch things up for repeated start would
> require several extra interrupts and that doesn't seem terribly worth
> it.
>=20
> With this change and worst case rise/fall times, I see 100kHz i2c
> going to ~85kHz.  With slightly optimized rise/fall (800ns / 50ns) I
> see i2c going to ~89kHz.  Fast-mode isn't affected much because
> tSU;STA is shorter relative to tHD;STA there.
>=20
> As part of this change we needed to account for the SDA falling time.
> The specification indicates that this should be the same, but we'll
> follow Designware's lead and add a binding.  Note that we deviate from
> Designware and assign the default SDA falling time to be the same as
> the SCL falling time, which is incredibly likely.
>=20
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Applied to for-next, thanks!


--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtQXCAAoJEBQN5MwUoCm2COIP/jdShB2rJRTE2y+DAhnMHS0f
jw05ItQPJYASagsGyw3RGVmIAV/jOYLjz2oIGAfnNEHGmC6Ui0rkiJOiPeUJ0/TK
MWD8bIe7gd9UNTfO2M+X+n8pMSY/ZAECh33tbtOgFxC94IoaYstDyGH1/YEQbBOv
r2hUpTfzmxmgaUr21yxiAWvjhkqcbL1pysr2HeHi+45grClHWOtcBOw7JEh59qgZ
19Wd5GPtabAbOmB8rINHkHn3YgOdn8kXWPmZohOBPjvTs4HyLCzmqkPkUneldNbS
56dYSV8tXVK7iDYx30i5T5qqdUxauFxFq4FuwrikOD7lrTU6DujSsRGpYCjLpKkL
f3lrlMQ6Ox7C0BBJXYyytYH96eqlIr3kMm2JpjBv9f6qJNDyir3XyltlMMz8He4p
+rOljfaBK0gh+TkdvuaLM+ZSZ2goQkun2j+ZwUlGsIFG9xUjvz9TsAppv/zRtlfG
JhQ4yfJkTUwkxnv0bI/ZFo/KkMg5M+F9nZ4zvnbx4WCbqM6AwooUWEU0Uxc1bYIn
s53I896WlWDlwQTSDjzvOtqGUdaEi2P4eHe/MrGhGyky0SR5FT1sRH/uMi/P6Bgj
og/UUiD181jRuyFmPBfdyt/0/pty1JD4aVMw6UM5fVX9XE6qcLR8o2Dd6YOvhAnh
y1TIK3YGYexZCzP/koGD
=L2fi
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--
