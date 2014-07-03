Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbaGCHEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:04:10 -0400
Received: from mout.web.de ([212.227.17.12]:64521 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaGCHEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:04:08 -0400
Message-ID: <53B50062.30200@web.de>
Date: Thu, 03 Jul 2014 09:04:02 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Hui Wang <hui.wang@canonical.com>
CC: Hui Wang <jason77.wang@gmail.com>, tiwai@suse.de,
        alsa-devel@alsa-project.org, alex.hung@canonical.com, yk@canonical.com,
        david.henningsson@canonical.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [V2 PATCH] ALSA: hda - Enable mute/mic-mute LEDs for more Thinkpads
 with Conexant codec
References: <1385534846-20829-1-git-send-email-hui.wang@canonical.com> <53AFF992.5030403@web.de> <53B0C596.6090007@canonical.com> <53B1078B.4090101@web.de> <53B219DF.6090807@canonical.com> <53B26575.1000003@web.de> <53B27ED7.4070401@canonical.com>
In-Reply-To: <53B27ED7.4070401@canonical.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="wIRoUibvDoE2B02u7dbWPTjdw07uiX4bj"
X-Provags-ID: V03:K0:WCE7FYy9OVTQKYtiGWiRUgfEUk08bt3ZnLGoQrXcgklC/Fl+WHG
 DkRGkhxnGf2jRZTC//lGeOqOPB5VzmtgKenAUK/6VodZVhilT9H9zx8ncXrY23M/rdmNdn2
 wMw2Sy7zXJFzSNQjoc8ZEUEUE7JeX8OxKisoR0gzs7S5mv17wkxlud18RQ/vK5j3x3TNzHq
 hpelBUEQjb3814mzwL5Xg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wIRoUibvDoE2B02u7dbWPTjdw07uiX4bj
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-07-01 11:26, Hui Wang wrote:
> On 07/01/2014 03:38 PM, Jan Kiszka wrote:
>> On 2014-07-01 04:15, Hui Wang wrote:
>>> On 06/30/2014 02:45 PM, Jan Kiszka wrote:
>>>> On 2014-06-30 04:04, Hui Wang wrote:
>>>>> On 06/29/2014 07:33 PM, Jan Kiszka wrote:
>>>>>> On 2013-11-27 07:47, Hui Wang wrote:
>>>>>>> Most Thinkpad Edge series laptops use conexant codec, so far
>>>>>>> although
> <snip>
>>>>>>>
>>>> Is there anything I can debug or any information I can collect from =
my
>>>> box to examine this?
>>> What is the linux distribution on your machine? And use showkey to ca=
tch
>>> the keycode of that button.
>> I'm running OpenSUSE 13.1. The reported keycode of the power button is=

>> 116.
> It seems the keycode is correct, it is power keycode rather the mute
> keycode.
>=20
> Could you please do some debug, let us find which line of code is the
> root cause for this problem. for example:
>=20
> after running the line, the problem shows up:
>=20
> 1.     if (ACPI_SUCCESS(acpi_get_devices("LEN0068", acpi_check_cb,
> &found, NULL)) && found) // in the sound/pci/hda/thinkpad_helper.c,
> is_thinkpad()

This evaluates to true

>=20
> 2.     return ACPI_SUCCESS(acpi_get_devices("IBM0068", acpi_check_cb,
> &found, NULL)) && found; // same as above
>=20
> 3.         if (led_set_func(TPACPI_LED_MUTE, false) >=3D 0) { //in the
> sound/pci/hda/thinkpad_helper.c, hda_fixup_thinkpad_acpi()

=2E..and this

>=20
> 4. if (led_set_func(TPACPI_LED_MICMUTE, false) >=3D 0) { // same as abo=
ve
>=20

=2E..and this as well. spec->num_adc_nids is 1.

Jan



--wIRoUibvDoE2B02u7dbWPTjdw07uiX4bj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlO1AGIACgkQitSsb3rl5xQCvQCgyHPB2f7hTX5X9OPbMhnudaBz
6iUAniHhhGy+m9CM12QO7+ROVDKvfF2W
=mx87
-----END PGP SIGNATURE-----

--wIRoUibvDoE2B02u7dbWPTjdw07uiX4bj--
