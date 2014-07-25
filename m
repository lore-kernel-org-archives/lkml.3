Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbaGYSPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:15:06 -0400
Received: from elanic.emc.com.tw ([192.72.220.188]:40379 "EHLO
	elanic.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbaGYSPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:15:04 -0400
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2014 14:15:03 EDT
Content-Type: text/plain; charset=big5
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v2] Input: add i2c/smbus driver for elan touchpad
From: cheng wei Lin <dusonlin@emc.com.tw>
In-Reply-To: <20140724180516.GA26752@core.coreip.homeip.net>
Date: Sat, 26 Jul 2014 02:05:02 +0800
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        bleung@chromium.org, agnescheng@chromium.org,
        =?big5?B?IlNSRDEgJiM2NTUzMzvntr3uJiM2NTUzMzsmIzY1NTMzOz+zoyYj?=
	 =?big5?B?NjU1MzM7JiM2NTUzMzsmIzY1NTMzOyYjNjU1MzM7Ig==?= 
	<phoenix@emc.com.tw>,
        jeff.chuang@emc.com.tw
Content-Transfer-Encoding: 8BIT
Message-Id: <73E9FA09-55D6-409D-A902-29CC3F414CBF@emc.com.tw>
References: <1389064083-11018-1-git-send-email-dusonlin@emc.com.tw> <20140724180516.GA26752@core.coreip.homeip.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Sorry for late to reply you and thanks for your command

Yes, I also agree, it looks great than my original code.
So, should I modify this and upstream v3 patch for you?

thank you,
duson


Dmitry Torokhov <dmitry.torokhov@gmail.com> ©ó 2014/7/25 ¤W¤È2:05 ¼g¹D¡G

> Hi,
> 
> On Tue, Jan 07, 2014 at 11:08:03AM +0800, Duson Lin wrote:
>> +/*
>> + ******************************************************************
>> + * General functions
>> + ******************************************************************
>> + */
>> +/*
>> + * (value from firmware) * 10 + 790 = dpi
>> + * we also have to convert dpi to dots/mm (*10/254 to avoid floating point)
>> + */
>> +static unsigned int elan_convert_res(char val)
>> +{
>> +	int res;
>> +	if (val & 0x80) {
>> +		val = ~val + 1;
>> +		res = (790 - val * 10) * 10 / 254;
>> +	} else
>> +		res = (val * 10 + 790) * 10 / 254;
>> +	return res;
>> +}
> 
> Why isn't this simply:
> 
> 	res = ((int)val * 10 + 790) * 10 / 254;
> 
> ?
> 
> If high bit is 1 you basically do the 2 complement by hand to get to
> positive and then subtract. Which shoudl be the same as adding positive
> value.
> 
> Thanks.
> 
> -- 
> Dmitry
> 

