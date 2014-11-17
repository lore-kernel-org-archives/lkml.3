Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaKQVda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:33:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:58400 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbaKQVd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:33:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,405,1413270000"; 
   d="asc'?scan'208";a="633437062"
Message-ID: <1416259940.2431.4.camel@jtkirshe-mobl.jf.intel.com>
Subject: Re: [PATCH 4/4] fm10k/igb/ixgbe: Use fast_rmb on Rx descriptor reads
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Alexander Duyck <alexander.h.duyck@redhat.com>
Cc: linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
        peterz@infradead.org, benh@kernel.crashing.org,
        heiko.carstens@de.ibm.com, mingo@kernel.org, mikey@neuling.org,
        linux@arm.linux.org.uk, donald.c.skidmore@intel.com,
        matthew.vick@intel.com, geert@linux-m68k.org, romieu@fr.zoreil.com,
        paulmck@linux.vnet.ibm.com, nic_swsd@realtek.com, will.deacon@arm.com,
        michael@ellerman.id.au, tony.luck@intel.com,
        torvalds@linux-foundation.org, oleg@redhat.com, schwidefsky@de.ibm.com,
        fweisbec@gmail.com, davem@davemloft.net
Date: Mon, 17 Nov 2014 13:32:20 -0800
In-Reply-To: <20141117171839.22333.25487.stgit@ahduyck-server>
References: <20141117171005.22333.96544.stgit@ahduyck-server>
	 <20141117171839.22333.25487.stgit@ahduyck-server>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-SJ9io6vVAIg6YTMxe64x"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SJ9io6vVAIg6YTMxe64x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-11-17 at 09:18 -0800, Alexander Duyck wrote:
> This change makes it so that fast_rmb is used when reading the Rx
> descriptor.  The advantage of fast_rmb is that it allows for a much
> lower cost barrier on x86, powerpc, arm, and arm64 architectures than
> a
> traditional memory barrier when dealing with reads that only have to
> synchronize to system memory.
>=20
> In addition I have updated the code so that it just checks to see if
> any
> bits have been set instead of just the DD bit since the DD bit will
> always
> be set as a part of a descriptor write-back so we just need to check
> for a
> non-zero value being present at that memory location rather than just
> checking for any specific bit.  This allows the code itself to appear
> much
> cleaner and allows the compiler more room to optimize.
>=20
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Matthew Vick <matthew.vick@intel.com>
> Cc: Don Skidmore <donald.c.skidmore@intel.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@redhat.com>
> ---
>  drivers/net/ethernet/intel/fm10k/fm10k_main.c |    6 +++---
>  drivers/net/ethernet/intel/igb/igb_main.c     |    6 +++---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    9 ++++-----
>  3 files changed, 10 insertions(+), 11 deletions(-)

Looks like more changes will be coming, based on the feedback on earlier
patches.  So I won't be picking this up for validation purposes.

--=-SJ9io6vVAIg6YTMxe64x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUamlkAAoJEOVv75VaS+3O0ZgP/2XB7qTyftjJJNesgQFUjszb
qaZ0npYLrCYcu5jWemrtYUA+cXsScZrLelx83ot3srUdisFrl1uyi9SSVLH9LoL3
zNqrsx13FiWMvCtUZHe6fwyzMqihc87N1J1ktK/yuejmSOupXBQhxTu8/gAD6cFN
KJjLHoTcFIWn/DAJ+FVQeu1K4IOgAUichxqF+AXarC1lFy5XF7j6iO0Se5MoJv1l
Fw4ZdrsK+csl7oyQKs84+GuQefzHY9T0sgdVzgQCOMbSNVT1bRX7EKqRlTGQLEcf
rZqbtm5hfV55m1D5vs9I4X8uHi7gyeJ9p8A98vdqufx96TZSNu+cRDIcL1voRoeb
BKgxrVt8c0xR9jLBzVdQF1WMTLwiBrFIMRboHhp7IufFz8gzoQhAZ7oQxaafF+QI
Z5c3NGm6OzTMqD31QOSc7yuIl9nfLFYsJW+0/gnLif702l3rNZxjXejCQn/xHy04
xrTqieJSmb7d4jT3ROrhF4SQg1bFHfmPnfThgorXTpu3w3DpS6adQPEbKNXBRy3Y
NUey3VPJpy2lSVMkVVQruNqp+PmTkmy8wMI3/cYL3Qe0MWipGZsa1fGKEe6VyyY+
KhjNPu7hFdzFji0dy3Rdpm0ZkUgOIZAxkrBqcRgaMQdwt+RiarpKl3WMTZw0eZSA
NMTsCITWHUL4VgTBZIYO
=fS+J
-----END PGP SIGNATURE-----

--=-SJ9io6vVAIg6YTMxe64x--

