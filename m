Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189Ab3B0Ogh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 09:36:37 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:45325 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759975Ab3B0Ogg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 09:36:36 -0500
Message-ID: <512E19F2.7060801@slimlogic.co.uk>
Date: Wed, 27 Feb 2013 14:36:34 +0000
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>
Subject: Re: [PATCH 2/2] mfd: palmas: get rid of of_platform_populate() in
 DT registration
References: <1361974120-18134-1-git-send-email-ldewangan@nvidia.com> <1361974120-18134-2-git-send-email-ldewangan@nvidia.com> <512E1685.6080206@slimlogic.co.uk> <512E17AD.1080703@nvidia.com>
In-Reply-To: <512E17AD.1080703@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/13 14:26, Laxman Dewangan wrote:
> On Wednesday 27 February 2013 07:51 PM, Graeme Gregory wrote:
>> On 27/02/13 14:08, Laxman Dewangan wrote:
>>> If driver is getting registered through DT then it look for
>>> population of platform data which is not possible if platform
>>> completely support the DT.
>> No it doesnt!
>>> In this case, if device is registered through DT then just ignore
>>> platform data population and continue the further registration.
>>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>>> ---
>>>   drivers/mfd/palmas.c |   21 +++++++++------------
>>>   1 files changed, 9 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
>>> index 25f0eab..6771d9b 100644
>>> --- a/drivers/mfd/palmas.c
>>> +++ b/drivers/mfd/palmas.c
>>> @@ -465,18 +465,6 @@ static int palmas_i2c_probe(struct i2c_client
>>> *i2c,
>>>       if (ret)
>>>           goto err_irq;
>>>   -    /*
>>> -     * If we are probing with DT do this the DT way and return here
>>> -     * otherwise continue and add devices using mfd helpers.
>>> -     */
>>> -    if (node) {
>>> -        ret = of_platform_populate(node, NULL, NULL, &i2c->dev);
>>> -        if (ret < 0)
>>> -            goto err_irq;
>>> -        else
>>> -            return ret;
>>> -    }
>>> -
>> At this point we exit the function and do nothing with the platform data
>> which should work on wholy DT systems. I have tested it!
>
>
> I think then dt files are different in this case. I did not saw the
> documentation of dt file.
> But following is my entry in dts file which we follow for other devices:
>
>         i2c@7000d000 {
>                 status = "okay";
>                 clock-frequency = <100000>;
>
>   ::::::::::::::
>                 tps65913@58 {
>                         compatible = "ti,palmas";
>                         reg = <0x58>;
>                         interrupts = <0 86 0x4>;
>
>                         #interrupt-cells = <2>;
>                         interrupt-controller;
>
>                         #gpio-cells = <2>;
>                         gpio-controller;
>
>                         regulators {
>                                 smps12 {
>                                         regulator-name = "palmas-smps12";
>                                         regulator-min-microvolt =
> <1350000>;
>                                         regulator-max-microvolt =
> <1350000>;
>                                         regulator-always-on;
>                                         regulator-boot-on;
>                                 };
>
>                                 smps3 {
>                                         regulator-name = "palmas-smps3";
>                                         regulator-min-microvolt =
> <1800000>;
>                                         regulator-max-microvolt =
> <1800000>;
>                                         regulator-always-on;
>                                         regulator-boot-on;
>                                 };
> :::::::::::::::
>                     };
>             };
>     };
>
>
> In the above DT file, it does not work.
>
>
I did slip up and forget to push the documentation file, it has since
started the upstream here

http://article.gmane.org/gmane.linux.documentation/9491/match=palmas+dts

The design of the palmas was to make it properly hierarchical to stop
nasty hacks like accessing parent of parent. As a MFD children should
not be tightly bonded to the MFD device!
 
Graeme

