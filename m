Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650Ab3E1MKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:10:41 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:59432 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933211Ab3E1MKk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:10:40 -0400
From: Chao Xie <cxie4@marvell.com>
To: Mark Brown <broonie@kernel.org>, yi zhang <yizhang.mrvl@gmail.com>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "jett.zhou@marvell.com" <jett.zhou@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yi Zhang <yizhang@marvell.com>
Date: Tue, 28 May 2013 05:10:00 -0700
Subject: RE: [PATCH] regulator: 88pm800: add regulator driver
Thread-Topic: [PATCH] regulator: 88pm800: add regulator driver
Thread-Index: Ac5bisLKNXnTAavqTOa8TmGBTesoQwADaF1A
Message-ID: <AAD1C6EB06EE3649B35B7E026785068D2581253EA9@SC-VEXCH2.marvell.com>
References: <1369224653-27150-1-git-send-email-yizhang.mrvl@gmail.com>
 <20130522161422.GP1627@sirena.org.uk>
 <CAK=oMXepj7tmZJ3=b9ja+E1N9eAPmsPhBefAzoswVyGWBXwNOA@mail.gmail.com>
 <20130525195601.GJ7660@sirena.org.uk>
 <CAK=oMXeCUgc5E1ZaXcbrbUB6XGD135a7zRD-CC5apEytx2j=fw@mail.gmail.com>
 <20130528100415.GE3660@sirena.org.uk>
In-Reply-To: <20130528100415.GE3660@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org] 
> Sent: Tuesday, May 28, 2013 6:04 PM
> To: yi zhang
> Cc: Liam Girdwood; Chao Xie; jett.zhou@marvell.com; linux-kernel@vger.kernel.org; Yi Zhang
> Subject: Re: [PATCH] regulator: 88pm800: add regulator driver
> 
> On Tue, May 28, 2013 at 10:32:09AM +0800, yi zhang wrote:
>
>> HI, Brown:

>> In western culture it's either "Hi Mark" or "Hi Mr Brown" (though the latter is pretty formal so not used much for things like mailing lists).
>
>>           Sorry I'm a little confused:
>>           You mean I should use a function for example 
>> "create_buck_table()" to create the BUCK voltage table?
>>            such as:
>>            void create_buck_table()
>>            {
>>                    if (voltage < 1587500) {
>>                              /* initialize the BUCK_table */
>>                    } else
>>                              /* initialize the BUCK_table */
>>            }
>
> No, I mean you shouldn't be using a table at all but have mapping and list functions which just do the calculation required to generate the tables directly.  This saves scanning through the table as direct calcuation is possible.

Hi, Mark
Thanks for your review.
Because structure regulator_desc only accepts the voltage table as constant.
struct regulator_desc {
	...
	const unsigned int *volt_table;
	...
};
If we want to make use of the volt_table, and the help functions regulator_map_voltage_iterate and regulator_list_voltage_table, we have to initialize the tables as what we do now.
So what you mean that we can maintain the structure describes the voltage information in out private structure
struct 88pm800_regulator_desc {
  struct regulator_desc desc
  ...
  struct 88pm800_regulator_vol_table vol_table;
};
The struct 88pm800_regulator_vol_table can be used to define the details of the LDOes like start_vol/end_vol/step.
Then we need define our own map_voltage and list_voltage functions, and based on the struct 88pm800_regulator_vol_table to calculate the correct voltage.
Is above solution what you mean?
