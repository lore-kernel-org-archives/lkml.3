Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaLCLPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:15:39 -0500
Received: from sauhun.de ([89.238.76.85]:50382 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaLCLPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:15:38 -0500
Date: Wed, 3 Dec 2014 12:15:18 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org, robh+dt@kernel.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, cf@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        hl@rock-chips.com, caesar.wang@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v2] i2c: rk3x: fix bug that cause measured high_ns
 doesn't meet I2C spec
Message-ID: <20141203111518.GB1039@katana>
References: <1415261514-4051-1-git-send-email-addy.ke@rock-chips.com>
 <1417574237-4328-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
In-Reply-To: <1417574237-4328-1-git-send-email-addy.ke@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> + - rise-ns : Number of nanoseconds the signal takes to rise (t(r) in i2c spec).
> +	     If not specified this is assumed to be the max the spec allows
> +	     (1000 ns for standard mode, 300 ns for fast mode) which might
> +	     cause slightly slower communication.
> + - fall-ns : Number of nanoseconds the signal takes to fall (t(f) in the i2c0
> +	     spec).  If not specified this is assumed to be the max the spec
> +	     allows (300 ns) which might cause slightly slower communication.

We already have those bindings from the designware driver:

 - i2c-sda-hold-time-ns : should contain the SDA hold time in nanoseconds.
 - i2c-scl-falling-time : should contain the SCL falling time in nanoseconds.
 - i2c-sda-falling-time : should contain the SDA falling time in nanoseconds.

Can you reuse them? Or do you really need a specific rise-time property?
If so, please matche the style of the bindings above.


--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfvDGAAoJEBQN5MwUoCm2yL0P/2Cq0bFmZ5iMyVr57iImqYC1
8DAPzsnY66k7lj5EsdDpuM2wskRR6BoKjrmQb7VaeMtsLA7yaa3QmjDg5fBtsQ5C
D+O+EXEKYQgN2DVqLDW/5oebJKHQYOEpCSQrxa4ixwFjf950bcN9DbYwl8TJvy51
6uJKuJ3C8OGMnH5o0mqY7Tmi60yBLqYYVVwLay19zxWoeRdmtSpcVle0AuB7FtHp
UiOAWVBPRMnT573VfckQrZ0t8EcWAz5nZtpmceJyU9dB4B5I1XY0PCpKx/Djc0aJ
zQ0maXf+R8zyAcooyVKIab4mHnsG3+I9Toe7kJN/Fu5p5sxAfCrHnTgZyC7h4T/2
Wk3+2vSkxux0EYDDUUZIQQeaHdUjhnpxyI+ppcxDQEk1xoa/I5GulMFrVR8zXuNv
aMJmJqQsmmarwSgvcakbYOdyeZXLZtQlvDfGDdqC0Y4ipWvvl6vRLQvsYnixsDsV
LswxF/hQfWu/HepIIGWh6IOPDc4TlZPsYdBCyl/o3Pi9NZkrcD36BZSz4WDjyNo7
qXLvCi+6WqA2Svhrl6/fk8aKgMeBcBUv//X3cwNtrhQPH/nYurLeJuMpe5cervNI
QkPiEyOZZg8S0ZwhC+vQkCaWK7DBWiKKS7WH/2zWF6HHcPTbOlZ4Ys8/D28h9vAF
mjTgaUSxU1E4dVnz+J/R
=6GEG
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
