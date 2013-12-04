Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab3LDOMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:12:46 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37168 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416Ab3LDOMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:12:43 -0500
Message-ID: <529F384A.8040409@ti.com>
Date: Wed, 4 Dec 2013 10:12:26 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lukasz Majewski <l.majewski@samsung.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, <durgadoss.r@intel.com>,
        <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH RESEND v10 0/7] cpufreq:boost: CPU Boost mode support
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <1385986761-17934-1-git-send-email-l.majewski@samsung.com> <20131204075921.3b9e86fa@amdc2363>
In-Reply-To: <20131204075921.3b9e86fa@amdc2363>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="a8FjB1E02ahqIw3gP9kPoIoXEuA9UErAw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--a8FjB1E02ahqIw3gP9kPoIoXEuA9UErAw
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04-12-2013 02:59, Lukasz Majewski wrote:
> Hi Rafael,
>=20
>> This patch series introduces support for CPU overclocking technique
>> called Boost.
>>
>> It is a follow up of a LAB governor proposal. Boost is a LAB
>> component:
>> http://thread.gmane.org/gmane.linux.kernel/1484746/match=3Dcpufreq
>>
>> Boost unifies hardware based solution (e.g. Intel Nehalem) with
>> software oriented one (like the one done at Exynos).
>> For this reason cpufreq/freq_table code has been reorganized to
>> include common code.
>>
>> Important design decisions:
>> - Boost related code is compiled-in unconditionally to cpufreq core
>> and disabled by default. The cpufreq_driver is responsibile for
>> setting boost_supported flag and providing set_boost callback(if HW
>> support is needed). For software managed boost, special Kconfig flag -=

>>   CONFIG_CPU_FREQ_BOOST_SW has been defined. It will be selected only
>>   when a target platform has thermal framework properly configured.
>>
>> - struct cpufreq_driver has been extended with boost related fields:
>>         -- boost_supported - when driver supports boosting
>>         -- boost_enabled - boost state
>>         -- set_boost - callback to function, which is necessary to
>>            enable/disable boost
>>
>> - Boost sysfs attribute (/sys/devices/system/cpu/cpufreq/boost) is
>> visible _only_ when cpufreq driver supports Boost.
>>
>> - No special spin_lock for Boost was created. The one from cpufreq
>> core was reused.
>>
>> - The Boost code doesn't rely on any policy. When boost state is
>> changed, then the policy list is iterated and proper adjustements are
>> done.
>>
>> - To improve safety level, the thermal framework is also extended to
>> disable software boosting, when thermal trip point is reached. After
>> cooling down the boost can be enabled again. This emulates behaviour
>> similar to HW managed boost (like x86)
>>
>> Tested at HW:
>>        Exynos 4412 3.13-rc2 Linux
>>        Intel Core i7-3770 3.13-rc2 Linux
>>
>> Above patches were posted on top of kernel_pm/bleeding-edge
>> (SHA1: 9483a9f69d5c8f83f1723361bf8340ddfb6475b4)
>>
>=20
> Rafael, could you pull patches from 1 to 6 of this series? Those are
> related to cpufreq core and has already been accepted by Viresh at a
> late August this year.
> This would facilitate my further cpufreq work.
>=20
> And about the last patch - related to thermal. It seems that more
> discussion NOT related to cpufreq will be ongoing.=20
>=20
> I would prefer to add it as a separate patch to thermal subtree.

I agree with Lukasz here. The part that touches the thermal driver is
minimal and the discussion is a simple matter of concept and
optimization of data structures.

>=20
>=20
>=20
>>
>> Lukasz Majewski (7):
>>   cpufreq: Add boost frequency support in core
>>   cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work with common=

>>     boost solution
>>   cpufreq:boost:Kconfig: Provide support for software managed BOOST
>>   cpufreq:exynos:Extend Exynos cpufreq driver to support boost
>>     framework
>>   Documentation:cpufreq:boost: Update BOOST documentation
>>   cpufreq:exynos4x12: Change L0 driver data to CPUFREQ_BOOST_FREQ
>>   thermal:exynos:boost: Automatic enable/disable of BOOST feature (at
>>     Exynos4412)
>>
>>  Documentation/cpu-freq/boost.txt          |   26 +++----
>>  drivers/cpufreq/Kconfig                   |    4 +
>>  drivers/cpufreq/Kconfig.arm               |   15 ++++
>>  drivers/cpufreq/acpi-cpufreq.c            |   86
>> +++++++-------------- drivers/cpufreq/cpufreq.c                 |
>> 118 ++++++++++++++++++++++++++++-
>> drivers/cpufreq/exynos-cpufreq.c          |    3 +
>> drivers/cpufreq/exynos4x12-cpufreq.c      |    2 +-
>> drivers/cpufreq/freq_table.c              |   56 ++++++++++++--
>> drivers/thermal/samsung/exynos_tmu_data.c |   47 ++++++++++++
>> include/linux/cpufreq.h                   |   24 ++++++ 10 files
>> changed, 302 insertions(+), 79 deletions(-)
>>
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--a8FjB1E02ahqIw3gP9kPoIoXEuA9UErAw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKfOEoACgkQCXcVR3XQvP3RMAEAuPIso2ItwVZOSfv0l7vRdgOG
yI/GO8HMGPYMLMn/MdYA/iNzYmVu0+tPpJPk3RKpX6KktZ5EL9zR5zw+kiI4uANc
=w/sJ
-----END PGP SIGNATURE-----

--a8FjB1E02ahqIw3gP9kPoIoXEuA9UErAw--
