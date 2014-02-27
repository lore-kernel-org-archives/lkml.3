Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaB0FsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:48:17 -0500
Received: from ozlabs.org ([203.10.76.45]:38839 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaB0FsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:48:15 -0500
Date: Thu, 27 Feb 2014 16:48:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: linux-next: build failure after merge of the char-misc tree
Message-Id: <20140227164808.354149fc2237d5f3df04242d@canb.auug.org.au>
In-Reply-To: <20140227033716.GC31199@kroah.com>
References: <20140221164711.9e62ae1f03fe1166943a2a14@canb.auug.org.au>
	<20140226174721.3f27c7ca917e9c73b0fb8ce5@canb.auug.org.au>
	<20140227033716.GC31199@kroah.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Feb_2014_16_48_08_+1100_sSuVKgJ4qkETPR3h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Feb_2014_16_48_08_+1100_sSuVKgJ4qkETPR3h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 26 Feb 2014 19:37:16 -0800 Greg KH <greg@kroah.com> wrote:
>
> On Wed, Feb 26, 2014 at 05:47:21PM +1100, Stephen Rothwell wrote:
> >=20
> > On Fri, 21 Feb 2014 16:47:11 +1100 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
> > >
> > > After merging the char-misc tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > >=20
> > > In file included from drivers/misc/mei/hw-txe.c:25:0:
> > > drivers/misc/mei/hw-txe.h:63:1: error: unknown type name 'irqreturn_t'
> > >  irqreturn_t mei_txe_irq_quick_handler(int irq, void *dev_id);
> > >  ^
> > >=20
> > > Caused by commit 266f6178d1f1 ("mei: txe: add hw-txe.h header file") =
but
> > > probably exposed by commit 46cb7b1bd86f ("PCI: Remove unused SR-IOV VF
> > > Migration support") from the pci tree which removed the include of
> > > irqreturn.h from pci.h ...
> > >=20
> > > See Rule 1 from Documentation/SubmitChecklist ...
> > >=20
> > > I added the following merge fix patch (this should be applied to the
> > > char-misc tree):
> >=20
> > Ping?
>=20
> I've merged everything together, and it all builds properly for me in
> the char-misc branches, so I don't see what is missing.  What did I do
> wrong?

Nothing, your tree is fine, except when merged with the pci tree.  There
is a commit in the pci tree that removed the include of irqreturn.h from
pci.h, thus exposing that drivers/misc/mei/hw-txe.c did not include
irqreturn.h directly despite using stuff from there (similarly for
hw-txe.h).  My patch is just a "quality of implementation" thing in your
tree at the moment, but applying it to your tree will save doing the
semantic merge conflict fixup in linux-next and later in Linus' tree when
your tree and the pci tree meet there.

i.e. it does not hurt your tree to apply it and will save is forgetting
later.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__27_Feb_2014_16_48_08_+1100_sSuVKgJ4qkETPR3h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDtGcAAoJEMDTa8Ir7ZwVn9kP/ier2gqNK4pIQnmxHG3sNI4b
8pKwmV/jCuzKVRHqDcpq+2QF/ZlKVKJ7s+002kFgm8LBitARaGyezCf/S+SJq9LG
9lfb353NZvx+Opk2IQyhDYwQHmLx0SmGjKvpHAlNU6m6gHcoY4a0SgGmSj4RGQJd
SKLpiJQKEGea9FPSE9rtZhHfqHL7SJhWmghXCZrGq4/Q1n1OCJt91SeW4nzcPeM+
TxeNo5Icleth0wLxVwb4vRev64Aakkeald/GQ8dbFErXZ62DYYkUZfcu5dhMwWFz
LqjHRFMy9DL0dDkEutlmfp8rW7hO2n9egxrjyb7TVddmCSE1LnQfUNVYUs8xL3j+
0653rxNo/22He0WNdeozE3f/XtO4RWylB4DuNnA4wVUpSFgZgfVnGJV0VTPlsA8+
CurSES1UJsC2H89L9+8lgkQtcnqc0CtOTsXOaZpccfx5s9MrhaUYmNfETaj1mHl5
VFuFTg12iIul2HkcUpxMxI+wom7qhxG2jnGdrSX7KModsuWq3ZZshCB40W18uY9h
yCwriU8FI17/nTnsQHOZKt52DbYMuizfD8IS2iXYapd7GgMdQUXkwoy9n+i4lC3Y
sUDcNeT1GbqkCDtWCgJDOgaIB7khBSGsgWGkGM0lI5tB84LHxdfE4CsKVticIgHC
5OvbbhUokCU/CDvA7FnV
=si0i
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Feb_2014_16_48_08_+1100_sSuVKgJ4qkETPR3h--
