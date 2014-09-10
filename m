Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaIJTdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:33:00 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:51745 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaIJTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:32:58 -0400
Message-ID: <5410A766.8020005@kernel.org>
Date: Wed, 10 Sep 2014 20:32:54 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Laurentiu Palcu <laurentiu.palcu@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Joe Perches <joe@perches.com>
CC: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] iio: accel: BMC150: add support for other Bosch
 chips
References: <1409301488-22166-4-git-send-email-laurentiu.palcu@intel.com> <1409562698-13202-1-git-send-email-laurentiu.palcu@intel.com> <1409585783.2664.18.camel@joe-AO725> <1409586696.3318.11.camel@spandruv-hsb-test> <20140902103010.GF12606@lpalcu-linux>
In-Reply-To: <20140902103010.GF12606@lpalcu-linux>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/14 11:30, Laurentiu Palcu wrote:
> On Mon, Sep 01, 2014 at 08:51:36AM -0700, Srinivas Pandruvada wrote:
>> On Mon, 2014-09-01 at 08:36 -0700, Joe Perches wrote:
>>> On Mon, 2014-09-01 at 12:11 +0300, Laurentiu Palcu wrote:
>>>> The following chips are either similar or have only the resolution
>>>> different. Hence, change this driver to support these chips too:
>>>>
>>>> BMI055  - combo chip (accelerometer part is identical to BMC150's)
>>>> BMA255  - identical to BMC150's accelerometer
>>>> BMA222E - 8 bit resolution
>>>> BMA250E - 10 bit resolution
>>>> BMA280  - 14 bit resolution
>>>>
>>>> Additionally:
>>>>  * add bmc150_accel_match_acpi_device() function to check that the device
>>>>    has been enumerated through ACPI;
>>>>  * rename bmc150_accel_acpi_gpio_probe() to bmc150_accel_gpio_probe()
>>>>    since the ACPI matching has been moved to the new function.  Also, this
>>>>    will allow for the GPIO matching to be done against a device tree too, not only
>>>>    ACPI tree;
>>> []
>>>> diff --git a/drivers/iio/accel/bmc150-accel.c b/drivers/iio/accel/bmc150-accel.c
>>> []
>>>> @@ -647,12 +659,13 @@ static int bmc150_accel_read_raw(struct iio_dev *indio_dev,
>>>>  		{
>>>>  			int i;
>>>>  
>>>> -			for (i = 0; i < ARRAY_SIZE(bmc150_accel_scale_table);
>>>> -									 ++i) {
>>>> -				if (bmc150_accel_scale_table[i].range ==
>>>> +			for (i = 0;
>>>> +			     i < ARRAY_SIZE(data->chip_info->scale_table);
>>>> +			     ++i) {
>>>> +				if (data->chip_info->scale_table[i].range ==
>>>>  								data->range) {
>>>>  					*val2 =
>>>> -					bmc150_accel_scale_table[i].scale;
>>>> +					data->chip_info->scale_table[i].scale;
>>>>  					return IIO_VAL_INT_PLUS_MICRO;
>>>>  				}
>>>>  			}
>>>
>>> This looks like it would read a lot better with
>>> a temporary for data->chip_info->scale_table[i]
>>>
>>> so these could become:
>>>
>>> 			for (i = 0; i < etc; i++) {
>>> 				type *temp = &data->chip_info->scale_table[i];
>>> 				if (temp->range == data->range) {
>>> 					*val2 = temp->scale;
>>> 					return IIO_VAL_INT_PLUS_MICRO;
>>> 				}
> Rewrote this part in v5. Thanks for the suggestion.
> 
>>>
>>> Maybe all the bmc150_ variable names could be removed.
>>> The prefixes don't seem to serve a purpose other than
>>> to make the code longer.
>>>
>>> The filename could be changed to be more generic.
>> Then this will also require change in the CONFIG name to match. This
>> will require all current users to change the config file once they
>> update to new version of the driver, which they don't like to change
>> once product config is finalized. Since the most of the chips will just
>> differ by a number at the end and they may not be compatible to each
>> other, finding a common name will be challenge.
>> Instead the CONFIG description for this module should explicitly state
>> the names of chips it is compatible to.
> v5 contains the changed CONFIG description that includes the new added chips.
Agreed. Don't rename the driver.  Now, if companies went with naming based on
the interface it might be a good idea.  In reality it is a nightmare so much
better to keep to a name that covers one part and as you say, make it clear
in the Kconfig help what other parts are supported...

Jonathan
> 
> thanks,
> laurentiu
> 
