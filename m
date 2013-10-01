Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab3JAUMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:12:41 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:34481 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3JAUMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:12:35 -0400
Message-ID: <524B3ADE.9060602@kernel.org>
Date: Tue, 01 Oct 2013 22:13:02 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk
CC: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 07/20] Documentation: dt: iio: Add binding for LPS001WP
References: <1379347346-823-1-git-send-email-lee.jones@linaro.org> <1379347346-823-8-git-send-email-lee.jones@linaro.org> <524B3A19.9050509@kernel.org>
In-Reply-To: <524B3A19.9050509@kernel.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/13 22:09, Jonathan Cameron wrote:
> On 09/16/13 17:02, Lee Jones wrote:
>> LPS001WP is a Pressure and Temperature sensor.
>>
>> Cc: devicetree@vger.kernel.org
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Hi Lee,
> 
> I'm planning to drop this set of bindings in favour of the unified ones
> proposed by Lukasz Czerwinski.
Sorry, I just realised this is unclear.  I'm proposing to drop the
documentation added in this patch in favour of the other version
in which a file per type of sensor is used rather than one per
individual sensor chip.
> 
> Could you take a look at those and perhaps propose the additional bits and pieces
> needed to ensure everything is covered by the resulting files?
> 
> Thanks,
> 
> Jonathan
>> ---
>>  .../devicetree/bindings/iio/pressure/lps001wp.txt   | 21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/iio/pressure/lps001wp.txt
>>
>> diff --git a/Documentation/devicetree/bindings/iio/pressure/lps001wp.txt b/Documentation/devicetree/bindings/iio/pressure/lps001wp.txt
>> new file mode 100644
>> index 0000000..45cb45c
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iio/pressure/lps001wp.txt
>> @@ -0,0 +1,21 @@
>> +* STMicroelectronics Pressure Sensor
>> +
>> +Required properties:
>> +  - compatible: Should be "st,lps001wp"
>> +  - reg: The I2C address of the sensor
>> +
>> +Optional properties:
>> +  - vdd-supply: Phandle to the Vdd supply regulator
>> +  - vddio-supply: Phandle to the Vdd-IO supply regulator
>> +
>> +Example:
>> +
>> +i2c@80128000 {
>> +        lps001wp@5c {
>> +                compatible = "st,lps001wp";
>> +                reg = <0x5c>;
>> +
>> +                vdd-supply = <&ab8500_ldo_aux1_reg>;
>> +                vddio-supply = <&db8500_vsmps2_reg>;
>> +        };
>> +};
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
