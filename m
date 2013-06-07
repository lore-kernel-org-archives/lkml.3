Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3FGADq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 20:03:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34992 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3FGADp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 20:03:45 -0400
Date: Fri, 7 Jun 2013 10:03:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kim Phillips <kim.phillips@freescale.com>, Arnd Bergmann <arnd@arndb.de>,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        Borislav Petkov <bp@alien8.de>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>
Subject: Re: [PATCH v7] arm: use built-in byte swap function
Message-Id: <20130607100323.be805fa79db5f446fcfa14c2@canb.auug.org.au>
In-Reply-To: <20130606221234.GQ18614@n2100.arm.linux.org.uk>
References: <20130220214943.9b28a5b208da9f081387c55e@freescale.com>
	<alpine.LFD.2.03.1302202327370.6419@syhkavp.arg>
	<20130221005221.15279b1372501af12c1e4f32@freescale.com>
	<alpine.LFD.2.03.1302211134160.6419@syhkavp.arg>
	<20130221203327.6558f89277468f7ffffa6506@freescale.com>
	<alpine.LFD.2.03.1302212219100.6419@syhkavp.arg>
	<20130222194032.f7b44aefa5e2723d16767a1b@freescale.com>
	<1361661654.18110.102.camel@shinybook.infradead.org>
	<20130523114654.1f273241725205c6703b2226@freescale.com>
	<20130523231336.GS18614@n2100.arm.linux.org.uk>
	<20130606221234.GQ18614@n2100.arm.linux.org.uk>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Jun_2013_10_03_23_+1000_9HhIt2qX4P2wbQ=7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Jun_2013_10_03_23_+1000_9HhIt2qX4P2wbQ=7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Thu, 6 Jun 2013 23:12:34 +0100 Russell King - ARM Linux <linux@arm.linux=
.org.uk> wrote:
>
> So, we have a problem here - the kind which appears when people stuff
> things into the -next tree which aren't destined for the next merge
> window.  This is the relevant context from your patch, which is
> against linux-next:
>=20
> -                lib1funcs.o lib1funcs.S ashldi3.o ashldi3.S \
> -                font.o font.c head.o misc.o $(OBJS)
> +                lib1funcs.o lib1funcs.S ashldi3.o ashldi3.S bswapsdi2.o \
> +                bswapsdi2.S font.o font.c head.o misc.o $(OBJS)
>=20
>  # Make sure files are removed during clean
>  extra-y       +=3D piggy.gzip piggy.lzo piggy.lzma piggy.xzkern piggy.lz=
4 \
>                                                                ^^^^^^^^^
> -                lib1funcs.S ashldi3.S $(libfdt) $(libfdt_hdrs)
> +                lib1funcs.S ashldi3.S bswapsdi2.S $(libfdt) $(libfdt_hdr=
s)
>=20
> the underlined bit - piggy.lz4 for those who read mail with proportional
> fonts.
>=20
> That is not in any kernel I have, and if it _is_ something that is
> destined for the next merge window, it should be in my tree as it's
> a core ARM feature, not in some random other tree.

That is commit d8a6bf1b25bd ("arm: add support for LZ4-compressed
kernel") from next-20130606 from the akpm tree.  (adding author cc)  That
patch was cc'd to you, and is part of a series that adds LZ4 compression
to the kernel, so would not work on its own.  The first patch in the
series is "decompressor: add LZ4 decompressor module".


> Short of hand-editing and manually applying the patch, a solution would
> be to rebase it on a mainline kernel version, like -rc4, and resubmit
> that version instead.  That will ultimately then give sfr a conflict
> which should be trivial to resolve - and hopefully we'll find out who's
> carrying the LZ4 patch and putting it into linux-next.

People should *never, ever* submit patches based on linux-next (unless,
of course they are to me to help fix merge conflicts in linux-next, etc).
Patches submitted to a particular maintainer should be based on (an
ancestor of) that maintainer's current tree.

Sure, test new code before and after merging linux-next, but don;t base
new code on it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__7_Jun_2013_10_03_23_+1000_9HhIt2qX4P2wbQ=7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRsSNSAAoJEECxmPOUX5FEG5cQAKLhWnfzs/ehyVjQ+72vX+1N
wKUWlwAcxyfoR5jq7bBtr3WvhDHMz2NBTT4gtojLybGBEQe1cqb84gIGnC526dVG
FLcBiD+Ow5lGAJWLMUqqwk3282COLtuuNCThRt+ugsKnT6rRwt8KKVRGEFCJFEmZ
vd/29eCUnm1QdfB+8VaZUgGuUwRhL52lEIM91+6GAIzCZTFjCY8MfefU4S4oaAh+
dH+fN4Duw9dshtWrBGPlcmzYk36vbC4zrRaNe++7NSe5KCq/ThxVl3Xa3cizvQ7y
JvcJmMeG2HowC7wwaTqfkrrCMa2ijCWDOPli+EsRftRKLXINJjU7i5AFl7j/lZ3A
yMq98anl2jez7TZk5mcXr9h5lYcSOUUgOIVC0E/IPfa+efGUEMDKF0QGwvkPnUZZ
Ehr5kkSShO0xRfy4mB2vmk8Xq8AR0ov+peh7LnUfGElyNw7lrQ5Ff1tMYuhVtIoq
Jm5aj1BOdUUZNINy8XtKHSbTb51hOKuM4x0omYXNhyy/ezPO3wiac6meZkZ0ou1H
wJKAws+6h/qwObCJmNS18UMWbsDqwMDhc6Cs2bZdWZSW8vj9HFDgJSQW5vTxiLqN
D4giXLhuHmdC8AhC+qpROv1F1VtaX1noOY/JGMbwTep1WZIfwWvrFsya+MbEDKmp
cER4PI1dFl2wIbLQM8IC
=Jj85
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Jun_2013_10_03_23_+1000_9HhIt2qX4P2wbQ=7--
