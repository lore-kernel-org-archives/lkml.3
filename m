Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbaCDT5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:57:25 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46966 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbaCDT5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:57:24 -0500
Date: Tue, 4 Mar 2014 13:55:41 -0600
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: Robert Baldyga <r.baldyga@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH v2] usb: gadget: return the right length in
 ffs_epfile_io()
Message-ID: <20140304195541.GB24463@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393918497-30916-1-git-send-email-chuansheng.liu@intel.com>
 <531606DB.4010601@cogentembedded.com>
 <20140304160620.GH15233@saruman.home>
 <xa1td2i14u63.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Content-Disposition: inline
In-Reply-To: <xa1td2i14u63.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 04, 2014 at 08:53:40PM +0100, Michal Nazarewicz wrote:
> >> On 03/04/2014 10:34 AM, Chuansheng Liu wrote:
> >> >@@ -845,12 +845,14 @@ static ssize_t ffs_epfile_io(struct file *file,=
 struct ffs_io_data *io_data)
> >> >  			 * we may end up with more data then user space has
> >> >  			 * space for.
> >> >  			 */
> >> >-			ret =3D ep->status;
> >> >-			if (io_data->read && ret > 0 &&
> >> >-			    unlikely(copy_to_user(io_data->buf, data,
> >> >-						  min_t(size_t, ret,
> >> >-						  io_data->len))))
> >> >-				ret =3D -EFAULT;
> >> >+				ret =3D ep->status;
>=20
> On Tue, Mar 04 2014, Felipe Balbi wrote:
> >>    Why the indentation jumped suddenly to the right?
>=20
> > On Tue, Mar 04, 2014 at 08:01:15PM +0300, Sergei Shtylyov wrote:
> > because it was wrong before ;-)
>=20
> Yep.  It looks like Robert's [2e4c7553: add aio support] introduced an
> if-else-if-else flow but did not indent the code and I didn't caught it
> when reviewing that patch.

it's in my testing/next now, I also fixed the comment indentation which
was also wrong.

--=20
balbi

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTFi+9AAoJEIaOsuA1yqREOMwP/0YkXH6+LdVwHU3LnAwCtG8U
vAXVdqWGioJ1EEUAXgiSTeMLJ/67RF2Lr8AQQpFqvB+ePR5YgYYWaGDUoE9zFe1K
TKAD8Xf9ziH48O3xIi0Ip3pHWl6DIJ4DmAPc+YHVi9nWUxyAZUNOsEXIp6xAOgN3
8sENnXjJiGEhq/Jg8y80EYffk99J84FsCJ3hqmdoFgS5gTaiW2jprJnX7ufFez+U
qKPG97DkSUgdmjKqT28Y0GpoTpf2PvOUtdH2abB7zeMoPPyZekmy0JMDFbTeSMWF
Z42FPPN9hyXXbmsYcYxDX5KOs2SrNX4zvISDEdcbcCvxng64RcDBEJ/XmPxC4/Lc
ox9FAj8unDrBDBvVtfgr/TXR4tQ8OMGC84UcH63imgcfmJNJdTi5I9viZ0hIVzeO
Np8wVvQ8bbyjWap++8XwyKj0DF1xts00KNPN9CnCUjWznBTu3Hilr5LYbwamQG0C
oBWFzybVq5ApONnh+mgHj3vYBpXIyWOZnXjNrHwKE3hopO2A6vyFGxJf56GpJC+Z
SW922JBw/BecsXu8IKHYLZt5faxOZckdfpF4YBYsKU1l+UcSmCt1sMwLea5J60IH
hxWhbRkUDJzB4NiycPsisbvk4+1G9hA+YuO7YjXWox/+9RUrg9FdfsBxOd94uiUW
l6awklRPBu+gXpgnDuLA
=K3Sx
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
