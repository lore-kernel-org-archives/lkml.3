Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285AbaFCHdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:33:09 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:56322 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbaFCHdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:33:07 -0400
Message-ID: <538D7A1C.5040409@st.com>
Date: Tue, 3 Jun 2014 09:32:44 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
Cc: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>, <kernel@stlinux.com>
Subject: Re: [PATCH] drivers: i2c: i2c-st: Update i2c timings
References: <1400254330-2547-1-git-send-email-maxime.coquelin@st.com> <20140602163103.GJ2654@katana>
In-Reply-To: <20140602163103.GJ2654@katana>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-02_02:2014-06-02,2014-06-02,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On 06/02/2014 06:31 PM, Wolfram Sang wrote:
> On Fri, May 16, 2014 at 05:32:10PM +0200, Maxime COQUELIN wrote:
>> The i2c timing values specified in the driver are the minimun
>> values defined in the I2C specifications.
>> The I2C specification does not specify any default or maximum values.
>>
>> Some I2C devices are out of spec, and might not work properly with minimum
>> values.
>
> Can you give names here? Would be interesting to know since a few
> drivers implement the minimum timings.

I don't have the name actually.
The request to implement this change came from hw guys.

>
>> This patch adds a 10% margin on all the timings.
>
> Is there a safety margin or do the devices start to work exactly at 10%?

10% is a safety margin, I don't know what is the limit.

>
>>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>> ---
>>   drivers/i2c/busses/i2c-st.c | 24 ++++++++++++------------
>>   1 file changed, 12 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-st.c b/drivers/i2c/busses/i2c-st.c
>> index 8720161..09142f1 100644
>> --- a/drivers/i2c/busses/i2c-st.c
>> +++ b/drivers/i2c/busses/i2c-st.c
>> @@ -210,21 +210,21 @@ static inline void st_i2c_clr_bits(void __iomem *reg, u32 mask)
>>   static struct st_i2c_timings i2c_timings[] = {
>
> That needs a comment about the margin, otherwise people will wonder
> where these values come from.

Ok, I will add a comment in the v2.

>
>>   	[I2C_MODE_STANDARD] = {
>>   		.rate			= 100000,
>> -		.rep_start_hold		= 4000,
>> -		.rep_start_setup	= 4700,
>> -		.start_hold		= 4000,
>> -		.data_setup_time	= 250,
>> -		.stop_setup_time	= 4000,
>> -		.bus_free_time		= 4700,
>> +		.rep_start_hold		= 4400,
>> +		.rep_start_setup	= 5170,
>> +		.start_hold		= 4400,
>> +		.data_setup_time	= 275,
>> +		.stop_setup_time	= 4400,
>> +		.bus_free_time		= 5170,
>>   	},
>>   	[I2C_MODE_FAST] = {
>>   		.rate			= 400000,
>> -		.rep_start_hold		= 600,
>> -		.rep_start_setup	= 600,
>> -		.start_hold		= 600,
>> -		.data_setup_time	= 100,
>> -		.stop_setup_time	= 600,
>> -		.bus_free_time		= 1300,
>> +		.rep_start_hold		= 660,
>> +		.rep_start_setup	= 660,
>> +		.start_hold		= 660,
>> +		.data_setup_time	= 110,
>> +		.stop_setup_time	= 660,
>> +		.bus_free_time		= 1430,
>>   	},
>>   };
>>
>> --
>> 1.9.1
>>
