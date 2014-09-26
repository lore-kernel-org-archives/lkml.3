Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaIZJpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:45:00 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63520 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbaIZJo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:44:58 -0400
Message-ID: <54253593.2060508@gmail.com>
Date: Fri, 26 Sep 2014 15:14:51 +0530
From: Sanchayan Maity <maitysanchayan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@freescale.com>
CC: stefan@agner.ch, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: dts: vf610-colibri: Add ADC support
References: <cover.1411122224.git.maitysanchayan@gmail.com> <a0ecfce3f97fb6684657ae76b89f38108fcdf68f.1411122224.git.maitysanchayan@gmail.com> <20140926020745.GH21077@dragon>
In-Reply-To: <20140926020745.GH21077@dragon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 26 September 2014 07:37 AM, Shawn Guo wrote:
> On Fri, Sep 19, 2014 at 04:56:13PM +0530, Sanchayan Maity wrote:
>> Enable ADC support for Colibri VF61 modules
>>
>> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
>> ---
>>  arch/arm/boot/dts/vf610-colibri.dtsi |   10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
>> index 0cd8343..6fd099e 100644
>> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
>> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
>> @@ -27,6 +27,16 @@
>>  
>>  };
>>  
>> +&adc0 {
>> +	pinctrl-names = "default";
> 
> Sorry for missing it, but I would expect properties pinctrl-names and
> pinctrl-0 appear as a couple.  Should we drop property pinctrl-names
> here?
> 
> Shawn

We can actually drop this here. Vybrid has dedicated pads for 4 ADC channels.
Since we are using only these dedicated ADC channels, no pin multiplexing
is required. So we can drop the pinctrl-names property. Will clean and
send out a v3 patch. Thanks for pointing this out. 

- Sanchayan

> 
>> +	status = "okay";
>> +};
>> +
>> +&adc1 {
>> +	pinctrl-names = "default";
>> +	status = "okay";
>> +};
>> +
>>  &esdhc1 {
>>  	pinctrl-names = "default";
>>  	pinctrl-0 = <&pinctrl_esdhc1>;
>> -- 
>> 1.7.9.5
>>
