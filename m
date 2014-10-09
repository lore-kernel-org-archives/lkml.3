Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbaJINSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:18:00 -0400
Received: from mail-bn1on0086.outbound.protection.outlook.com ([157.56.110.86]:16208
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754947AbaJINRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:17:54 -0400
Message-ID: <54368AF8.1060807@opensource.altera.com>
Date: Thu, 9 Oct 2014 08:17:44 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <dinh.linux@gmail.com>, <atull@opensource.altera.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reset: add reset_control_status helper function
References: <1412808351-4598-1-git-send-email-dinguyen@opensource.altera.com> <1412844240.6809.1.camel@pengutronix.de>
In-Reply-To: <1412844240.6809.1.camel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.103.66.154]
X-ClientProxiedBy: BY2PR07CA045.namprd07.prod.outlook.com (10.141.251.20) To
 BY1PR0301MB1191.namprd03.prod.outlook.com (25.160.195.15)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1191;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(377454003)(479174003)(24454002)(189002)(51704005)(199003)(65806001)(83506001)(76482002)(31966008)(77096002)(65956001)(64706001)(120916001)(66066001)(102836001)(21056001)(42186005)(20776003)(47776003)(64126003)(87976001)(85852003)(101416001)(122386002)(99396003)(19580405001)(40100002)(19580395003)(80316001)(50986999)(59896002)(99136001)(33656002)(76176999)(54356999)(87266999)(85306004)(23676002)(107046002)(86362001)(95666004)(92726001)(106356001)(92566001)(105586002)(80022003)(46102003)(50466002)(65816999)(110136001)(4396001)(97736003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1191;H:Dinhs-MacBook-Pro.local;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On 10/9/14, 3:44 AM, Philipp Zabel wrote:
> Hi Dinh,
> 
> thank you for the patch. Just two small issues below:
> 
> Am Mittwoch, den 08.10.2014, 17:45 -0500 schrieb dinguyen@opensource.altera.com:
> [...]
>> @@ -126,6 +126,19 @@ int reset_control_deassert(struct reset_control *rstc)
>>  EXPORT_SYMBOL_GPL(reset_control_deassert);
>>  
>>  /**
>> + * reset_control_status - returns a status of a reset bit
>> + * @rstc: reset controller
>> + */
>> +unsigned int reset_control_status(struct reset_control *rstc)
>> +{
>> +	if (rstc->rcdev->ops->status)
>> +		return rstc->rcdev->ops->status(rstc->rcdev, rstc->id);
>> +
>> +	return -ENOSYS;
>> +}
>> +EXPORT_SYMBOL_GPL(reset_control_status);
> 
> Since this function can return negative error numbers, please make the
> return value of reset_control_status int. That also means that drivers
> must not set the MSB when returning status.

Ah yes...Don't why I changed it to unsigned int for the return.

> 
>> +
>> +/**
>>   * of_reset_control_get - Lookup and obtain a reference to a reset controller.
>>   * @node: device to be reset by the controller
>>   * @id: reset line name
>> diff --git a/include/linux/reset-controller.h b/include/linux/reset-controller.h
>> index 41a4695..8e659d5 100644
>> --- a/include/linux/reset-controller.h
>> +++ b/include/linux/reset-controller.h
>> @@ -17,6 +17,7 @@ struct reset_control_ops {
>>  	int (*reset)(struct reset_controller_dev *rcdev, unsigned long id);
>>  	int (*assert)(struct reset_controller_dev *rcdev, unsigned long id);
>>  	int (*deassert)(struct reset_controller_dev *rcdev, unsigned long id);
>> +	unsigned int (*status)(struct reset_controller_dev *rcdev, unsigned long id);
>>  };
> 
> Please change the return value of the status callback to int and
> describe it in the kerneldoc comment above. It should probably be
> mentioned that the returned status value must be >= 0 except in error
> cases.
>  
Will do for V2...

Dinh
