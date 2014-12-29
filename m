Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaL2Pzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 10:55:35 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35927 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbaL2Pzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 10:55:32 -0500
Date: Mon, 29 Dec 2014 09:54:40 -0600
From: Felipe Balbi <balbi@ti.com>
To: "Wu, Songjun" <songjun.wu@atmel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nicolas.ferre@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] USB: gadget: udc: atmel: fix possible oops when
 unloading module
Message-ID: <20141229155440.GB29379@saruman>
Reply-To: <balbi@ti.com>
References: <1419240374-12179-1-git-send-email-songjun.wu@atmel.com>
 <20141223162419.GB9147@saruman>
 <549A138D.50204@atmel.com>
 <20141226152707.GG17430@saruman>
 <54A121E9.6040100@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <54A121E9.6040100@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 29, 2014 at 05:42:01PM +0800, Wu, Songjun wrote:
>=20
>=20
> On 12/26/2014 23:27, Felipe Balbi wrote:
> >Hi,
> >
> >On Wed, Dec 24, 2014 at 09:14:53AM +0800, Wu, Songjun wrote:
> >>
> >>=E5=9C=A8 12/24/2014 00:24, Felipe Balbi =E5=86=99=E9=81=93:
> >>>On Mon, Dec 22, 2014 at 05:26:14PM +0800, Songjun Wu wrote:
> >>>>When unloading the module, the urb request will be dequeued
> >>>>and the completion routine will be excuted.
> >>>>If no urb packet, the urb request will not be added to the endpoint q=
ueue
> >>>>and the completion routine pointer in urb request is NULL.
> >>>>Accessing to the NULL function pointer will cause the oops issue.
> >>>>Add the code to check the urb request is in the endpoint queue or not.
> >>>>If the urb request is not in the endpoint queue, a negative error code
> >>>>will be returned.
> >>>
> >>>have you triggered the NULL pointer oops ? Care to add it to the commit
> >>>log.
> >>
> >>Executing the 'insmod g_hid.ko', then executing the 'rmmod g_hid.ko', t=
he
> >>NULL pointer oops will be triggered.
> >
> >what about all my other queries below and what about adding the oops
> >dump to commit log ?
> >
> >>>Also, which commit is this fixing ? Does this need to be backported ?
> >>>When was the bug introduced ?
> >
> Fixes: 914a3f3b3754 (USB: add atmel_usba_udc driver)
> Cc: stable@vger.kernel.org # always been there...
> This bug was introduced since the file 'atmel_usba_udc.c' was initialized.
>=20
> The oops dump log is shown in the following.
> # insmod g_hid.ko
> g_hid gadget: HID Gadget, version: 2010/03/16
> g_hid gadget: g_hid ready
> # rmmod g_hid.ko
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
000
> pgd =3D dedf0000
> [00000000] *pgd=3D3ede5831, *pte=3D00000000, *ppte=3D00000000
> Internal error: Oops: 80000007 [#1] ARM
> Modules linked in: g_hid(-) usb_f_hid libcomposite
> CPU: 0 PID: 923 Comm: rmmod Not tainted 3.18.0+ #2
> Hardware name: Atmel SAMA5 (Device Tree)
> task: df6b1100 ti: dedf6000 task.ti: dedf6000
> PC is at 0x0
> LR is at usb_gadget_giveback_request+0xc/0x10
> pc : [<00000000>]    lr : [<c02ace88>]    psr: 60000093
> sp : dedf7eb0  ip : df572634  fp : 00000000
> r10: 00000000  r9 : df52e210  r8 : 60000013
> r7 : df6a9858  r6 : df52e210  r5 : df6a9858  r4 : df572600
> r3 : 00000000  r2 : ffffff98  r1 : df572600  r0 : df6a9868
> Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: 10c53c7d  Table: 3edf0059  DAC: 00000015
> Process rmmod (pid: 923, stack limit =3D 0xdedf6230)
> Stack: (0xdedf7eb0 to 0xdedf8000)
> 7ea0:                                     00000000 c02adbbc df572580
> deced608
> 7ec0: df572600 df6a9868 df572634 c02aed3c df577c00 c01b8608 00000000
> df6be27c
> 7ee0: 00200200 00100100 bf0162f4 c000e544 dedf6000 00000000 00000000
> bf010c00
> 7f00: bf0162cc bf00159c 00000000 df572980 df52e218 00000001 df5729b8
> bf0031d0
> 7f20: bf003234 df52e400 df52e400 a0000013 00000081 c02acee0 00000000
> c02ad570
> 7f40: bf0160b0 bf016290 00000000 bf0160c0 bf0167a0 c0056748 00000022
> 69685f67
> 7f60: b6ff0064 00000001 b6ff3000 00000000 dedf6000 00000000 bebaaa4c
> c008370c
> 7f80: 00100871 c0081078 00000022 df5f31e8 b6ff4518 00000000 0001c588
> 69685f67
> 7fa0: b6ff0064 c000e3c0 0001c588 69685f67 bebaab78 00000880 bebaab78
> 00000880
> 7fc0: 0001c588 69685f67 b6ff0064 00000081 bebaae14 00000000 0000009f
> 00000000
> 7fe0: bebaab70 bebaab60 0001c464 b6f69ba0 60000010 bebaab78 3fffd821
> 3fffdc21
> [<c02ace88>] (usb_gadget_giveback_request) from [<c02adbbc>]
> (request_complete+0x64/0x88)
> [<c02adbbc>] (request_complete) from [<c02aed3c>]
> (usba_ep_dequeue+0x70/0x128)
> [<c02aed3c>] (usba_ep_dequeue) from [<bf010c00>] (hidg_unbind+0x50/0x7c
> [usb_f_hid])
> [<bf010c00>] (hidg_unbind [usb_f_hid]) from [<bf00159c>]
> (remove_config.isra.6+0x98/0x9c [libcomposite])
> [<bf00159c>] (remove_config.isra.6 [libcomposite]) from [<bf0031d0>]
> (__composite_unbind+0x34/0x98 [libcomposite])
> [<bf0031d0>] (__composite_unbind [libcomposite]) from [<c02acee0>]
> (usb_gadget_remove_driver+0x50/0x78)
> [<c02acee0>] (usb_gadget_remove_driver) from [<c02ad570>]
> (usb_gadget_unregister_driver+0x64/0x94)
> [<c02ad570>] (usb_gadget_unregister_driver) from [<bf0160c0>]
> (hidg_cleanup+0x10/0x34 [g_hid])
> [<bf0160c0>] (hidg_cleanup [g_hid]) from [<c0056748>]
> (SyS_delete_module+0x118/0x19c)
> [<c0056748>] (SyS_delete_module) from [<c000e3c0>]
> (ret_fast_syscall+0x0/0x30)
> Code: bad PC value
> ---[ end trace dd1fcf365005ba79 ]---
> Segmentation fault

you need to resend the patch with all of this properly placed on your
commit log.

--=20
balbi

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUoXlAAAoJEIaOsuA1yqREVP4P/ipgs8odPPO5CQ3eB/2zmuyX
zEsZE8buPYFOp7wMHVzUcqbxi/GtUCk/+YwI2pZ4lgqBRBqZtu146DvLVYHjeyiD
RIcWjDn1MSyvkfYtNBj9DLcMqhTHTAmExJRY8xj+ZcHMuxJ6bMrt5OmYzlBQ9klK
ZeK5nWSfyqEi95JDWEubigRJGfoWSQOh3p1eedgznlQdcRdN2oWo9SNXzCcqmTGC
tsAoILi8GieOlh2ofhY7u8b+RryDucmaqF+NXdOEGepGRGBCcm0NNtUVYR5jk4SL
kif0QKE6dhX3w8F8rtsmdM0EWQvTXAUCYLsrbbFIgfCwdbi+0kygJ8URgPqTvFdC
gYBl0x0/vhztgFzk6QXYBp/319kbcLm1/mJGMHS4TWnVngheHEWVfSan7gLBAWmi
8K1Cgh0k0DPABbygeKi2m2YVxAFlMEVrG/7pXDW6aYAzIO19SJdmpt4n3OtS95Bc
MWkIUKAg46l2DY1JU2p/6mjgwLN0SsXoQzduIE830kXJWl0nyaDULn2TvMHio9ZU
mKdfHpLmVM/fMh/IqMbR4ETVfK019PncbvaFAIz7+KKgld+DYm4d5mfSML2chn1R
2tuJ865MKeIYZ6dk1nnzFiMlqLL8ky9P+YuPp24CXo46j8TKDwpLsihIM2/ICbM9
7unAqLB1VJf1RdNJAFRN
=JjB2
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
