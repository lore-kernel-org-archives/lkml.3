Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbaCEW3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:29:09 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:58404 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbaCEW3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:29:06 -0500
X-AuditID: cbfec37a-b7fc06d00000555a-4d-5317a5309fd8
Message-id: <5317A52E.4@samsung.com>
Date: Wed, 05 Mar 2014 15:29:02 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Joe Perches <joe@perches.com>
Cc: lgirdwood@gmail.com, broonie@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, Mark Brown <broonie@linaro.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.13] regulator: core: Change dummy supplies error message
 to a warning
References: <1394054987-4743-1-git-send-email-shuah.kh@samsung.com>
 <1394056859.12070.23.camel@joe-AO722>
In-reply-to: <1394056859.12070.23.camel@joe-AO722>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.11]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9hX12DpeLBBktWGltMffiEzWLT9eus
	Fs2L17NZzL7/mMXi25UOJovLu+awWXz96WCxYOMjRgcOj52z7rJ7bFrVyeZx59oeNo/9c9ew
	e3xZdY3Z4/MmuQC2KC6blNSczLLUIn27BK6Mdatushas46hYdGkzawPjNbYuRk4OCQETiVkN
	u1ggbDGJC/fWg8WFBJYxShw+UAth9zJJfF7A1cXIBWRvYpR4umINO0iCV0BFYv+eO6wgNouA
	qsSS1mOMIDabgLrE59c72CGa5SSalqxmBrFFBSIkXp2dyALRKyjxY/I9IJuDQ0RAUeLuFn6Q
	MLNAJ5PEmqN6IGFhgViJl11ZEFOyJV7+WM4IEuYUMJKYv9wCotpaYuWkbYwQtrzE5jVvmSHK
	lSX+XD7FBFIuATT813/3CYwis5CsnYWkexaS7gWMzKsYxUqLkwuKk9JTKwz1ihNzi0vz0vWS
	83M3MUIiqmoH452vNocYBTgYlXh4N/iJBwuxJpYVV+YeYpTgYFYS4Q2IBArxpiRWVqUW5ccX
	leakFh9iZOLglGpg9L3zYmmPXNh6t5gZt53ZEts+mhssiFn7g4np1caObbOMvxwr7H4qy7W3
	rfyy3uvNEp+EoiNmp66+cHL5OlMe7tna+Rf2xbo9zwozVZBtn8PJK9vw73bSZYN1HvMi6u+L
	39I7urH532b39euL8+eq6Hc8Xmu5OeJWZH54YJzJc5lZip0fPiUtVWIpzkg01GIuKk4EAJXR
	3+qGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 03:00 PM, Joe Perches wrote:
> On Wed, 2014-03-05 at 14:29 -0700, Shuah Khan wrote:
>> Change "dummy supplies not allowed" error message to warning instead,
>> as this is a just warning message with no change to the behavior.
> []
>> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> []
>> @@ -1359,7 +1359,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
>>   		rdev = dummy_regulator_rdev;
>>   		goto found;
>>   	} else {
>> -		dev_err(dev, "dummy supplies not allowed\n");
>> +		dev_warn(dev, "dummy supplies not allowed\n");
>
> What does this mean anyway?
>
> Would it be better to emit the calling function too with
> %pf, __builtin_return_address(0)?
>

Maybe. In that case, that change has to first go into the mainline. This 
is a back port of an upstream commit to get rid of a regression in error 
messages.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
