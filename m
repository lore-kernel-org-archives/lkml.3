Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaBZGrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 01:47:25 -0500
Received: from ozlabs.org ([203.10.76.45]:54385 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaBZGrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 01:47:23 -0500
Date: Wed, 26 Feb 2014 17:47:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: linux-next: build failure after merge of the char-misc tree
Message-Id: <20140226174721.3f27c7ca917e9c73b0fb8ce5@canb.auug.org.au>
In-Reply-To: <20140221164711.9e62ae1f03fe1166943a2a14@canb.auug.org.au>
References: <20140221164711.9e62ae1f03fe1166943a2a14@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Feb_2014_17_47_21_+1100_KeFHX/DOSD8WzAFI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Feb_2014_17_47_21_+1100_KeFHX/DOSD8WzAFI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Fri, 21 Feb 2014 16:47:11 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the char-misc tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> In file included from drivers/misc/mei/hw-txe.c:25:0:
> drivers/misc/mei/hw-txe.h:63:1: error: unknown type name 'irqreturn_t'
>  irqreturn_t mei_txe_irq_quick_handler(int irq, void *dev_id);
>  ^
>=20
> Caused by commit 266f6178d1f1 ("mei: txe: add hw-txe.h header file") but
> probably exposed by commit 46cb7b1bd86f ("PCI: Remove unused SR-IOV VF
> Migration support") from the pci tree which removed the include of
> irqreturn.h from pci.h ...
>=20
> See Rule 1 from Documentation/SubmitChecklist ...
>=20
> I added the following merge fix patch (this should be applied to the
> char-misc tree):

Ping?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__26_Feb_2014_17_47_21_+1100_KeFHX/DOSD8WzAFI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDY35AAoJEMDTa8Ir7ZwVpSMP/j1K0w4FUdRvqHyGR7MPMWJE
hYvjTh+3NWUUMhsXK3cs2nbEkws8CFs4nmsJnbcivm9oSsjOZml2M/ePjOBIWUEq
iL5mJ6A6i6N7d3JMcqzOMRMt8ijrgtTJcsdlZx0qpKLTV3J0hcJAALb6cz7u7tfe
1/Z2EBsFPP7FLaVCi/eJ8F455nJtjUfbr39Mqlp4/WXZuLyWjX20HIC10w/llabQ
x1s+megIx1jA0ez9vaaVL2BtRSNaVSjj9vYvxUskfMLdV2mfPpAyt8W1T/JlL8Uv
gKzZkdN5OonLDYq+DOQ4bPSDJhS+zP1LMLvXFLg+Z+EBUX9sJPpXcGxZzcO3SK2Q
rSo5jHsWvoTBNpQN0SlJM7P/0EGySZWi9c6yhdDMMTepkNCz6rByvjDCr/oJzNsn
Jh+pwdIGV9SFuryHD1syInuYFZ/N4n6/rYKNRcXJU88QXQ3cygrbfybtomgDGCfL
0IBpOYbBmh2P+Yt9Jv3zNO0ryk99Lu02l/nKBxZXrc0GC8ptmEpgu/Iqkiy9T6le
QzL8ZqSjDPOj/S2Lq7bFzZJuy7nfYdItle3SHqabEo2dzomZ9dXRRUSMQJYvI/Hp
+S3m+SIbkagWe3TWUSKg9nGfkUzhxpZB6bIkJKM5KIJOHsHF1w4Bae97cdjl2EL3
idZHWgwJjSSAEfbAwaLP
=ydsf
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Feb_2014_17_47_21_+1100_KeFHX/DOSD8WzAFI--
