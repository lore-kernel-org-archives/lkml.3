Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205AbaEFHOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:14:17 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:44340 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933838AbaEFHOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:14:14 -0400
Message-ID: <53688BBF.5090406@linux.com>
Date: Tue, 06 May 2014 09:14:07 +0200
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux ATA/IDE <linux-ide@vger.kernel.org>,
        Joe Thomas <Joe.Thomas@dothill.com>
Subject: Re: [PATCH] ahci: unregister acpi notify handler when a ZPODD is
 unbound
References: <1398873887-23920-1-git-send-email-levex@linux.com> <536853F5.7040107@intel.com> <53687AE9.4010604@linux.com> <53687C1E.2020001@intel.com>
In-Reply-To: <53687C1E.2020001@intel.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Ko8KEVLqdCUA2uGeT4gu2iVBMwuWkGQuL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ko8KEVLqdCUA2uGeT4gu2iVBMwuWkGQuL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 05/06/2014 08:07 AM, Aaron Lu wrote:
> On 05/06/2014 02:02 PM, Levente Kurusa wrote:
>> Hi,
>>
>> On 05/06/2014 05:16 AM, Aaron Lu wrote:
>>> On 05/01/2014 12:04 AM, Levente Kurusa wrote:
>>>> When a ZPODD device is unbound via sysfs, the acpi notify handler
>>>> is not removed. This causes panics as observed in Bug #74601. The
>>>
>>> Ah...too bad, I forgot to consider this situation, thanks for trackin=
g
>>> this.
>>>
>>>> panic only happens when the wake happens from outside the kernel
>>>> (i.e. inserting media or pressing a button). Implement a new
>>>> ahci_remove_one function which causes zpodd_exit to be called for al=
l
>>>> ZPODD devices on the unbound PCI device.
>>>>
>>>> Signed-off-by: Levente Kurusa <levex@linux.com>
>>>> ---
>>>>
>>>> Hi,
>>>>
>>>> I am not sure if the loop below is correct. Maybe there is a better
>>>> solution to loop through all the devices which might use ZPODD?
>>>
>>> I didn't find a proper place either. For hotplug, we did the zpodd_ex=
it
>>> at ata_scsi_handle_link_detach. But for host controller pci device
>>> removal, we used scsi_remove_host in ata_port_detach and there is no
>>> place to add the zpodd_exit for a to-be-removed scsi device...
>>>
>>> Looks like we can only iterate the ata devices and call zpodd_exit
>>> explicitly for them if they are zpodd devices. Instead of adding a ne=
w
>>> remove callback, what about just embed that into the ata_port_detach
>>> like the following example?
>>
>> Yes, this makes more sense as this doesn't tinker with exports and suc=
h...
>> However this will throw unused variable compiler warnings if we add th=
e
>> required #ifdefs... Maybe a new function? ata_zpodd_detach_port?
>=20
> I think we can omit the #ifdefs as the loop is not called frequently an=
d
> thus doesn't cost much. We already have stubs for zpodd_dev_enabled and=

> zpodd_exit.
>=20

Ah, I see. Shall I send V2? Any tags I should add for you?

--=20
Regards,
Levente Kurusa
PGP: 4EF5D641


--Ko8KEVLqdCUA2uGeT4gu2iVBMwuWkGQuL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTaIu/AAoJELBqK2lO9dZBc5YH/1A0CH/2OBXH9NCfUpu9DF6R
L4bYBpRkkJKQWYQDaO5qxX6iblfxTCepNLtRzEmyocttqS/DS3i2Tz9IlzmIN8l9
KctZDRMLmdYGTIudxuF5IL9Z/u4Evok/DsPjRKFdH+8X6Yw/JXnevMrba3PgSdvB
Ptdu7O9TR6hQbGZic3DPy4DqkVz2heGwV1P3oy/o0Ja6Qhy64OoVYDpgRXk/FX+n
0058rGTgj9egVO5RptA9okamHyXJyithcyjZzq7p2aAW+JWgg98Y2FGvwmuyU1Ez
aa4dXiCM24LsjkLyCRwo4gIwAU4qSo85WbNtnVMFYolCYcNxaX+BUvX4SugIgPk=
=7oWh
-----END PGP SIGNATURE-----

--Ko8KEVLqdCUA2uGeT4gu2iVBMwuWkGQuL--
