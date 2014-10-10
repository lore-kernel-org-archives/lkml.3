Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaJJSLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:11:47 -0400
Received: from sauhun.de ([89.238.76.85]:49413 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaJJSLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:11:46 -0400
Date: Fri, 10 Oct 2014 20:12:21 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, kernel-janitors@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: Re: [RFC] drop owner assignment from platform_drivers
Message-ID: <20141010181218.GB6075@katana>
References: <20141010072439.GA1741@katana>
 <2106140.DbuFLh1xav@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <2106140.DbuFLh1xav@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

thanks for taking a look!

On Fri, Oct 10, 2014 at 10:30:08AM +0200, Arnd Bergmann wrote:
> On Friday 10 October 2014 09:24:39 Wolfram Sang wrote:
> > people found out that for platform_driver, we don't need to set the
> > .owner field because this is done by the platform driver core. So far,
> > so good. However, now I got patches removing the .owner field for this
> > single i2c driver or for that one. To prevent getting thousands of
> > patches fixing single drivers, I used coccinelle to remove all instances
> > from the kernel. The SmPL looks like this, it doesn't blindly remove all
> > THIS_MODULE, but checks if the platform_driver struct was really used by
> > a call actually setting the .owner field:
>=20
> Is the intention just to save a few lines in the kernel source, or are
> there any additional upsides to doing this?

As written above, I don't like getting patches removing this line for
single drivers. I already got two and I am expecting more. So I'd prefer
to do this on subsystem level. I will apply the I2C part, for sure.

> While it looks like an obvious cleanup, it also seems to me that there
> is zero effect in terms of functionality, code size or enabling future
> changes.

Well, the kernel image will compress better ;) And well, it is cleaner.
Why should we set up something if it gets overwritten anyhow?

> I'm all for adding your semantic patch to scripts/coccinelle so it gets
> picked up by anyone writing new drivers or doing code cleanup on their
> driver, but I'm unsure about the value of applying all your patches
> for the existing drivers.

I could try reducing the number of patches. Any other downsides?

Thanks,

   Wolfram

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOCGCAAoJEBQN5MwUoCm247oP/0xYtJ0IjAo9/B8FCDgynKiy
2JXKw3gpa56m63/Sq18Ij59t5Q4n9MoxKpAAAprv3uB2gIUc+SGkSMSsjAkSH1iP
xe9mG2bIwc+mEc4PgAluJo3hAEZyQT3oFm1Y2CXjeev4gaHJmiOLxcC0zCTDzkgw
8Xf9bnSwt//rqidDIrscfwm/JRCrNlSu6he2wfJCGdtGcGdYaWoljA8+VtR5+wNw
rRgh+Aey1LPS1AYFD+rWtv2P8B082r8Q55JZQHr1WEcpyJsi2xKdZTStPkYQIAiq
bXNHrTAlySQVXJNI1aX2fJ0TYFF5la1XBHQQEIUpYcA2lH1jKVuUcePALXDspIHC
Dje3gPjs4uti0wCd/cLTvQ65bFVn4YE0SA3V3Eir5hGVyK7O1WYky7pYp+MKVTRG
SkslFyAIUZRYwk2Hzb08KsGoiJWMgqdcJNT1MaK/sJINi+rvtZiDpc8SFJaPWPnB
Zt5C/frYybST2T2w4NGdzDxVVJky2yPYmTcB5nyJiJO88ERFsBr0Zgyb0xyGBFjH
oRBXqjuhtOdLq58M7QI7kJZScSOGuOF2SvJ35xGMGgvkhPgmL9Avab49IwpVLOek
3AEGsB8J+pCeooPM9wjYikxwEDWjxwoSlcjGLC6tTWMT5385AYCRcltVxCDQ3TeO
MGrOy3Miz+KcT+FtwlOH
=uT18
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
