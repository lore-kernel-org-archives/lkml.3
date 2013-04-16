Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab3DPPQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:16:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:57034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab3DPPQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:16:01 -0400
Message-ID: <516D6B05.50202@infradead.org>
Date: Tue, 16 Apr 2013 08:15:17 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V4 3/7] DA9058 ONKEY driver
References: <201304121318.r3CDILZS013210@latitude> <5168681A.20405@infradead.org> <24DF37198A1E704D9811D8F72B87EB514191E38B@NB-EX-MBX02.diasemi.com>
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB514191E38B@NB-EX-MBX02.diasemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/13 03:33, Opensource [Anthony Olech] wrote:
>> -----Original Message-----
>> From: Randy Dunlap [mailto:rdunlap@infradead.org]
>> Sent: 12 April 2013 21:02
>> To: Opensource [Anthony Olech]
>> Cc: Dmitry Torokhov; Mark Brown; Samuel Ortiz; Ashish Jangam; Eric
>> Andersson; Andrew Jones; linux-input@vger.kernel.org; LKML; David Dajun Chen
>> Subject: Re: [NEW DRIVER V4 3/7] DA9058 ONKEY driver
>>
>> On 04/12/13 06:05, Anthony Olech wrote:
>>> This is the ONKEY component driver of the Dialog DA9058 PMIC.
>>> This driver is just one component of the whole DA9058 PMIC driver.
>>> It depends on the CORE component driver of the DA9058 MFD.
>>>
>>> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
>>> Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
>>> ---
>>>  drivers/input/misc/Kconfig        |   10 +++
>>>  drivers/input/misc/Makefile       |    1 +
>>>  drivers/input/misc/da9058_onkey.c |  177
>>> +++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 188 insertions(+)
>>>  create mode 100644 drivers/input/misc/da9058_onkey.c
>>>
>>> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
>>> index 259ef31..bd07b38 100644
>>> --- a/drivers/input/misc/Kconfig
>>> +++ b/drivers/input/misc/Kconfig
>>> @@ -93,6 +93,16 @@ config INPUT_BMA150
>>>  	  To compile this driver as a module, choose M here: the
>>>  	  module will be called bma150.
>>>
>>> +config INPUT_DA9058_ONKEY
>>> +	tristate "DA9058 ONKEY support"
>>> +	depends on MFD_DA9058
>>> +	help
>>> +	  Support the ONKEY of DA9058 PMICs as an input device
>>> +	  reporting power button status.
>>
>> What possible values can a power button status have?
>> Must be more than my KISS guess:
>> 	this software is running => ON
>> 	software not running     => OFF
>> eh?
> 
> Pressing the button briefly and pressing and holding the button will have
> different effects in a mobile device. The press and hold on phones normally
> switches them into a sleep state. So the "power button status" is the fact
> that the ONKEY is still being held down.
> 
> Does that answer your question? or have I missed your point??

Yes, that answers my question.  I get it.

> 
> [...]
>>> +	onkey->irq = platform_get_irq(pdev, 0);
>>> +	if (onkey->irq < 0) {
>>> +		dev_err(&pdev->dev, "can not get ONKEY IRQ error=%d\n",
>>
>> 		                     cannot
> 
> The Washington State University language site says:
> 
> "These two spellings [cannot/can not] are largely interchangeable, but by far
> the most common is 'cannot' and you should probably use it except when you
> want to be emphatic: 'No, you can not wash the dog in the Maytag.'"
> 
> Since I was not trying to be particularly emphatic, I will change to using 'cannot'
> as per your suggestion.

thanks.


-- 
~Randy
