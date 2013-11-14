Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3KNQ37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:29:59 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:45945 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab3KNQ3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:29:51 -0500
Message-ID: <5284FA75.4040601@monstr.eu>
Date: Thu, 14 Nov 2013 17:29:41 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        microblaze-uclinux@itee.uq.edu.au, devicetree@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH RFC 15/17] microblaze: Convert from _fdt_start to __dtb_start
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org> <1384285347-13506-16-git-send-email-geert@linux-m68k.org> <5283524F.8030902@monstr.eu> <5283814C.6040904@monstr.eu> <5283A573.6020403@gmail.com>
In-Reply-To: <5283A573.6020403@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="PqGQeILfHAdb3iIoJpgcaA3RufafL7qtV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PqGQeILfHAdb3iIoJpgcaA3RufafL7qtV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/13/2013 05:14 PM, Rob Herring wrote:
> On 11/13/2013 07:40 AM, Michal Simek wrote:
>> On 11/13/2013 11:19 AM, Michal Simek wrote:
>>> On 11/12/2013 08:42 PM, Geert Uytterhoeven wrote:
>>>> Kill the microblaze-specific __fdt_blob section, and start
>>>> using .dtb.init.rodata from <asm-generic/sections.h> for
>>>> built-in DTBs, like most other DT enabled architectures.
>>>>
>>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org> Cc:
>>>> Michal Simek <monstr@monstr.eu> Cc: Rob Herring
>>>> <rob.herring@calxeda.com> Cc:
>>>> microblaze-uclinux@itee.uq.edu.au Cc:
>>>> devicetree@vger.kernel.org --- Untested, but the resulting
>>>> vmlinux after "make simpleImage.system" looks sane.
>>>>
>>>> QUESTION: The padding of the DTB is gone, is this OK?
>>>
>>> Removing this kernel padding should be fine. I can't remember why
>>> it was there from the beginning.
>>
>> I know why is this here. The reason is process how dtb is passed to
>> the kernel via command line. head.S code just copy that dtb to the
>> same location where compiled-in dts is expected and kernel doesn't
>> need to care about position of dtb because this copy is done
>> without MMU. And the full kernel is covered by 2 tlbs and we don't
>> need to use another TLB for dtb mapping.
>>
>> It means pad matters a lot. Because u-boot ITS format doesn't use=20
>> simpleImage target but the kernel need to have a space for copying=20
>> dtb to this kernel location.
>>
>> Let me think about if there is an easy way to handle dtbs which are
>> passed from bootloader.
>=20
> Isn't the built-in dtb in a RO init section? Seems like a bad idea to
> write to it. Also, it will be a double copy because a built-in dtb has
> to be copied out of init section.

Microblaze has it currently out of RO section.
This patch is adding it there.

I have looked at powerpc flow which is probably the closest to our versio=
n.

head.S
Saving dtb pointer to r31 then initial_mmu which setups 16MB tlb for kern=
el
then some exception and calling machine_init()->early_init_devtree()
->move_device_tree() where also change initial_boot_params location
for unflatten_device_tree() in setup_arch().

Ben: I didn't find any TLB entry for DTB itself.
Does it mean that I missed it or that powerpc can access in machine_init(=
)
the whole memory space?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--PqGQeILfHAdb3iIoJpgcaA3RufafL7qtV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKE+nsACgkQykllyylKDCHnKgCdFzhDnKZrwD7RCx5D1S1nT3dT
39EAn3O7U8yvIzBvowJyzZf9xOuJ3kFZ
=hnEu
-----END PGP SIGNATURE-----

--PqGQeILfHAdb3iIoJpgcaA3RufafL7qtV--
