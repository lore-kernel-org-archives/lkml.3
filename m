Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbaKSB2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:28:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:30270 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325AbaKSB2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:28:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,413,1413270000"; 
   d="asc'?scan'208";a="634212134"
Message-ID: <1416360528.2295.43.camel@jtkirshe-mobl>
Subject: Re: [PATCH v5 4/4] fm10k/igb/ixgbe: Use dma_rmb on Rx descriptor
 reads
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
Date: Tue, 18 Nov 2014 17:28:48 -0800
In-Reply-To: <20141119012430.9563.58999.stgit@ahduyck-server>
References: <20141119012205.9563.95544.stgit@ahduyck-server>
	 <20141119012430.9563.58999.stgit@ahduyck-server>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-NZN48hSAI1ItKPhBN68o"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NZN48hSAI1ItKPhBN68o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-11-18 at 17:24 -0800, Alexander Duyck wrote:
> This change makes it so that dma_rmb is used when reading the Rx
> descriptor.  The advantage of dma_rmb is that it allows for a much
> lower cost barrier on x86, powerpc, arm, and arm64 architectures than
> a
> traditional memory barrier when dealing with reads that only have to
> synchronize to coherent memory.
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

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

--=-NZN48hSAI1ItKPhBN68o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUa/JQAAoJEOVv75VaS+3Oz6IP/0oQ5zvlI81ZVcuheTYjcuXp
NNZaHboQLelF6+SnZWjepLRedcCGtJmfXBydPAl/hji8uyRts2GA8yZEAb+cQoZK
N08QkrguBBFZK+g8eiKczNBrSSvnv52z7/TnZI44npTjL6NQElrliKtsg06NG0e9
f2CFAPnjX4A51IPXvMmkZTbN6QKaD6r73kDePb/xHtKvd/xequqsFfgS8+0MiWfU
ktbmahiTQtbHXXH3V0DdMef3hmRBBaAzgNHnIoKpX0V3NAbt6ydDMZ74a68jUOd4
txT4Wl69haF2OPrSrI1p8lUFDbTS4Ej7OsHDmS4cAgSkBFEApRj42eQyDdgIJBhl
vMXyUUF9Wkr+gMNtZ6F0kxo1NmckBwaBulRszvTfKHkF2IeuVTusLzy2AXgxkVKd
+/bEQ5K7PR3WeFw7IFCRFm+qqR9DXHwxUeGcBHrIOGxbdKPjzYBBrRot9WCU2zmH
428kQjFz1s/FKPFle9n+foK90OGL0x9WzgRTfawLWvNwojGV6hQZbEHtRhIv0aS0
M6ot1m7TIBDBGu7nCZ5E1bQ9Oc/vJswRiyqyYHinFEO7GfQVM9XevB2A+R3NOn9v
Dux6Qtp8YknW01T/60MLKwc6Q4diucYfT2iZ4hVOWT1GIh8y3uK3TkgFk9RQlT3o
sPCtuR+ICeN2DIHqamv+
=d/US
-----END PGP SIGNATURE-----

--=-NZN48hSAI1ItKPhBN68o--

