Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaG3LFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 07:05:11 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.147]:36493 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbaG3LFH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 07:05:07 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-7.tower-178.messagelabs.com!1406718302!40858749!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Simon Horman <horms@verge.net.au>,
        "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
CC: Lee Jones <lee.jones@linaro.org>, DEVICE TREE <devicetree@vger.kernel.org>,
        Support Opensource <Support.Opensource@diasemi.com>,
        LINUX SH <linux-sh@vger.kernel.org>,
        "LINUX KERNEL" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        LINUX ARM KERNEL <linux-arm-kernel@lists.infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: RE: [RESEND RFC V2] devicetree: Dialog Semiconductor consolidate
 existing vendor prefixes to standardise on 'dlg'
Thread-Topic: [RESEND RFC V2] devicetree: Dialog Semiconductor consolidate
 existing vendor prefixes to standardise on 'dlg'
Thread-Index: AQHPp1egR+JNVEE720Co5YFMnHyEKZuwTKkAgAT3x2CAApqBgIAAnjtg
Date: Wed, 30 Jul 2014 11:05:01 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7D0B2910C@SW-EX-MBX02.diasemi.com>
References: <201407241554.s6OFsqbW031651@swsrvapps-01.diasemi.com>
 <20140725070002.GH7063@lee--X1>
 <6ED8E3B22081A4459DAC7699F3695FB7D0B28E95@SW-EX-MBX02.diasemi.com>
 <20140730023725.GA23224@verge.net.au>
In-Reply-To: <20140730023725.GA23224@verge.net.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.61]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 30 July 2014 03:37 Simon Horman wrote:
>On Mon, Jul 28, 2014 at 09:53:56AM +0000, Opensource [Steve Twiss] wrote:
>> On 25 July 2014 08:00, Lee Jones wrote:
>>
>> >On Thu, 24 Jul 2014, Opensource [Steve Twiss] wrote:
>> >> From: Steve Twiss <stwiss.opensource@diasemi.com>
>> >>
>> >> This patch series updates the device tree vendor prefix for
>> >> Dialog Semiconductor.
>> >>
>> >> Various methods are currently used throughout the kernel: 'diasemi',
>> >> 'dialog' and 'dlg'. Others have also been suggested.
>> >>
>> >> This patch set aims to consolidate the usage of the vendor prefix to
>> >> use a common standard. The prefix 'dlg' is used.
>> >>
>> >>
>> >> Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
>> >
>> >Didn't I Ack the MFD parts already?
>> >
>>
>> Yes -- certainly.
>>  (I should have put them in the main body of the e-mail shouldn't I ..?)
>>
>> I just need the SHMobile responses now.
>> I will try to make contact with those guys this week.
>
>Hi Steve,
>
>I apologise for not noticing this earlier:
>I am entirely unsure how I missed it.

Hi Simon,

Thank you for responding to this. No problem.

>
>In principle I am fine with this change so long as it does not
>introduce any backwards-compatibility problems. In particular removing
>compatibility strings that may already be in use by DTB blobs in the wild.
>
>For SH Mobile it seems that Lager and Koelsch were using "diasemi,da9210"
>which is unsupported by the driver at this time. So it seems there is no
>backwards-compatibility problem there. I'm less sure about other aspects of
>the patch. And I'm also less concerned about them.
>
>I do have a slight preference for SH Mobile changes to go through my
>renesas tree rather than elsewhere (as part of a more global change)
>principally to try to avoid the possibility of conflicts. The SH Mobile dts
>files in question are often updated. And for example I notice some fuzz
>when applying this patch on top of the next-20140729 tag of linux-next.

I have applied the patch to linux-next/next-20140729 and the patch
program does throw some warnings,

patching file arch/arm/boot/dts/r8a7790-lager.dts
Hunk #1 succeeded at 378 (offset 4 lines).
patching file arch/arm/boot/dts/r8a7791-koelsch.dts
Hunk #1 succeeded at 430 (offset 4 lines).

But when I checked the output, the patch was applied correctly.
They are one-line changes in both cases:

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index 7853c2c..becaaab 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -378,7 +378,7 @@
        status = "okay";
 
        vdd_dvfs: regulator@68 {
-               compatible = "diasemi,da9210";
+               compatible = "dlg,da9210";
                reg = <0x68>;
 
                regulator-min-microvolt = <1000000>;
diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
index 8f36d4f..684fc44 100644
--- a/arch/arm/boot/dts/r8a7791-koelsch.dts
+++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
@@ -430,7 +430,7 @@
        clock-frequency = <100000>;
 
        vdd_dvfs: regulator@68 {
-               compatible = "diasemi,da9210";
+               compatible = "dlg,da9210";
                reg = <0x68>;
 
                regulator-min-microvolt = <1000000>;


>
>If you were to break out the SH Mobile portion of this patch I would be
>happy to take it once the driver portion is accepted.  That said, I do see
>that everyone else has acked the change so clearly this is not an issue
>from their point of view. So I will not complain if you decide not to break
>the patch up (though please note my warning about possible conflicts).

I have been trying to get Acked-by: tags for a while now, and it has taken a
fair amount of time to get everybody's responses. For that reason and
because the patch managed to be applied cleanly to next-20140729 (despite
4 line offsets) I would like to resend this patch with your Acked-by: applied
instead of splitting up the patch into several sections and then touting
for new Acked-by: all over again.

I realise that your DTS files are updated constantly -- I do hope this will
not cause any problems with the merge.

>
>In the case where you do not want to split up the patch:
>Acked-by: Simon Horman <horms+renesas@verge.net.au>

Thank you.
Regards,
Steve.

