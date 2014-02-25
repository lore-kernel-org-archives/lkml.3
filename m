Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaBYHja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:39:30 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37354 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBYHj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:39:28 -0500
Message-ID: <530C48A7.2070706@monstr.eu>
Date: Tue, 25 Feb 2014 08:39:19 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Alejandro Cabrera <acabrera@udio.cujae.edu.cu>,
        Guenter Roeck <linux@roeck-us.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 07/11] watchdog: xilinx: Use of_property_read_u32
References: <53094A15.1080708@udio.cujae.edu.cu> <53093038.6000604@roeck-us.net> <53097091.50204@udio.cujae.edu.cu> <530950A1.40302@roeck-us.net> <530991AA.9040201@udio.cujae.edu.cu> <53096E8D.50202@roeck-us.net> <530A20ED.3070505@udio.cujae.edu.cu> <530A0909.50101@roeck-us.net> <530A453E.4070608@udio.cujae.edu.cu> <530B085C.7090401@monstr.eu> <20140224192507.GO1484@spo001.leaseweb.com>
In-Reply-To: <20140224192507.GO1484@spo001.leaseweb.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="J6hmoWmb1isMCfldFxlXQsusB6cWtKFr1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J6hmoWmb1isMCfldFxlXQsusB6cWtKFr1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/24/2014 08:25 PM, Wim Van Sebroeck wrote:
> Hi Michal,
>=20
>> On 02/23/2014 08:00 PM, Alejandro Cabrera wrote:
>>> On 23/2/2014 6:43 AM, Guenter Roeck wrote:
>>>> On 02/23/2014 08:25 AM, Alejandro Cabrera wrote:
>>>>> On 22/2/2014 7:44 PM, Guenter Roeck wrote:
>>>>>> On 02/22/2014 10:14 PM, Alejandro Cabrera wrote:
>>>>>>> On 22/2/2014 5:36 PM, Guenter Roeck wrote:
>>>>>>>> On 02/22/2014 07:52 PM, Alejandro Cabrera wrote:
>>>>>>>>> On 22/2/2014 3:18 PM, Guenter Roeck wrote:
>>>>>>>>>> On 02/22/2014 05:08 PM, Alejandro Cabrera wrote:
>>>>>>>>>>> On 22/2/2014 10:46 AM, Wim Van Sebroeck wrote:
>>>>>>>>>>>> Hi All,
>>>>>>>>>>>>
>>>>>>>>>>>>> Hi Michal,
>>>>>>>>>>>>>
>>>>>>>>>>>>> On Wed, Feb 12, 2014 at 02:41:21PM +0100, Michal Simek wrot=
e:
>>>>>>>>>>>>>> Use of_property_read_u32 functions to clean probe function=
=2E
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Signed-off-by: Michal Simek<michal.simek@xilinx.com>
>>>>>>>>>>>>>> Reviewed-by: Guenter Roeck<linux@roeck-us.net>
>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Changes in v3:
>>>>>>>>>>>>>> - Remove one if checking and use variable directly
>>>>>>>>>>>>>>
>>>>>>>>>>>>> Looks good.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Another comment/remark.
>>>>>>>>>>>>>
>>>>>>>>>>>>>> -    pfreq =3D (u32 *)of_get_property(pdev->dev.of_node,
>>>>>>>>>>>>>> -                    "clock-frequency", NULL);
>>>>>>>>>>>>>> -
>>>>>>>>>>>>>> -    if (pfreq =3D=3D NULL) {
>>>>>>>>>>>>>> +    rc =3D of_property_read_u32(pdev->dev.of_node, "clock=
-frequency",&pfreq);
>>>>>>>>>>>>>> +    if (rc) {
>>>>>>>>>>>>>>           dev_warn(&pdev->dev,
>>>>>>>>>>>>>>                "The watchdog clock frequency cannot be obt=
ained\n");
>>>>>>>>>>>>>>           no_timeout =3D true;
>>>>>>>>>>>>>>       }
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> -    tmptr =3D (u32 *)of_get_property(pdev->dev.of_node,
>>>>>>>>>>>>>> -                    "xlnx,wdt-interval", NULL);
>>>>>>>>>>>>>> -    if (tmptr =3D=3D NULL) {
>>>>>>>>>>>>>> +    rc =3D of_property_read_u32(pdev->dev.of_node, "xlnx,=
wdt-interval",
>>>>>>>>>>>>>> + &xdev->wdt_interval);
>>>>>>>>>>>>>> +    if (rc) {
>>>>>>>>>>>>>>           dev_warn(&pdev->dev,
>>>>>>>>>>>>>>                "Parameter \"xlnx,wdt-interval\" not found\=
n");
>>>>>>>>>>>>>>           no_timeout =3D true;
>>>>>>>>>>>>>> -    } else {
>>>>>>>>>>>>>> -        xdev->wdt_interval =3D *tmptr;
>>>>>>>>>>>>>>       }
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> -    tmptr =3D (u32 *)of_get_property(pdev->dev.of_node,
>>>>>>>>>>>>>> -                    "xlnx,wdt-enable-once", NULL);
>>>>>>>>>>>>>> -    if (tmptr =3D=3D NULL) {
>>>>>>>>>>>>>> +    rc =3D of_property_read_u32(pdev->dev.of_node, "xlnx,=
wdt-enable-once",
>>>>>>>>>>>>>> + &enable_once);
>>>>>>>>>>>>>> +    if (rc)
>>>>>>>>>>>>>>           dev_warn(&pdev->dev,
>>>>>>>>>>>>>>                "Parameter \"xlnx,wdt-enable-once\" not fou=
nd\n");
>>>>>>>>>>>>>> -        watchdog_set_nowayout(xilinx_wdt_wdd, true);
>>>>>>>>>>>>>> -    }
>>>>>>>>>>>>> All the above properties are optional. Is a warning really
>>>>>>>>>>>>> warranted in this case ? I usually associate a warning with=

>>>>>>>>>>>>> something that is wrong, which is not the case here.
>>>>>>>>>>>>>
>>>>>>>>>>>>> I would encourage you to drop those warnings, but that shou=
ld be
>>>>>>>>>>>>> a separate patch.
>>>>>>>>>>>> I agree with Guenter: these are not really warnings. Seperat=
e patch is thus welcome.
>>>>>>>>>>> Hi
>>>>>>>>>>>
>>>>>>>>>>> I support Michal intention, I think it is a warning because d=
evice tree blob must have the "xlnx,wdt-enable-once" property specified i=
n order to allow the system to be sure of the real value of this property=
=2E In addition to, this warning can be helpful to detect a wrong device =
tree specification.
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> The dt documentation states that the properties are optional.
>>>>>>>>>>
>>>>>>>>>> Optional properties:
>>>>>>>>>> - clock-frequency       : Frequency of clock in Hz
>>>>>>>>>> - xlnx,wdt-enable-once  : 0 - Watchdog can be restarted
>>>>>>>>>>                           1 - Watchdog can be enabled just onc=
e
>>>>>>>>>> - xlnx,wdt-interval     : Watchdog timeout interval in 2^<val>=
 clock cycles,
>>>>>>>>>> <val> is integer from 8 to 31.
>>>>>>>>>>
>>>>>>>>>> This clearly conflicts with your statement. An optional proper=
ty
>>>>>>>>>> is just that, optional. If it warrants a warning, it must
>>>>>>>>>> not be optional. If you claim that not providing the propertie=
s
>>>>>>>>>> would be "wrong", why are they defined as optional ?
>>>>>>>>> Hi Guenter
>>>>>>>>>
>>>>>>>>> I didn't know that these properties was classified as optional.=
=2E.
>>>>>>>>> I think that they should not be, because all xilinx watchog dev=
ices (at least for microblaze processor)
>>>>>>>>> have these properties defined in theirs MPD files and theirs va=
lues can be obtained during the
>>>>>>>>> hardware specification to device tree conversion.
>>>>>>>>>> What is your definition of "wrong" and "must have" ?
>>>>>>>>> what I mean for "must have" is: if these properties can be obta=
ined
>>>>>>>>> for all xilinx watchdog devices they must be present in the dev=
ice tree because they allows
>>>>>>>>> the system (linux/user) to know exactly how a watchdog device i=
s configured.
>>>>>>>>> Because these properties always can be obtained from hardware d=
esign there is no
>>>>>>>>> reason to leave them out from the device tree. This is why I co=
nsider that a device tree without
>>>>>>>>> these properties should be considered as "wrong" device tree.
>>>>>>>>>> How do you expect anyone to know that omitting those
>>>>>>>>>> "optional" properties is by some definition "wrong" ?
>>>>>>>>> I'm agree with you.
>>>>>>>>> Maybe these properties shouldn't be optional.
>>>>>>>>> For example suppose that "xlnx,wdt-enable-once" is missing in t=
he device tree,
>>>>>>>>> when a watchdog daemon ask for this property what is the obtain=
ed value ?
>>>>>>>>> Independently of this value, why do not warn the user about thi=
s missing property
>>>>>>>>> when it can always be in the device tree ?
>>>>>>>>>
>>>>>>>>
>>>>>>>> Really, this line of argument doesn't make any sense to me.
>>>>>>>> "xlnx,wdt-enable-once", for example, is a boolean and means
>>>>>>>> that the watchdog, when enabled, can not be stopped. It defaults=

>>>>>>>> to false, and thus is inherently optional. Making it mandatory
>>>>>>>> doesn't really add any value.
>>>>>>>>
>>>>>>>
>>>>>>> If the device has been configured with wdt-enable-once=3Dtrue
>>>>>>> and the device tree doesn't have this property then a watchdog da=
emon
>>>>>>> would see it as "false" because it is the default making the syst=
em to misbehave...
>>>>>>> A warning during driver loading could help user to identify the p=
roblem.
>>>>>>>
>>>>>>
>>>>>> All this would give you is a false sense of safety. The property c=
ould
>>>>>> just as well be there and be wrong (eg be configured as =3D <0> wh=
en it
>>>>>> should be 1, or with a wrong frequency.
>>>>> These issues "cannot" be detected but the missing properties yes.
>>>>>> Following your logic, every driver
>>>>>> would need to warn about everything, just to be sure.
>>>>> Every driver should warn about anything that it considers weird and=
 let the user to decide if it matters or not.
>>>>> I think that an example of weird could be the lack of an expected p=
roperty.
>>>>>
>>>>
>>>> I don't think it makes sense to continue this discussion.
>>>> We have fundamental differences in opinion which we won't
>>>> resolve by repeating our arguments over and over.
>>>>
>>>> Wim, I'll let you decide how to handle this. My recommendation
>>>> is to request the author to decide if the properties are optional
>>>> or not before accepting this patch set. Either the properties
>>>> are optional, and there should be no warnings, or they are
>>>> mandatory and the driver should bail out if they are missing.
>>>>
>>> I'm totally agreed with you :)
>>>
>>
>> You have reached to completely different discussion.
>> We should talk just about the code I have sent.
>> I have checked what I have done and the intention was just to have bet=
ter driver.
>> I even didn't change any logic about DT and probe. DT binding just des=
cribes
>> what it is written in the driver, nothing more nothing else.
>>
>> Please keep this in your mind.
>>
>> The driver with this binding is in the kernel for a while and if bindi=
ng is wrong
>> let's change it but it should be in separate patch which can fix bindi=
ng
>> warn/error messages.
>>
>> Wim: If you agree, I have no problem to send this follow up patch
>> which can be applied on the top of this series.
>> We can make xlnx,wdt-enable-once and xlnx,wdt-interval as required pro=
perties
>> and clock-frequence can go away and we can use CCF.
>=20
> As said: a follow up patch would be welcome. So yes I agree.
> And I also think that the discussion was interesting because it pointed=
 out that
 a review of the bindings could also be usefull (what is required versus =
what os optional).

Definitely it is not the first time where binding doc is useful.
Also from binding we can see which features are common for all
drivers in the same kind.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--J6hmoWmb1isMCfldFxlXQsusB6cWtKFr1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMMSKcACgkQykllyylKDCGjeACfd6zRAV85RzhOY4l64OMJQ/yy
aKgAmgIrRqWNJhRkDJHTvqfmVnLbldne
=9E6O
-----END PGP SIGNATURE-----

--J6hmoWmb1isMCfldFxlXQsusB6cWtKFr1--
