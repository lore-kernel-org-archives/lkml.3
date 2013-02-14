Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935164Ab3BNXza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:55:30 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49773 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab3BNXz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:55:28 -0500
Date: Fri, 15 Feb 2013 10:55:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Feb 13 (virtio_console)
Message-Id: <20130215105519.1d8de65d4f9195eeb9306c13@canb.auug.org.au>
In-Reply-To: <511D330A.2050407@infradead.org>
References: <20130213193532.162080d7c0557a307ab451ac@canb.auug.org.au>
	<511BEC55.5090801@infradead.org>
	<87sj4zk3ai.fsf@rustcorp.com.au>
	<511D30B4.5020201@infradead.org>
	<511D330A.2050407@infradead.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Feb_2013_10_55_19_+1100_Oxf339_eoIWCycFF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2013_10_55_19_+1100_Oxf339_eoIWCycFF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

The patch below is needed in the tty tree (which introduced CONFIG_TTY).

Also, has someone checked to see if any of the CONFIG_ symbols that had a
dependency on TTY added are selected anywhere else?

On Thu, 14 Feb 2013 10:55:06 -0800 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> On 02/14/13 10:45, Randy Dunlap wrote:
> > On 02/13/13 19:00, Rusty Russell wrote:
> >> Randy Dunlap <rdunlap@infradead.org> writes:
> >>
> >>> On 02/13/13 00:35, Stephen Rothwell wrote:
> >>>> Hi all,
> >>>>
> >>>> Changes since 20130212:
> >>>
> >>> on i386:
> >>>
> >>> drivers/built-in.o: In function `in_intr':
> >>> virtio_console.c:(.text+0x2dd31): undefined reference to `hvc_poll'
> >>> virtio_console.c:(.text+0x2dd41): undefined reference to `hvc_kick'
> >>> drivers/built-in.o: In function `resize_console':
> >>> virtio_console.c:(.text+0x2e26f): undefined reference to `__hvc_resiz=
e'
> >>> drivers/built-in.o: In function `unplug_port':
> >>> virtio_console.c:(.text+0x2e572): undefined reference to `hvc_remove'
> >>> drivers/built-in.o: In function `init_port_console':
> >>> (.text+0x2fe59): undefined reference to `hvc_alloc'
> >>> drivers/built-in.o: In function `virtio_cons_early_init':
> >>> (.init.text+0x16d1): undefined reference to `hvc_instantiate'
> >>>
> >>>
> >>> Full randconfig file is attached.
> >>
> >> This looks like an impossible config.  CONFIG_VIRTIO_CONSOLE=3Dy, but
> >> CONFIG_HVC_DRIVER isn't set.
> >>
> >> From drivers/char/Kconfig:
> >>
> >>         config VIRTIO_CONSOLE
> >>         	tristate "Virtio console"
> >>         	depends on VIRTIO
> >>         	select HVC_DRIVER
> >>
> >> ???
> >=20
> > OK.  It's probably yet another stinking problem with kvmtool and randco=
nfig.
> > Running *config reports:
> >=20
> > warning: (KVMTOOL_TEST_ENABLE && LGUEST_GUEST) selects VIRTIO_CONSOLE w=
hich has unmet direct dependencies (VIRTIO && TTY)
> >=20
> >=20
> > I'll look a bit more...
>=20
> Nope, that's not it.  Stephen's comments were much closer.
>=20
> The patch below fixes the kconfig warning and the build errors.
> ---
>=20
>=20
>=20
> From: Randy Dunlap <rdunlap@infradead.org>
>=20
> Fix kconfig warning for LGUEST_GUEST config by selecting TTY:
>=20
> warning: (KVMTOOL_TEST_ENABLE && LGUEST_GUEST) selects VIRTIO_CONSOLE whi=
ch has unmet direct dependencies (VIRTIO && TTY)
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>  arch/x86/lguest/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>=20
> --- linux-next-20130213.orig/arch/x86/lguest/Kconfig
> +++ linux-next-20130213/arch/x86/lguest/Kconfig
> @@ -2,6 +2,7 @@ config LGUEST_GUEST
>  	bool "Lguest guest support"
>  	select PARAVIRT
>  	depends on X86_32
> +	select TTY
>  	select VIRTUALIZATION
>  	select VIRTIO
>  	select VIRTIO_CONSOLE

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__15_Feb_2013_10_55_19_+1100_Oxf339_eoIWCycFF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRHXlnAAoJEECxmPOUX5FEpDAP/i7367UelpHER8M+o1wNhs+I
CcPUpqWEBsS9M7IYGtn3r01wChyFOtWqiytOndNw82/5Ox80YyDaYHszcTw2rqeJ
8R5VmNPCWzYy4mPRok1r0DKvbLekObCNd15DBCUnEhfIck37bWgmPyujYavm5u8I
ITla8PYD6cMu+X0Mgg+f6XxTW47dTKnai7KwxFH83MSzNEMbW0yf3qquKRu63FoF
/jKPTM5dKtRAC8+5w7I9lJuKK5jFjHvJCegiBNzOw0s3/oxz2waLsS2hAaeJgN6h
H7WNXL5h0zL62UdkW0cRIi/0iIb+veSxOdncgjhvc4Eu2cm+3FqOVjWwFZx2THC5
IpjjCcLUonWGHBSaVudwJbkhCfDPkSE/eB0YFqjGbSD+ockGvRkKiZb6CxY8vIBA
P0obbhLbLL8x2N/ZJDNmgNvXqXN27E5QHSOMRl0PRfzH3d1Kjhr05p2oqg+ClBV6
TFTL755h7bxsWOMmirqlY8+egqciHxTFlq/+f2RGTfikLYzhS55St3Eu2sI9yT9K
93M3Q4OOh+w/AfrQMbUz1+eTFg8kC4Qa7xHom9pChcpgUMn9ykDTu7NUBKiyFfj9
RoPExfHD/77z6VfI4jp2GSDsN72rzJTicFLnF72jhTzFXHy6kebMfO3ZCw/KiufM
EBxZ7FmbGyIlipKcHHtb
=fZ2B
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2013_10_55_19_+1100_Oxf339_eoIWCycFF--
