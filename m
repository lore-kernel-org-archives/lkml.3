Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab3FFNsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:48:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52757 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3FFNsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:48:51 -0400
Message-ID: <51B09331.9050906@ti.com>
Date: Thu, 6 Jun 2013 09:48:33 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: amit daniel kachhap <amit.daniel@samsung.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <linux-pm@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V4 00/30] thermal: exynos: Add thermal driver for exynos5440
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com> <51939F61.5020904@ti.com> <CADGdYn4MqTLvR4=HS6U7iWxO64Q8carQtApqZnm6kkCf26-D5Q@mail.gmail.com> <51ADE41E.3070202@ti.com> <51ADE515.5020802@ti.com> <CADGdYn4+j9nd=5j-YjYvbh_hWXVw3cKx12jYmvL7YJqVRDvAtA@mail.gmail.com>
In-Reply-To: <CADGdYn4+j9nd=5j-YjYvbh_hWXVw3cKx12jYmvL7YJqVRDvAtA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2OGCIGRQIVPHNWAUODNTB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2OGCIGRQIVPHNWAUODNTB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 04-06-2013 23:49, amit daniel kachhap wrote:
> On Tue, Jun 4, 2013 at 6:31 PM, Eduardo Valentin
> <eduardo.valentin@ti.com> wrote:
>>
>> Hi,
>>
>> On 04-06-2013 08:57, Eduardo Valentin wrote:
>>> On 04-06-2013 00:55, amit daniel kachhap wrote:
>>>> Hi Eduardo,
>>>>
>>>> On Wed, May 15, 2013 at 8:14 PM, Eduardo Valentin
>>>> <eduardo.valentin@ti.com> wrote:
>>>>> On 14-05-2013 05:58, Amit Daniel Kachhap wrote:
>>>>>> Changes in V4:
>>>>>>  Almost all the changes in this version is as per suggestion from =
Eduardo.The
>>>>>>  major ones are listed below,
>>>>>> * Added kconfig symbol ARCH_HAS_TMU which needs to be enabled by p=
latform. With
>>>>>>   this change existing symbol EXYNOS_TMU_DATA is not needed.
>>>>>
>>>>> I was more thinking if we could have a single flag that we could us=
e in
>>>>> thermal drivers. Besides, my proposal for ARCH_HAS_BANDGAP is still=
 not
>>>>> merged yet.
>>>>
>>>> yes a single flag might be useful such as ARCH_HAS_THERMAL but this
>>>> patch can work as an intermediate solution.
>>>
>>> I think bandgap is a generic enough term IMO.
>>>
>>> [1] - http://en.wikipedia.org/wiki/Bandgap_voltage_reference
>>> [2] - http://en.wikipedia.org/wiki/Silicon_bandgap_temperature_sensor=

>>>
>>
>> Hit the send button too early. So, I think bandgap is a generic enough=

>> term. Using bandgap I believe it is better because its meaning has the=

>> implication of having a device to control thermal.
>>
>> But if you feel more confident with the thermal term we can switch to
>> something like HAS_THERMAL_CONTROL.
>=20
> Even in my case TMU uses bandgap voltage reference circuit. so
> ARCH_HAS_BANDGAP should be fine.
>=20

OK cool! then we have a consensus.

I am trying for some time already to push this patch here:
https://patchwork.kernel.org/patch/2659001/


Tony, Arnd?

Any objections having the patch above in?

> Thanks,
> Amit Daniel
>>
>>>
>>>>
>>>> Thanks,
>>>> Amit Daniel
>>>>>
>>>>>> * Movement of freq_clip_table from exynos_tmu.h to exynos_thermal_=
common.h is
>>>>>>   explained in the commit logs.
>>>>>> * Wrote all register description documentation.
>>>>>> * Split 5440 TMU support patch into controller change, configurati=
on data and
>>>>>>   feature addition patches.
>>>>>> * Remove all *LINUX_* in the header files.
>>>>>> * Still regulator enable is kept optional but a TODO: comment is a=
dded to fix
>>>>>>   it later.
>>>>>>
>>>>>> Changes in V3:
>>>>>> * Added proper dependency of different exynos thermal Kconfig symb=
ols. Basically 3
>>>>>>  Kconfig can be enabled now and corresponds to tmu driver. exynos =
common part
>>>>>>  and exynos configuration data. This issue was raised by Rui Zhang=
=2E
>>>>>>
>>>>>> Changes in V2:
>>>>>> * Separated SOC data from TMU driver. This is as per suggestion fr=
om Eduardo.
>>>>>> * Merged the new file created for exynos5440 TMU controller with t=
he existing
>>>>>>  TMU controller code.
>>>>>> * Removed the DT parsing code as now the SOC specific data are cle=
anly put
>>>>>>  inside the data specific file.
>>>>>> * Even the register definations/bitfields are treated as data as t=
here is
>>>>>>  some variation across SOC's.
>>>>>>
>>>>>> This patchset adds TMU(Thermal management Unit) driver support for=

>>>>>> exynos5440 platform. There are 3 instances of the TMU controllers =
so
>>>>>> necessary cleanup/re-structure is done to handle multiple thermal =
zone.
>>>>>>
>>>>>> Patch (exynos4: Add documentation for Exynos SoC thermal bindings)=
 from
>>>>>> Lukasz Majewski is already posted to mainline. Adding it here for =
completeness.
>>>>>> (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg=
17817.html)
>>>>>>
>>>>>> Patch (thermal: exynos: Support thermal tripping ) from Jonghwan C=
hoi is
>>>>>> added here with some changes.
>>>>>> (https://patchwork.kernel.org/patch/1668371/)
>>>>>>
>>>>>> Patch (thermal: exynos: Support for TMU regulator defined at devic=
e tree)
>>>>>> is a repost of my earlier patch(https://patchwork-mail1.kernel.org=
/patch/2510771/)
>>>>>> and adds regulator support.
>>>>>>
>>>>>> Patch (ARM: dts: Add device tree node for exynos5440 TMU controlle=
r) and
>>>>>> patch (arm: exynos: enable ARCH_HAS_TMU) can be merged through exy=
nos platform
>>>>>> maintainer as this can cause merge conflict.
>>>>>>
>>>>>> All these patches are based on thermal maintainers git tree,
>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git nex=
t.
>>>>>>
>>>>>> Amit Daniel Kachhap (29):
>>>>>>   thermal: exynos: Moving exynos thermal files into samsung direct=
ory
>>>>>>   thermal: exynos: Add ARCH_HAS_TMU config to know the supported s=
oc's
>>>>>>   thermal: exynos: Remove CPU_THERMAL dependency for using TMU dri=
ver
>>>>>>   thermal: exynos: Bifurcate exynos thermal common and tmu control=
ler
>>>>>>     code
>>>>>>   thermal: exynos: Rename exynos_thermal.c to exynos_tmu.c
>>>>>>   thermal: exynos: Move exynos_thermal.h from include/* to driver/=
*
>>>>>>     folder
>>>>>>   thermal: exynos: Bifurcate exynos tmu driver and configuration d=
ata
>>>>>>   thermal: exynos: Add missing definations and code cleanup
>>>>>>   thermal: exynos: Add extra entries in the tmu platform data
>>>>>>   thermal: exynos: Support thermal tripping
>>>>>>   thermal: exynos: Move register definitions from driver file to d=
ata
>>>>>>     file
>>>>>>   thermal: exynos: Fix to clear only the generated interrupts
>>>>>>   thermal: exynos: Add support for instance based register/unregis=
ter
>>>>>>   thermal: exynos: Modify private_data to appropriate name driver_=
data
>>>>>>   thermal: exynos: Return success even if no cooling data supplied=

>>>>>>   thermal: exynos: Make the zone handling dependent on trip count
>>>>>>   thermal: exynos: Add support to handle many instances of TMU
>>>>>>   thermal: exynos: Add TMU features to check instead of using SOC =
type
>>>>>>   thermal: exynos: use device resource management infrastructure
>>>>>>   thermal: exynos: Add support to access common register for
>>>>>>     multistance
>>>>>>   thermal: exynos: Add support for exynos5440 TMU sensor.
>>>>>>   thermal: exynos: Fix to set the second point correction value
>>>>>>     properly
>>>>>>   thermal: exynos: Add thermal configuration data for exynos5440 T=
MU
>>>>>>     sensor
>>>>>>   thermal: exynos: Add a compensation logic on swapped e-fuse valu=
es
>>>>>>   thermal: exynos: Add hardware mode thermal calibration support
>>>>>>   Documentation: thermal: Explain the exynos thermal driver model
>>>>>>   thermal: exynos: Support for TMU regulator defined at device tre=
e
>>>>>>   ARM: dts: Add device tree node for exynos5440 TMU controller
>>>>>>   arm: exynos: enable ARCH_HAS_TMU
>>>>>>
>>>>>> Lukasz Majewski (1):
>>>>>>   ARM: dts: thermal: exynos4: Add documentation for Exynos SoC the=
rmal
>>>>>>     bindings
>>>>>>
>>>>>>  .../devicetree/bindings/thermal/exynos-thermal.txt |   53 +
>>>>>>  Documentation/thermal/exynos_thermal               |   43 +-
>>>>>>  arch/arm/boot/dts/exynos5440.dtsi                  |   30 +
>>>>>>  arch/arm/mach-exynos/Kconfig                       |    5 +
>>>>>>  drivers/thermal/Kconfig                            |   13 +-
>>>>>>  drivers/thermal/Makefile                           |    2 +-
>>>>>>  drivers/thermal/exynos_thermal.c                   | 1066 -------=
-------------
>>>>>>  drivers/thermal/samsung/Kconfig                    |   21 +
>>>>>>  drivers/thermal/samsung/Makefile                   |    7 +
>>>>>>  drivers/thermal/samsung/exynos_thermal_common.c    |  407 +++++++=
+
>>>>>>  drivers/thermal/samsung/exynos_thermal_common.h    |   98 ++
>>>>>>  drivers/thermal/samsung/exynos_tmu.c               |  741 +++++++=
+++++++
>>>>>>  drivers/thermal/samsung/exynos_tmu.h               |  294 ++++++
>>>>>>  drivers/thermal/samsung/exynos_tmu_data.c          |  225 ++++
>>>>>>  drivers/thermal/samsung/exynos_tmu_data.h          |  155 +++
>>>>>>  include/linux/platform_data/exynos_thermal.h       |  119 ---
>>>>>>  16 files changed, 2076 insertions(+), 1203 deletions(-)
>>>>>>  create mode 100644 Documentation/devicetree/bindings/thermal/exyn=
os-thermal.txt
>>>>>>  delete mode 100644 drivers/thermal/exynos_thermal.c
>>>>>>  create mode 100644 drivers/thermal/samsung/Kconfig
>>>>>>  create mode 100644 drivers/thermal/samsung/Makefile
>>>>>>  create mode 100644 drivers/thermal/samsung/exynos_thermal_common.=
c
>>>>>>  create mode 100644 drivers/thermal/samsung/exynos_thermal_common.=
h
>>>>>>  create mode 100644 drivers/thermal/samsung/exynos_tmu.c
>>>>>>  create mode 100644 drivers/thermal/samsung/exynos_tmu.h
>>>>>>  create mode 100644 drivers/thermal/samsung/exynos_tmu_data.c
>>>>>>  create mode 100644 drivers/thermal/samsung/exynos_tmu_data.h
>>>>>>  delete mode 100644 include/linux/platform_data/exynos_thermal.h
>>>>>>
>>>>>>
>>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>
>>>
>>
>>
>> --
>> You have got to be excited about what you are doing. (L. Lamport)
>>
>> Eduardo Valentin
>>
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2OGCIGRQIVPHNWAUODNTB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGwkzEACgkQCXcVR3XQvP0I/gEAjeEiXO8mtFb9Jn1RBdGQELlK
JFZSNRWqStJWUvSy2TYBALFGlRT9eUg6htjVTCEDKurq4+OMHQ2IWTXohOERkSmj
=lvXB
-----END PGP SIGNATURE-----

------enig2OGCIGRQIVPHNWAUODNTB--
