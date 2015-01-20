Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbbATR3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:29:40 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:45019 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbbATR3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:29:37 -0500
MIME-Version: 1.0
In-Reply-To: <54BE7DAB.80702@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-4-git-send-email-j.anaszewski@samsung.com>
 <CAL_JsqJKEp6TWaRhJimg3AWBh+MCCr2Bk9+1o7orLLdp5E+n-g@mail.gmail.com>
 <54B38682.5080605@samsung.com> <CAL_Jsq+UaA41DvawdOMmOib=Fi0hC-nBdKV-+P4DFo+MoOy-bQ@mail.gmail.com>
 <54B3F1EF.4060506@samsung.com> <CAL_JsqKpJtUG0G6g1GOuSVpc31oe-dp3qdrKJUE0upG-xRDFhA@mail.gmail.com>
 <54B4DA81.7060900@samsung.com> <CAL_JsqLYxB5hzLAWXpU=uncM5DEMZU78mP673H9oSSNB-cgcYQ@mail.gmail.com>
 <54B8D4D0.3000904@samsung.com> <CAL_Jsq+EFWzs1HP1tVt6P=p=HZn2AtSPjp55YrmMQi_mE+kNfQ@mail.gmail.com>
 <54B933D0.1090004@samsung.com> <54BE7DAB.80702@samsung.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 20 Jan 2015 11:29:16 -0600
Message-ID: <CAL_JsqKoiaUmVhbQdnNveG=AAYh4-OHGS70L+LAgLLoKChUuYQ@mail.gmail.com>
Subject: Re: [PATCH/RFC v10 03/19] DT: leds: Add led-sources property
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pavel Machek <pavel@ucw.cz>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, sakari.ailus@iki.fi,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:09 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> On 01/16/2015 04:52 PM, Jacek Anaszewski wrote:
>>
>> On 01/16/2015 02:48 PM, Rob Herring wrote:

[...]

>>> You may want to add something like led-output-cnt or led-driver-cnt in
>>> the parent so you know the max list size.
>>
>>
>> Why should we need this? The number of current outputs exposed by the
>> device is fixed and can be specified in a LED device bindings
>> documentation.
>>
>
> OK. The led-output-cnt property should be put in each sub-node, as the
> number of the current outputs each LED can be connected to is variable.

Sorry, I meant this for the parent node meaning how many outputs the
driver IC has. I did say maybe because you may always know this. It
can make it easier to allocate memory for led-sources knowing the max
size up front.

Rob

>
> New version:
>
>  Optional properties for child nodes:
> +led-sources-cnt : Number of device current outputs the LED is connected to.
> +- led-sources : List of device current outputs the LED is connected to. The
> +               outputs are identified by the numbers that must be defined
> +               in the LED device binding documentation.
>  - label : The label for this LED.  If omitted, the label is
>    taken from the node name (excluding the unit address).
>
> @@ -33,7 +47,9 @@ system-status {
>
>  camera-flash {
>         label = "Flash";
> +       led-sources-cnt = <2>;
> +       led-sources = <0>, <1>;
>         max-microamp = <50000>;
>         flash-max-microamp = <320000>;
>         flash-timeout-us = <500000>;
> -}
> +};
>
>
> --
> Best Regards,
> Jacek Anaszewski
