Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbaLWStt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 13:49:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47844 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaLWSts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 13:49:48 -0500
Date: Tue, 23 Dec 2014 12:48:58 -0600
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>,
        David Cohen <david.a.cohen@linux.intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <m.szyprowski@samsung.com>, <k.opasiak@samsung.com>,
        <stern@rowland.harvard.edu>
Subject: Re: [PATCH v5] usb: gadget: f_fs: add "no_disconnect" mode
Message-ID: <20141223184858.GM9147@saruman>
Reply-To: <balbi@ti.com>
References: <1418892910-23890-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WuedheRyq6FDfQ9j"
Content-Disposition: inline
In-Reply-To: <1418892910-23890-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WuedheRyq6FDfQ9j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2014 at 09:55:10AM +0100, Robert Baldyga wrote:
> Since we can compose gadgets from many functions, there is the problem
> related to gadget breakage while FunctionFS daemon being closed. FFS
> function is userspace code so there is no way to know when it will close
> files (it doesn't matter what is the reason of this situation, it can
> be daemon logic, program breakage, process kill or any other). So when
> we have another function in gadget which, for example, sends some amount
> of data, does some software update or implements some real-time functiona=
lity,
> we may want to keep the gadget connected despite FFS function is no longer
> functional.
>=20
> We can't just remove one of functions from gadget since it has been
> enumerated, so the only way to keep entire gadget working is to make
> broken FFS function deactivated but still visible to host. For this
> purpose this patch introduces "no_disconnect" mode. It can be enabled
> by setting mount option "no_disconnect=3D1", and results with defering
> function disconnect to the moment of reopen ep0 file or filesystem
> unmount. After closing all endpoint files, FunctionFS is set to state
> FFS_DEACTIVATED.
>=20
> When ffs->state =3D=3D FFS_DEACTIVATED:
> - function is still bound and visible to host,
> - setup requests are automatically stalled,
> - transfers on other endpoints are refused,
> - epfiles, except ep0, are deleted from the filesystem,
> - opening ep0 causes the function to be closed, and then FunctionFS
>   is ready for descriptors and string write,
> - altsetting change causes the function to be closed - we want to keep
>   function alive until another functions are potentialy used, altsetting
>   change means that another configuration is being selected or USB cable
>   was unplugged, which indicates that we don't need to stay longer in
>   FFS_DEACTIVATED state
> - unmounting of the FunctionFS instance causes the function to be closed.
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

David, can you test it with your setup ?

cheers

--=20
balbi

--WuedheRyq6FDfQ9j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmbkaAAoJEIaOsuA1yqREMhwP/3098zk9U+rnPf46luxpIGX1
o0jrmvClU7oYQf7jthk6flC7Uw33i5CiLUifJrxwzF7GxEy6CLxm8hQa8Uy5iCoY
nYr+kbySBW5PmhJrKUu0Ywd8eMZor7kflkRjp4irWlom/FzeztvN1hH3Vy4PXQyf
83/oZr9ETuFQxj7dfaB6aFe4bo2flvb3Lz0/dpxEZ2r4kdv+OOVL3FxphlkNHP6c
Y9hO+ucImQT7RWXY4wF2u+ngddcn+uTMhBHEAub2wetGQN3Myqyf3P1AcojHLZPV
iwFrMSHC42VOZhSMUPj9abAwOZOURBw1oHf2YBYhHo5lcCiqvg4fpN7O9gBvrZdz
3Siw2UmAHRsPRpisv583jqHIYvTlQJCAdSb962iUc3c0wCYWPxkIfUyfKSpW/sow
fpwvsGVS0lotrqId3/MGC5PPL8r6sdsL02sJjfYViGkO8Lez5ZGRzZD/Fu6YxhEW
TKDpmt0gSAdZMPnVxnjC2+h/4259pe5blDDczUPIj9GQGaQWBpL6zCkvnUOQG8RE
spLCLcRx84HTcdre+ug5QE5U1fPUpB2+EpqmJ25n20uOLdQUIBhQS8nXbfj5Rn1D
BhQAYJpBz9A+RsxiwZtD+roB86sf5a7ug6o0djtKiC/2q1d+FSze8bSC+7M90YbC
JWn0c6vhrF1aXH85nAYC
=D75q
-----END PGP SIGNATURE-----

--WuedheRyq6FDfQ9j--
