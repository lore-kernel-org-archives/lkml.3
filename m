Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaHSUGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:06:53 -0400
Received: from omr1.cc.vt.edu ([198.82.141.52]:37777 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbaHSUGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:06:52 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [UML] 3.16 build without optimization fails
In-Reply-To: Your message of "Tue, 19 Aug 2014 21:12:10 +0200."
             <1408475530.15309.7.camel@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <1408475530.15309.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1408478794_2094P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 19 Aug 2014 16:06:34 -0400
Message-ID: <20267.1408478794@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1408478794_2094P
Content-Type: text/plain; charset=us-ascii

On Tue, 19 Aug 2014 21:12:10 +0200, Thomas Meyer said:
> > Hi,
> >
> > the build with -O0 fails with:

> > bug or feature?
> >
> > any ideas?

Feature.  The kernel is *known* to not build with -O0, because that
disables *all* function inlining, and there's several functions that *have*
to be inlined in order to function properly (most notably, anything
that uses the gcc __builtin_return_address in a function that is expected
to be inlined).

--==_Exmh_1408478794_2094P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU/OuSgdmEQWDXROgAQJAihAAm0xwr24ttzu7Zkewe8Hfml7KdmLuaPlZ
wTH3ZUbJcswNj8U5A4JfNEK1Ab1u1V+fbCAyE5QBQt2siXh6bpMHTfsihO8h+RY0
eVpK2uSsLm/Sejlds9F4V0TpqBXHcjBGXS0/nELcP9Msb4IIO4uMFg7ITzQEE8D6
yxq16j8jBydguaChKwVFIOSTHqFTQpt6MUnU36tK8DQo9p+KWzHv8spFzOH6s0tL
aASsOBFLcMOSUPEOa/g7mK/wGXZAS4a0NjgljpOWdwGUmTDKFSiqTnDINBzFlr1g
B0hYL/JgYflMoyJryOxNB8nn2yjVmlhGTzwcSWWhIRfZfH0gIu9UJUPmo7zPlNgL
64u6cJjC05X6Qjxe1dML7+H16dsfAWeIQ2P1DIYuvfMDUV5ffVstHryLNLBi+L/x
nD3sPpR8XzJNJjuo1jFJqAK5dDaEuSbHX4p9qnXAFC62wE9iYh1SSGnQ4QcJuK9U
uMRTwkFoPy9yFLYseJtqZCOT4qNpcI5UwyJERxyu7n6jKbuCzDnCXfiexmYQEPdQ
NUCZMpyu+8tgLSSt12SAKr0I4Wu28KERKrncx6JutjyldRmN5ZUkmVyQwrzyP2ZF
sJrYP/2XELaQNm4Dg/b78ZbkzA72K5577m/pjNNKtbH+08FIWn+/lnGjMvzEOhfl
2RmQHGedGkQ=
=WSPb
-----END PGP SIGNATURE-----

--==_Exmh_1408478794_2094P--
