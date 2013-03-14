Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab3CNOXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:23:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33589 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab3CNOXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:23:15 -0400
Message-ID: <1363270983.3937.134.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 031/100] iwlwifi: always copy first 16 bytes of commands
From: Ben Hutchings <ben@decadent.org.uk>
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 14 Mar 2013 14:23:03 +0000
In-Reply-To: <1DC40B07CD6EC041A66726C271A73AE61966F227@IRSMSX102.ger.corp.intel.com>
References: <20130312223122.884099393@linuxfoundation.org>
	 <20130312223126.381565711@linuxfoundation.org>
	 <1363225816.3937.119.camel@deadeye.wl.decadent.org.uk>
	 <1363226724.3937.123.camel@deadeye.wl.decadent.org.uk>
	 <1DC40B07CD6EC041A66726C271A73AE61966F227@IRSMSX102.ger.corp.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2u0L73X3Nu6b4e0ZElYM"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2u0L73X3Nu6b4e0ZElYM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-03-14 at 06:31 +0000, Berg, Johannes wrote:
> > > >  	/* and copy the data that needs to be copied */
> > > >  	cmd_pos =3D offsetof(struct iwl_device_cmd, payload);
> > > > +	copy_size =3D sizeof(out_cmd->hdr);
> > > >  	for (i =3D 0; i < IWL_MAX_CMD_TFDS; i++) {
> > > > -		if (!cmd->len[i])
> > > > +		int copy =3D 0;
> > > > +
> > > > +		if (!cmd->len)
> > > >  			continue;
> > >
> > > cmd->len is an array, so the new condition is always false.  Shouldn'=
t
> > > it be 'if (!cmdlen[i])'?
> >=20
> > To answer myself: no, it should still be 'if (!cmd->len[i])' as this lo=
op needs to
> > include input fragments that will be completely copied into the header
> > fragment.
>=20
> Ick, good catch. It luckily doesn't matter as if cmd->len[i] is 0 (in
> which case we'd continue) the "if (copy)" below saves us in all the
> different code paths inside the loop. This is still clearly a mistake
> in the patch though.
>=20
> I will fix this upstream, I guess you'll want to wait for that for
> stable? I'll Cc:stable that patch as well.

I agree with your analysis that this is actually harmless, so no
objections to including the patch in stable as it is.

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-2u0L73X3Nu6b4e0ZElYM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUHdR+e/yOyVhhEJAQqVZxAAjjx+ELupJDx5OizGTBWBGxzYfxq8Iz/W
4FxZ3I1wWY7DJWHpwMaNOTM6CFSM36Fei7RucI+H7Xs3OHco+yhPUDJjcGoDEhXz
k9nwm7NG0qoKpZmXA5lNswtLun2w6PRImd+nUE/KZeigFVDRymPfxltV8LaGE76y
NnxldbcfmOfHem8qe9EGqwloZcnBfbQW0VZ0+d0P/L9B7S3lJGTpGdXOJAWxQVDx
XjJdftU46qp7Z5dx5JoffKIeSwRYF+4/YwGNmMJlwcmmiVq2xGLKZ2ldeo80aLdP
VdUUU4ULLJXc5iSCO0LLSO/CpefQXcRlg7ccYrmPgNydAq5MXpvuy17jj1eiUfis
9kxbfhRBtdk55coiUNI9JIxHTHOFqmaZrjPp1q5/Z7gUs9fullqN4yphfrCIGqw1
k4QxsQw8A6zEQWI7/l17jkPMnHYgrOVC3tEIuNG1dMoImgqywzPJFtcp0usaeufk
RM1AcMgGTV4LGbykOEjJ5ZVsuABPcbVI1NyXkuPvyWcOxtgZSzgsnX8Ev+ZTyEih
eWoHtQgHLhREWHzHwfhS0u/UxTXrrG/YKFifFXKHIsdDBBNaCYiEntgi4g6iihwM
mQ66MOsRVojRo2NZOM2EWlVQEHlQ+Pdvw97bRqKIzKuWP8HzGs0B/d8fWRgGu3N2
mC86Yo5Qdjk=
=dz8X
-----END PGP SIGNATURE-----

--=-2u0L73X3Nu6b4e0ZElYM--
