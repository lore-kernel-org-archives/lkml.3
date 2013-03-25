Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab3CYFOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 01:14:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48499 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298Ab3CYFOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 01:14:43 -0400
Date: Mon, 25 Mar 2013 16:14:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chen Gang <gang.chen@asianux.com>
Cc: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>, matt@ozlabs.org,
        imunsie@au1.ibm.com, linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PowerPC:kernel: make additional room in exception
 vector area
Message-Id: <20130325161435.ffff94805826bc7cad2c7de4@canb.auug.org.au>
In-Reply-To: <514FA8F3.1030102@asianux.com>
References: <51428C81.6000204@asianux.com>
	<25841.1363323174@ale.ozlabs.ibm.com>
	<5142AE27.7060003@asianux.com>
	<514AA0D9.1090509@asianux.com>
	<10123.1363906486@ale.ozlabs.ibm.com>
	<514C0061.8080004@asianux.com>
	<29457.1364169818@ale.ozlabs.ibm.com>
	<514FA8F3.1030102@asianux.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Mar_2013_16_14_35_+1100_zE=a3GxGNOj/lX0k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Mar_2013_16_14_35_+1100_zE=a3GxGNOj/lX0k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 25 Mar 2013 09:31:31 +0800 Chen Gang <gang.chen@asianux.com> wrote:
>
>   The FWNMI region is fixed at 0x7000 and the vector are now overflowing
>   that with allmodconfig. Fix that by moving slb_miss_realmode code out
>   of that region as it doesn't need to be that close to the call sites
>   (it is a _GLOBAL function)
>=20
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/powerpc/kernel/exceptions-64s.S |  144 +++++++++++++++++-----------=
------
>  1 files changed, 72 insertions(+), 72 deletions(-)

Thanks, Chen,

I have applied this to linux-next today and pending the builds overnight,
will send it to Linus tomorrow or Wednesday.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__25_Mar_2013_16_14_35_+1100_zE=a3GxGNOj/lX0k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRT907AAoJEECxmPOUX5FEkIUP/jK8nEzxczJ2qal/XwuZp4TQ
Jm65w5SticAj/s8oWbxehKUMx6hdx3qUPO5cgGuvE5UGInuuMDHhk5Gf1B+R9beF
mzyLgYVG/sYcMS0P6nTLM41+bshOqCD9PUVeQmNMOfIXyMv0Bhk5cSux9t1hpa93
mwC6UgdSaFLnFlz2WQHE2BsdmljuY70xZ1C6S7Rtti/xBI5MNVSWj2tFYZ9IKIc7
iuHJ6nlJHwxSZr2HoNfTTwlZYTgMGRyyjfOvHh4KF8BDaxUXqQ5jAGrEJ0gWWF/3
Y8FLLj3nGcnnxEeBXiQo5Z/XN2UJ6nZVHKjy4NLxyxTztPjvGGmsL9PdJlQO4Khm
Gp775W05r31WMevr7mBHUUMwGAttpttwxbLcPtXpvFYhYKFI9W5aKbnw5EcULGQc
11nwjWZeHfhg6jUn/k2O0KJe9QQS1hYESnAaj85V8t7rYn5RuI+R18KkQLMAZ9C3
mIr6v5g6jtteCGb+Yjf6JZLiZvMQV97IK3JJjWq7nItmOjE3D+ovBV2b5pDH2Dhr
F0ux0NPXSiJl23GmM4VMo1eqHdECwNXROOD5sZti7gB8E4yjvyTBntRIlynUalst
wueCuGgOJF8lhFvCtKoXXSiqm3YJVzorUVee0scLyYIWXXrfIC2W9F/0E1j6m2x4
hAYWZxLTqqb9zwvd93Qj
=PnnT
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Mar_2013_16_14_35_+1100_zE=a3GxGNOj/lX0k--
