Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962Ab3EaFsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 01:48:40 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:62903 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3EaFsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 01:48:31 -0400
Message-ID: <51A839AC.4040904@monstr.eu>
Date: Fri, 31 May 2013 07:48:28 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Guenter Roeck <linux@roeck-us.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 3/3] watchdog: xilinx: Add WDIOC_SETTIMEOUT ioctl function
References: <b565740967bfa3b3fa867442634f524000c097f8.1369916757.git.michal.simek@xilinx.com> <595eb49b34909318959fe6825c209a7d635ed849.1369916757.git.michal.simek@xilinx.com> <20130530140754.GB28232@roeck-us.net> <51A75F11.7000001@monstr.eu> <20130530142145.GA28856@roeck-us.net> <51A7635A.8070300@monstr.eu> <20130530150306.GA29508@roeck-us.net> <51A76C58.5060107@monstr.eu> <20130530152545.GA29874@roeck-us.net> <CAHTX3dJ9fDJ6ggMGcF5v1vdcruMqnV4fv_6eP3U3DgOUfm8r+w@mail.gmail.com> <20130530220812.GN14258@spo001.leaseweb.com>
In-Reply-To: <20130530220812.GN14258@spo001.leaseweb.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2RDWBIDEFNDWHNAKLJHBX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2RDWBIDEFNDWHNAKLJHBX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/31/2013 12:08 AM, Wim Van Sebroeck wrote:
> Hi All,
>=20
>>> On Thu, May 30, 2013 at 05:12:24PM +0200, Michal Simek wrote:
>>>> On 05/30/2013 05:03 PM, Guenter Roeck wrote:
>>>>> On Thu, May 30, 2013 at 04:34:02PM +0200, Michal Simek wrote:
>>>>>> On 05/30/2013 04:21 PM, Guenter Roeck wrote:
>>>>>>> On Thu, May 30, 2013 at 04:15:45PM +0200, Michal Simek wrote:
>>>>>>>> On 05/30/2013 04:07 PM, Guenter Roeck wrote:
>>>>>>>>> On Thu, May 30, 2013 at 02:26:04PM +0200, Michal Simek wrote:
>>>>>>>>>> Standard watchdog programs try to setup timeout
>>>>>>>>>> via ioctl and this functionality should be implemented.
>>>>>>>>>> Timeout value is hardcoded in the hardware but
>>>>>>>>>> based on Documentation/watchdog/watchdog-api.txt
>>>>>>>>>> can return the real timeout used in the same variable.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>>>>>>>>>> ---
>>>>>>>>>>  drivers/watchdog/of_xilinx_wdt.c | 1 +
>>>>>>>>>>  1 file changed, 1 insertion(+)
>>>>>>>>>>
>>>>>>>>>> diff --git a/drivers/watchdog/of_xilinx_wdt.c
>>> b/drivers/watchdog/of_xilinx_wdt.c
>>>>>>>>>> index 79f358c..a3bbe72 100644
>>>>>>>>>> --- a/drivers/watchdog/of_xilinx_wdt.c
>>>>>>>>>> +++ b/drivers/watchdog/of_xilinx_wdt.c
>>>>>>>>>> @@ -253,6 +253,7 @@ static long xwdt_ioctl(struct file *file,
>>> unsigned int cmd, unsigned long arg)
>>>>>>>>>>                xwdt_keepalive();
>>>>>>>>>>                return 0;
>>>>>>>>>>
>>>>>>>>>> +      case WDIOC_SETTIMEOUT:
>>>>>>>>>>        case WDIOC_GETTIMEOUT:
>>>>>>>>>>                if (no_timeout)
>>>>>>>>>>                        return -ENOTTY;
>>>>>>>>>
>>>>>>>>> Watchdog programs should check ident.options before trying to s=
et
>>> the timeout.
>>>>>>>>> If they don't, there is an application bug. I don't think it is=
 a
>>> good idea
>>>>>>>>> to start hacking the kernel to work around application bugs.
>>>>>>>>
>>>>>>>> Based on Documentation/watchdog/watchdog-api.txt
>>>>>>>>
>>>>>>>> "For some drivers it is possible to modify the watchdog timeout =
on
>>> the
>>>>>>>> fly with the SETTIMEOUT ioctl, those drivers have the
>>> WDIOF_SETTIMEOUT
>>>>>>>> flag set in their option field.  The argument is an integer
>>>>>>>
>>>>>>> Yes, but WDIOF_SETTIMEOUT is not set in the driver's option field=
=2E
>>>>>>
>>>>>> ok. It means I should probably enable it.
>>>>>>
>>>>> I am missing your point. Applications should not try to write the
>>> timeout
>>>>> since WDIOF_SETTIMEOUT is not set. Any application doing it anyway =
is
>>> buggy
>>>>> and should be fixed.
>>>>
>>>> I fully understand your points and 100% agree with you
>>>> 1. the application is broken and should be fixed
>>>> 2. also the kernel shouldn't fix any problem with stupid application=

>>>>
>>>> But based on documentation the driver can support setup timeout
>>>> and based on description "the driver returns the real timeout used
>>>> in the same variable and this timeout might differ from the requeste=
d one
>>>> due to limitation of the hardware"
>>>> Based on this I still think that the driver can support set timeout
>>>> feature and if the driver supports this option then WDIOF_SETTIMEOUT=

>>>> should be set in driver's option field. And I would add this to v2.
>>>>
>>>> Can you see my point now?
>>>
>>> No. The driver doesn't support setting the timeout. You just want it
>>> to falsely claim that it does to work around an application problem.
>>> With your logic, _every_ watchdog driver would "support" setting
>>> the timeout.
>>>
>>
>> I don't want to falsely claim anything.
>> I am just saying this is written in the documentation and
>> it is my understanding that this can be implemented it this way
>> for this xilinx device and behaviour of the driver will be correct
>> according to documentation which I copied to this thread.
>>
>> If Wim says that if device doesn't support setting timeout in HW
>> then this ioctl can't be implemented in this way I am definitely OK wi=
th
>> it.
>> And I will remove this patch and will also remove this change
>> from our xilinx repo.
>> The main purpose for me is to cleanup our repo and push all changes
>> to the mainline. Of course if this change goes against watchdog
>> logic and it is broken I will the first who will revert it in our repo=

>> and will have proper description based on our discussion.
>>
>> I really appreciate your inputs for this discussion and both
>> resolution ACK/NACK are OK because I will know what's the correct
>> way and I can fix it in mainline or our repo and both will be in sync.=

>=20
> Logic is: if device supports setting timeout values, then and only then=

> you indicate this by setting the WDIOF_SETTIMEOUT flag and adding the c=
ode
> for it. And then you can do minor adjustments if needed and report this=
 back.
> But that's only to make sure that some roundings (like a timer in minut=
es=20
> gives back 60 or 120 seconds if you would set a new timeout of 70 secon=
ds).
>=20
> So in this case: the HW doesn't support setting timeout values,
> so we don't add the WDIOF_SETTIMEOUT flag and thus we don't add the ioc=
tl
> call neither. So NACK on this patch.

ok. Good. I will revert this change in our tree and will send v2 without
it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2RDWBIDEFNDWHNAKLJHBX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGoOawACgkQykllyylKDCE/AQCeK8Sm1EdyDpfs6210diDfrusI
7NUAn0C+Z1zumKkuDBJqZmIRPjJ0USkt
=4r5v
-----END PGP SIGNATURE-----

------enig2RDWBIDEFNDWHNAKLJHBX--
