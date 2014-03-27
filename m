Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbaC0BJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 21:09:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48408 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166AbaC0BJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 21:09:27 -0400
Date: Thu, 27 Mar 2014 01:08:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Arun Shamanna Lakshmi <aruns@nvidia.com>, lgirdwood@gmail.com,
        swarren@wwwdotorg.org, Songhee Baek <sbaek@nvidia.com>,
        alsa-devel@alsa-project.org, tiwai@suse.de,
        linux-kernel@vger.kernel.org
Message-ID: <20140327010852.GA30768@sirena.org.uk>
References: <1395792156-4178-1-git-send-email-aruns@nvidia.com>
 <53332CC7.6060800@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <53332CC7.6060800@metafoo.de>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.45.252.252
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 26, 2014 at 08:38:47PM +0100, Lars-Peter Clausen wrote:
> On 03/26/2014 01:02 AM, Arun Shamanna Lakshmi wrote:

> The way you describe this it seems to me that a value array for this kind=
 of
> mux would look like.

> 0x00000000, 0x00000000, 0x00000001
> 0x00000000, 0x00000000, 0x00000002
> 0x00000000, 0x00000000, 0x00000003
> 0x00000000, 0x00000000, 0x00000004
> 0x00000000, 0x00000000, 0x00000008

> That seems to be extremely tedious. If the MUX uses a one hot encoding how
> about storing the index of the bit in the values array and use (1 << valu=
e)
> when writing the value to the register?

Or hide it behind utility macros at any rate; I've got this horrible
feeling that as soon as we have this people will notice that they have
more standard enums that are splatted over multiple registers (I think
=66rom memory I've seen them but they got fudged).

> [...]
> >  /* enumerated kcontrol */
> >  struct soc_enum {

> There doesn't actually be any code that is shared between normal enums and
> wide enums. This patch doubles the size of the soc_enum struct, how about
> having a separate struct for wide enums?

Or if they are going to share the same struct then they shouldn't be
duplicating the code and instead keying off num_regs (which was my first
thought earlier on when I saw the separate functions).  We definitely
shouldn't be sharing the data without also sharing the code I think.

> >-	int reg;
> >+	int reg[SOC_ENUM_MAX_REGS];
> >  	unsigned char shift_l;
> >  	unsigned char shift_r;
> >  	unsigned int items;
> >-	unsigned int mask;
> >+	unsigned int mask[SOC_ENUM_MAX_REGS];

> If you make mask and reg pointers instead of arrays this should be much m=
ore
> flexible and not be limited to 3 registers.

Right, which pushes towards not sharing.  Though with an arrayified mask
the specification by shift syntax would get to be slightly obscure (is
it relative to the enums or the registers?) so perhaps we don't want to
do that at all if we've got specification by shift.  If we do that then
we could get away with a variable length array at the end of the struct
though I think that may be painful for the static declarations.  Someone
would need to look to see what works

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTM3obAAoJELSic+t+oim9Bs0QAJ0eqDsnijtkzYfHUXtnYLJ5
jXUEAEiWzZ4Uyo+gvTOP/qOoA4cINMsJ8k8dZX0F3fx+d9OaSX8XUwbO+unjkxbR
y1kuLU24eFaFNnB1t6FgzIBtLzoAw0RkhmyT4ALAyY5pdolfMZkTVt7IKYictDTd
MR8ghUGPIyMZLeQyQjURGtj5u1b37gZBw/7/oeo7IweE6JQtDBqxMjYDow8jhH9q
UTrAqZOwmG5OavDuur1RrnwPw1dKa9S8nCtRDi2gI96L0hs+SkXPPMBzo3uJYIy3
Cj2gSaBHndrky2v0iJI4/4dIXaXeP9Pyy98E9c0RqxDqSANAsupL7Ad73wGGbnYM
nsKok435fT1KGZyIZe8QeywQ8yqCE3HDJ45/yPN8PgX/YiJa5QowzpZFKUAeVhq0
+KdkUWinGca9Wq4H9Vh4HuVmOnF3ow19dA32+L0XCTIZh0wbZ0DVNTZHLiuWP0Ay
K9pHCX41cAMHjchRUyluIJ9N32OMz2MhShWiUR3BgGewTRYmMNnOgEf472e5QwT3
ChM0l5J9+Vlt66D0seQ3GZ9AH9EJNgg7i4j8PdLhRlHNw0HeUxTtGnjmTM1TN2pa
0qELAxaV76vervqVId//EI7XNRvZW3al1FqgLdPhXjqhM9zR/EbULb01YWK9Uid9
SnO6x2+2/xo77MJvL6ES
=D05e
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
