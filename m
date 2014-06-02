Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaFBQbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:31:16 -0400
Received: from sauhun.de ([89.238.76.85]:46722 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845AbaFBQbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:31:06 -0400
Date: Mon, 2 Jun 2014 18:31:03 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>, kernel@stlinux.com
Subject: Re: [PATCH] drivers: i2c: i2c-st: Update i2c timings
Message-ID: <20140602163103.GJ2654@katana>
References: <1400254330-2547-1-git-send-email-maxime.coquelin@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKy6e3LXpfmanBFM"
Content-Disposition: inline
In-Reply-To: <1400254330-2547-1-git-send-email-maxime.coquelin@st.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKy6e3LXpfmanBFM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 05:32:10PM +0200, Maxime COQUELIN wrote:
> The i2c timing values specified in the driver are the minimun
> values defined in the I2C specifications.
> The I2C specification does not specify any default or maximum values.
>=20
> Some I2C devices are out of spec, and might not work properly with minimum
> values.

Can you give names here? Would be interesting to know since a few
drivers implement the minimum timings.

> This patch adds a 10% margin on all the timings.

Is there a safety margin or do the devices start to work exactly at 10%?

>=20
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> ---
>  drivers/i2c/busses/i2c-st.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-st.c b/drivers/i2c/busses/i2c-st.c
> index 8720161..09142f1 100644
> --- a/drivers/i2c/busses/i2c-st.c
> +++ b/drivers/i2c/busses/i2c-st.c
> @@ -210,21 +210,21 @@ static inline void st_i2c_clr_bits(void __iomem *re=
g, u32 mask)
>  static struct st_i2c_timings i2c_timings[] =3D {

That needs a comment about the margin, otherwise people will wonder
where these values come from.

>  	[I2C_MODE_STANDARD] =3D {
>  		.rate			=3D 100000,
> -		.rep_start_hold		=3D 4000,
> -		.rep_start_setup	=3D 4700,
> -		.start_hold		=3D 4000,
> -		.data_setup_time	=3D 250,
> -		.stop_setup_time	=3D 4000,
> -		.bus_free_time		=3D 4700,
> +		.rep_start_hold		=3D 4400,
> +		.rep_start_setup	=3D 5170,
> +		.start_hold		=3D 4400,
> +		.data_setup_time	=3D 275,
> +		.stop_setup_time	=3D 4400,
> +		.bus_free_time		=3D 5170,
>  	},
>  	[I2C_MODE_FAST] =3D {
>  		.rate			=3D 400000,
> -		.rep_start_hold		=3D 600,
> -		.rep_start_setup	=3D 600,
> -		.start_hold		=3D 600,
> -		.data_setup_time	=3D 100,
> -		.stop_setup_time	=3D 600,
> -		.bus_free_time		=3D 1300,
> +		.rep_start_hold		=3D 660,
> +		.rep_start_setup	=3D 660,
> +		.start_hold		=3D 660,
> +		.data_setup_time	=3D 110,
> +		.stop_setup_time	=3D 660,
> +		.bus_free_time		=3D 1430,
>  	},
>  };
> =20
> --=20
> 1.9.1
>=20

--tKy6e3LXpfmanBFM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjKbHAAoJEBQN5MwUoCm2ZkoP/0L4BXCqVHrOQXy0DFSnSnun
plm99XMolqJo0plxcQlx/+0Cj4nFwmgJi/F0M6BMTEdsX0qIsljP4ELi+b4Cc//R
4BAU1LzVK7IiDewOwAaw3lnjl+skaLiIacAz1mr81QsqoNz7ptNond6q2I3BcgRq
CLXymFIvf6B2n2+rr6IxJhMEoNhT1Jooxe8WBdZwcVCiX/j9ZswS9ODz1vwhEy+M
RIsIpG7c1SbZYY6PI4vdaGHJeaem3wbWWmgvhQvj1rvS+dWynuzn94yJlI/SVaOa
2hlKQJ6+rpErzDrN8VgfyKak8R6mILQtbDdptaRqftjmaQMvyTspmxCChhd/WxSJ
TPJnPH4icV7iMp7mEVMuJsDo20yiroi29IyYftpJdpjp1ZldN+8ViYMtIxVInJ0t
F2OAV6cXA1TMiy0eIP/f3BUm76lSxZ6oqOEpRYEGmz7AHE1WETTs9Hs1397F9lpr
kqpZ4G3Zxvejx5UnopsWvYxaLBL7RsoR70qQmIGoHkrXZYiDGCyDaHuqk9WE77bz
Fwac5lxZTZkFAfPLugWsKXU8jOvi6Uyq1DDYzq+7Bzv/oLGhKBcIOQFPaL7E0ZVz
XwNYf333RlWj//rqSDw8orWwFV69aBfb3XbNcd4SKiijpGxPaWeweXuGgjKZseEs
EOcHL+A2PUmLuq0vyJ39
=iiZs
-----END PGP SIGNATURE-----

--tKy6e3LXpfmanBFM--
