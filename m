Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbaDTBhM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 21:37:12 -0400
Received: from 7.mo4.mail-out.ovh.net ([178.33.253.54]:33144 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754793AbaDTBhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 21:37:06 -0400
X-Greylist: delayed 16798 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Apr 2014 21:37:06 EDT
MIME-Version: 1.0
In-Reply-To: <CAOCHtYjkUnWiGHG6v5Op-=3AxEW9sJ9xaSWkmu6Bg-6q23L2=g@mail.gmail.com>
References: <1397814309-32160-1-git-send-email-jjhiblot@traphandler.com>
	<1397814309-32160-4-git-send-email-jjhiblot@traphandler.com>
	<CAOCHtYjkUnWiGHG6v5Op-=3AxEW9sJ9xaSWkmu6Bg-6q23L2=g@mail.gmail.com>
Date: Sat, 19 Apr 2014 21:07:41 +0200
Message-ID: <CACh+v5MyeCkCz=8w-5iNRrgxRiOdPsQV5zExMiZmdFTYX9dJ3Q@mail.gmail.com>
Subject: Re: [RFC 3/3] atmel: dt: Add supports for the lcdc support on the sama5d36ek
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Robert Nelson <robertcnelson@gmail.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dri-devel@lists.freedesktop.org, airlied@linux.ie,
        Rob Clark <robdclark@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-Ovh-Tracer-Id: 14533115998480324632
X-Ovh-Remote: 209.85.223.176 (mail-ie0-f176.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrtdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrtdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-18 16:48 GMT+02:00 Robert Nelson <robertcnelson@gmail.com>:
>
> On Fri, Apr 18, 2014 at 4:45 AM, Jean-Jacques Hiblot
> <jjhiblot@traphandler.com> wrote:
>> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>> ---
>>  arch/arm/boot/dts/sama5d36ek.dts | 27 ++++++++++++++++++++++++++-
>>  1 file changed, 26 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/sama5d36ek.dts b/arch/arm/boot/dts/sama5d36ek.dts
>> index 59576c6..df01037 100644
>> --- a/arch/arm/boot/dts/sama5d36ek.dts
>> +++ b/arch/arm/boot/dts/sama5d36ek.dts
>> @@ -11,12 +11,17 @@
>>  #include "sama5d3xmb.dtsi"
>>  #include "sama5d3xdm.dtsi"
>>
>> +
>
> extra space
>
>>  / {
>>         model = "Atmel SAMA5D36-EK";
>>         compatible = "atmel,sama5d36ek", "atmel,sama5d3xmb", "atmel,sama5d3xcm", "atmel,sama5d36", "atmel,sama5d3", "atmel,sama5";
>>
>>         ahb {
>>                 apb {
>> +                       hlcdc: hlcdc@f0030000 {
>> +                               status = "okay";
>> +                       };
>> +
>>                         spi0: spi@f0004000 {
>>                                 status = "okay";
>>                         };
>> @@ -46,7 +51,27 @@
>>                         };
>>                 };
>>         };
>> -
>> +       panel {
>> +               compatible = "atmel,hlcdc,panel";
>> +               invert-hsync;
>> +               invert-vsync;
>> +               status = "okay";
>> +               display-timings {
>> +                       800x480p60 {
>> +                               clock-frequency = <33260000>;
>> +                               hactive = <800>;
>> +                               vactive = <480>;
>> +                               hfront-porch = <168>;
>> +                               hback-porch = <88>;
>> +                               hsync-len = <64>;
>> +                               vback-porch = <8>;
>> +                               vfront-porch = <37>;
>> +                               vsync-len = <2>;
>> +                               hsync-active = <1>;
>> +                               vsync-active = <1>;
>> +                       };
>> +               };
>> +       };
>>         sound {
>>                 status = "okay";
>>         };
>> --
>> 1.9.1
>
> Feel free to merge in this patch:
>
> https://github.com/RobertCNelson/armv7_devel/blob/v3.15.x-sama5-armv7/patches/drm/0005-atmel-dt-Add-supports-for-the-lcdc-support-on-the-sa.patch
>
Thanks for the patch.
> With this commit..
>
> All tested with sama5d31/33/34/36ek board's..

and many thanks for the testing.

>
> Regards,
>
> --
> Robert Nelson
> http://www.rcn-ee.com/
