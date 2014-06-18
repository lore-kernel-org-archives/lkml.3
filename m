Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbaFRFDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:03:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58583 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaFRFDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:03:18 -0400
Message-ID: <53A11D40.7020201@ti.com>
Date: Wed, 18 Jun 2014 10:31:52 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Keerthy <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
Subject: Re: [PATCH 7/9] regulator: palmas: Add palmas_pmic_driver_data structure
References: <1401272423-25761-1-git-send-email-j-keerthy@ti.com> <1401272423-25761-8-git-send-email-j-keerthy@ti.com> <20140617163721.GR29841@lee--X1>
In-Reply-To: <20140617163721.GR29841@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 June 2014 10:07 PM, Lee Jones wrote:
> On Wed, 28 May 2014, Keerthy wrote:
>
>> Add palmas_pmic_driver_data structure.
>>
>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>> ---
>>   include/linux/mfd/palmas.h |   25 +++++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>
>> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
>> index 8d68452..70f0695 100644
>> --- a/include/linux/mfd/palmas.h
>> +++ b/include/linux/mfd/palmas.h
>> @@ -53,6 +53,8 @@ struct palmas_pmic;
>>   struct palmas_gpadc;
>>   struct palmas_resource;
>>   struct palmas_usb;
>> +struct palmas_pmic_driver_data;
>> +struct palmas_pmic_platform_data;
>>   
>>   enum palmas_usb_state {
>>   	PALMAS_USB_STATE_DISCONNECT,
>> @@ -76,6 +78,8 @@ struct palmas {
>>   	struct mutex irq_lock;
>>   	struct regmap_irq_chip_data *irq_data;
>>   
>> +	struct palmas_pmic_driver_data *pmic_ddata;
>> +
>>   	/* Child Devices */
>>   	struct palmas_pmic *pmic;
>>   	struct palmas_gpadc *gpadc;
>> @@ -107,6 +111,27 @@ struct regs_info {
>>   	int	sleep_id;
>>   };
>>   
>> +struct palmas_pmic_driver_data {
>> +	int smps_start;
>> +	int smps_end;
>> +	int ldo_begin;
>> +	int ldo_end;
>> +	int max_reg;
>> +	struct regs_info *palmas_regs_info;
>> +	struct of_regulator_match *palmas_matches;
>> +	struct palmas_sleep_requestor_info *sleep_req_info;
>> +	int (*smps_register)(struct palmas_pmic *pmic,
>> +			     struct palmas_pmic_driver_data *ddata,
>> +			     struct palmas_pmic_platform_data *pdata,
>> +			     const char *pdev_name,
>> +			     struct regulator_config config);
>> +	int (*ldo_register)(struct palmas_pmic *pmic,
>> +			    struct palmas_pmic_driver_data *ddata,
>> +			    struct palmas_pmic_platform_data *pdata,
>> +			    const char *pdev_name,
>> +			    struct regulator_config config);
> Are you sure you need to store all of this stuff?
>
> Particularly the match pointer.  Do you really re-use it?

Match pointer is used extensively in the palmas_regulator.c.
This structure is very much used by regulator driver.

>
>> +};
>> +
>>   struct palmas_gpadc_platform_data {
>>   	/* Channel 3 current source is only enabled during conversion */
>>   	int ch3_current;

