Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaESP0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:26:04 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:65265 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaESP0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:26:02 -0400
Date: Mon, 19 May 2014 17:25:56 +0200
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH] regulator: core: Fix the init of DT defined fixed
 regulators
Message-ID: <20140519172556.17c49589@avionic-0020>
In-Reply-To: <20140519143949.GW12304@sirena.org.uk>
References: <1400497954-1012-1-git-send-email-alban.bedel@avionic-design.de>
	<20140519143949.GW12304@sirena.org.uk>
Organization: Avionic Design
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/UTCtMfzPZN9Mgqj0HpMrymc"; protocol="application/pgp-signature"
X-Provags-ID: V02:K0:Fvlw1Upgh+WuTuKBaHQE2BjkAKhtVMgrN3/a4grROOO
 s31HhejzyZ4sNTfpfsuDARYi1Ox1/0ODEYlvgTaEFtf/Ozyvmo
 mq7YMqHtUXqPgN9lGMmc6eX7IY86LXS7CtcqiWlbLoA+G7Gvef
 pBg28MskpOjBvjauHUj6kJHEZRXvWVeErtkjJMHLj36xJmXClx
 VuA2dwqJ4CLhDhQasByD6vxfiPCCtoygr2aMnlc8oscIqGZ8d4
 3XydFQF1WrmmOpZJ+btZWCjQKbGKrjzz3rNNNaNgWTXIbfPuTo
 htvBpRNj1tz7q+iG5H3HNnEwZUcfAqu0J/GyGuF1qgPJ9yiZ0B
 SLgfcUTjpQV8JAfNK+B4K43N3uVwRiZ3vMlesfuOk88bhsSlGP
 J9k765/NNZulg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UTCtMfzPZN9Mgqj0HpMrymc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 May 2014 15:39:49 +0100
Mark Brown <broonie@kernel.org> wrote:

> On Mon, May 19, 2014 at 01:12:34PM +0200, Alban Bedel wrote:
>=20
> > When a regulator is defined using DT and it has a single voltage the
> > regulator init always tries to apply this voltage. However this fails
> > if the regulator isn't settable. So skip this step if the regulator
> > doesn't provides any set method.
>=20
> No, this means we'll just ignore the voltage someone tried to set.  A
> bigger question is why someone is trying to configure the voltage of a
> fixed voltage regulator in DT...

We have a platform where a TPS658621 has been replaced by a TPS658640
in newer version of the hardware. One of the few difference between both
regulator is that one output is now fixed. One could write a new DT that
doesn't "set" this output. But IMHO the current DT should still be usable
as the voltage declared for the now fixed regulator is still correct.

Would checking that the regulator is at the voltage declared in the DT
better? Or should I just add a pseudo set method to the regulator driver
that only accept the current voltage? That could also be implemented at
the core level using a default method for all regulators that have a get
but no set method.

Alban

--Sig_/UTCtMfzPZN9Mgqj0HpMrymc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTeiKEAAoJEHSUmkuduC282xAP/03f0yCmagugqbWM6rJry5sb
N+PHx1gMya3bjKtVeHYMLt3wCUmADoT8hL1qqDXepPVWEOxFYNtm6K7h3N5vnwM5
b0yF72ElH1c5nfAddJBFDJLuViQafWU0xn8em6wQRl9kKYz7ZXXQ5cggDcwFpqAm
0OSmcidr8b4s7QHbF6/qeFIJzS25qFnzAoyFspE18s7NZwOyUi1i1glok1QDYY3i
ewslAQuSnrNmhvhI1hIz1We3HIs113UBrZflt0mqOZXlType+EfiVzrVoa+kTGkh
8C4oXscmAwcz/SMEYpRsvGS0f26tbzNZ+/U064XuL6Rh0CCnf/kXI5bbbbBSpIbj
Dw+MQAltx1YULhFkohUsUPFF2T5CIr/M9l3RNHd1j2diYQMdt7iV8fxBDT/2G1MD
8XpLJVrRkZyKxDEb0Gv4q6chm/sILbN5nrYterr0qvbrFLNNxbgcJAsOkyp9CUqe
fbGPMGXMRWCY5eqWMHWEiMwiwTqBHhwM8Tbp4t9iYKqgeBnvVJcC7jAhXO3pYwB1
RVFexp6v+ivaW1HZzq0Xh4lJhnr2gIB6AeefIMU3+2KGY2T6gAStrszAPjdae2uA
9XAHw+UieVrElkecuGg98+aHB233S7cEylEC9QHOXhkNjvE9IM3XyvEEuo/YHt0E
gx3oKZxGuzcyey812koz
=XLTd
-----END PGP SIGNATURE-----

--Sig_/UTCtMfzPZN9Mgqj0HpMrymc--
