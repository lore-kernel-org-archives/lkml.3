Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab3HZMOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:14:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49921 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3HZMOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:14:53 -0400
Message-ID: <521B4666.3050509@ti.com>
Date: Mon, 26 Aug 2013 08:13:26 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Guenter Roeck <linux@roeck-us.net>, Zhang Rui <rui.zhang@intel.com>,
        <wni@nvidia.com>, "R, Durgadoss" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC PATCH 01/14] cpufreq: cpufreq-cpu0: add dt node parsing
 for 'cooling-zones'
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com> <1377299755-5134-2-git-send-email-eduardo.valentin@ti.com> <CAKohpomuFWyH6ss4_L-0j9WyXtsZEygWrFLYXE6Oj_AD-DJUjA@mail.gmail.com>
In-Reply-To: <CAKohpomuFWyH6ss4_L-0j9WyXtsZEygWrFLYXE6Oj_AD-DJUjA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="ePhlHHvf9knPPA6FoBMTfiBehuXBtURD7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ePhlHHvf9knPPA6FoBMTfiBehuXBtURD7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 26-08-2013 00:42, Viresh Kumar wrote:
> On 24 August 2013 04:45, Eduardo Valentin <eduardo.valentin@ti.com> wro=
te:
>> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-=
cpu0.c
>> index ad1fde2..ede6487 100644
>> --- a/drivers/cpufreq/cpufreq-cpu0.c
>> +++ b/drivers/cpufreq/cpufreq-cpu0.c
>> @@ -20,6 +20,9 @@
>>  #include <linux/platform_device.h>
>>  #include <linux/regulator/consumer.h>
>>  #include <linux/slab.h>
>> +#include <linux/thermal.h>
>> +#include <linux/cpu_cooling.h>
>> +#include <linux/cpumask.h>
>=20
> In alphabetical order please..
>=20

OK.

>> @@ -268,6 +272,13 @@ static int cpu0_cpufreq_probe(struct platform_dev=
ice *pdev)
>>                 goto out_free_table;
>>         }
>>
>> +       /*
>> +        * For now, just loading the cooling device;
>> +        * thermal DT code takes care of matching them.
>> +        */
>> +       if (of_find_property(np, "cooling-zones", NULL))
>> +               cdev =3D cpufreq_cooling_register(cpu_present_mask);
>=20
> Should we check if it passed or failed? And if failed Atleast flag an
> appropriate message?
>=20

Yes, we need error checking code. I will add in next version. Thanks Kuma=
r.

>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--ePhlHHvf9knPPA6FoBMTfiBehuXBtURD7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlIbRm0ACgkQCXcVR3XQvP2ItQD9FMwdPTChGTJS8wyntuj0OUYy
w1BiN+rFVWkcVLtDTGEA/3Tp9oX3NNQ8QvOACJmCKPSxfLtd7xgT/kGOOJzWdjbf
=YWgD
-----END PGP SIGNATURE-----

--ePhlHHvf9knPPA6FoBMTfiBehuXBtURD7--
