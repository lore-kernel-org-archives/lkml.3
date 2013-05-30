Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab3E3PMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:12:43 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43909 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933539Ab3E3PM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:12:28 -0400
Message-ID: <51A76C58.5060107@monstr.eu>
Date: Thu, 30 May 2013 17:12:24 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 3/3] watchdog: xilinx: Add WDIOC_SETTIMEOUT ioctl function
References: <b565740967bfa3b3fa867442634f524000c097f8.1369916757.git.michal.simek@xilinx.com> <595eb49b34909318959fe6825c209a7d635ed849.1369916757.git.michal.simek@xilinx.com> <20130530140754.GB28232@roeck-us.net> <51A75F11.7000001@monstr.eu> <20130530142145.GA28856@roeck-us.net> <51A7635A.8070300@monstr.eu> <20130530150306.GA29508@roeck-us.net>
In-Reply-To: <20130530150306.GA29508@roeck-us.net>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2GNURDKGGAGMJGIEELXTC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2GNURDKGGAGMJGIEELXTC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/30/2013 05:03 PM, Guenter Roeck wrote:
> On Thu, May 30, 2013 at 04:34:02PM +0200, Michal Simek wrote:
>> On 05/30/2013 04:21 PM, Guenter Roeck wrote:
>>> On Thu, May 30, 2013 at 04:15:45PM +0200, Michal Simek wrote:
>>>> On 05/30/2013 04:07 PM, Guenter Roeck wrote:
>>>>> On Thu, May 30, 2013 at 02:26:04PM +0200, Michal Simek wrote:
>>>>>> Standard watchdog programs try to setup timeout
>>>>>> via ioctl and this functionality should be implemented.
>>>>>> Timeout value is hardcoded in the hardware but
>>>>>> based on Documentation/watchdog/watchdog-api.txt
>>>>>> can return the real timeout used in the same variable.
>>>>>>
>>>>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>>>>>> ---
>>>>>>  drivers/watchdog/of_xilinx_wdt.c | 1 +
>>>>>>  1 file changed, 1 insertion(+)
>>>>>>
>>>>>> diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/o=
f_xilinx_wdt.c
>>>>>> index 79f358c..a3bbe72 100644
>>>>>> --- a/drivers/watchdog/of_xilinx_wdt.c
>>>>>> +++ b/drivers/watchdog/of_xilinx_wdt.c
>>>>>> @@ -253,6 +253,7 @@ static long xwdt_ioctl(struct file *file, unsi=
gned int cmd, unsigned long arg)
>>>>>>  		xwdt_keepalive();
>>>>>>  		return 0;
>>>>>>
>>>>>> +	case WDIOC_SETTIMEOUT:
>>>>>>  	case WDIOC_GETTIMEOUT:
>>>>>>  		if (no_timeout)
>>>>>>  			return -ENOTTY;
>>>>>
>>>>> Watchdog programs should check ident.options before trying to set t=
he timeout.
>>>>> If they don't, there is an application bug. I don't think it is a g=
ood idea
>>>>> to start hacking the kernel to work around application bugs.
>>>>
>>>> Based on Documentation/watchdog/watchdog-api.txt
>>>>
>>>> "For some drivers it is possible to modify the watchdog timeout on t=
he
>>>> fly with the SETTIMEOUT ioctl, those drivers have the WDIOF_SETTIMEO=
UT
>>>> flag set in their option field.  The argument is an integer
>>>
>>> Yes, but WDIOF_SETTIMEOUT is not set in the driver's option field.
>>
>> ok. It means I should probably enable it.
>>
> I am missing your point. Applications should not try to write the timeo=
ut
> since WDIOF_SETTIMEOUT is not set. Any application doing it anyway is b=
uggy
> and should be fixed.

I fully understand your points and 100% agree with you
1. the application is broken and should be fixed
2. also the kernel shouldn't fix any problem with stupid application

But based on documentation the driver can support setup timeout
and based on description "the driver returns the real timeout used
in the same variable and this timeout might differ from the requested one=

due to limitation of the hardware"
Based on this I still think that the driver can support set timeout
feature and if the driver supports this option then WDIOF_SETTIMEOUT
should be set in driver's option field. And I would add this to v2.

Can you see my point now?
Or my point of view is completely incorrect that this driver can't
support set timeout option.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2GNURDKGGAGMJGIEELXTC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGnbFgACgkQykllyylKDCG4FgCfWTPcIxp2cFzTa7bOTR4pv42I
vMkAn34kNRA8xn0+ngUjwnIQsXLlkXRP
=gIAs
-----END PGP SIGNATURE-----

------enig2GNURDKGGAGMJGIEELXTC--
