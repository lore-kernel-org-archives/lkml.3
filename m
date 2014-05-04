Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaEDRs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 13:48:28 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:58693 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaEDRs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 13:48:27 -0400
Date: Sun, 4 May 2014 19:48:23 +0200
From: Levente Kurusa <levex@linux.com>
To: Dominique van den Broeck <domdevlin@free.fr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] staging/rtl8192e: userspace ptr deref + incorrect
 declarations
Message-ID: <20140504174823.GA26361@linux.com>
References: <1399214787-15675-1-git-send-email-domdevlin@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <1399214787-15675-1-git-send-email-domdevlin@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, May 04, 2014 at 04:46:27PM +0200, Dominique van den Broeck wrote:
> . userspace pointer dereference ;
>=20

What is that period in the commit message? And the semicolon?
You should also be a bit more specific. Also, the Subject line is
very bad. Better go with something like this:

staging: rtl8192e: fix userspace pointer dereference

And when you resend a patchset, please resend the full patchset.

> These issues have been fixed by a concurrent patch:
> . missing inclusions of needed header files (fixed by concurrent patch);
> . unrequired static function declaration (confusing another *.c file).

This is totally unneccessary.

>=20
> Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
> ---
> v1 : I submit this patch as a result for Task #16 of the Eudyptula Challe=
nge.
> v2 : Resubmitted because of a conflit with commit 5169af2309f42bb4cb0ebfe=
fe6bf8bc888d4ce33 .
>      Successfully tested against commit b5c8d48bf8f4273a9fe680bd834f99100=
5c8ab59 .
>      I resubmit only the 2/2 one, since the 1/2 as already been accepted.
>=20
>      Levente, still agree with you about numeric values that should be ch=
anged into symbols.
>      This will form another future patch.

When you cite a commit please don't include the full hash, that is
non informational. Better put the first 7 characters of the hash and
the first line of the commit message as well in parantheses, like so:

5169af2 ("Staging: rtl8192e: Fix declaration of symbols")
(I even have a command for this in vim :-) )

Are you sure that 1/2 was applied to the staging tree?
It's unlikely that 1/2 is applied while 2/2 is left alone.

Oh, I am unable to find commit b5c8d48 in Linus' or staging-next.
In which tree is it?

>=20
> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c b/drivers/staging=
/rtl8192e/rtl8192e/rtl_wx.c
> index 498995d..d87cdfa 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> @@ -1131,11 +1131,18 @@ static int r8192_wx_set_PromiscuousMode(struct ne=
t_device *dev,
>  	struct r8192_priv *priv =3D rtllib_priv(dev);
>  	struct rtllib_device *ieee =3D priv->rtllib;
> =20
> -	u32 *info_buf =3D (u32 *)(wrqu->data.pointer);
> +	u32 info_buf[3];

Could you please as well remove that empty line in the declarations?

> =20
> -	u32 oid =3D info_buf[0];
> -	u32 bPromiscuousOn =3D info_buf[1];
> -	u32 bFilterSourceStationFrame =3D info_buf[2];
> +	u32 oid;
> +	u32 bPromiscuousOn;
> +	u32 bFilterSourceStationFrame;
> +
> +	if (copy_from_user(info_buf, wrqu->data.pointer, sizeof(info_buf)))
> +		return -EFAULT;
> +
> +	oid =3D info_buf[0];
> +	bPromiscuousOn =3D info_buf[1];
> +	bFilterSourceStationFrame =3D info_buf[2];
> =20
>  	if (OID_RT_INTEL_PROMISCUOUS_MODE =3D=3D oid) {
>  		ieee->IntelPromiscuousModeInfo.bPromiscuousOn =3D

--
Regards,
Levente Kurusa

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJTZn1nAAoJELBqK2lO9dZBZUwIAIbDD3kjp5GcbX6iZgQ/N1DO
DciqPnHK5N6W4xd8srZUaG8fo0s4FyyV9zIRqhbRzgrVlfo9S3PEGigKsaWcTcvg
wymJfyK9J+4WjEZR/Uhbm4n6zWqrj2cqKQr2wkF69pi1cBh6LRMt3RgCzS8NTgww
p67Jns1UmVYgwxSar1GjynN1bU4j/FCn8/7UKXTi2IMY9r4f2e4/rLlrG4paI8Mq
uLX9/Us2CpOS0aMwxuPBiYWwA/eQ+mXl9dmrQNxMr41AoQMhAzsLMXJpwvc9W3wq
FDbAkjUWspwmBx4uJQ6TcJ/9HWuzVan5ECcYgvgPD7VishdhwQz4+4abjkiil50=
=kGiw
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
