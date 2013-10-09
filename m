Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab3JIEg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 00:36:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24549 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3JIEgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 00:36:55 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-ff-5254dd665cfb
Message-id: <5254DD64.4090205@samsung.com>
Date: Wed, 09 Oct 2013 13:36:52 +0900
From: "sangjung.woo" <sangjung.woo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Joe Perches <joe@perches.com>
Cc: Alessandro Rubini <rubini@gnudd.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, sangjung.woo@samsung.com
Subject: Re: [PATCH] rtc: pl030: Use devm_kzalloc() instead of kmalloc()
References: <1381291240-23727-1-git-send-email-sangjung.woo@samsung.com>
 <1381291649.2040.1.camel@joe-AO722>
In-reply-to: <1381291649.2040.1.camel@joe-AO722>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWyRsSkQDftbkiQwf/XIhaz7z9msbi8aw6b
	xeYPL9ks9nd2MFr8PplssWBPiQObR0tzD5vH1tYDrB57Jp5k8/iy6hqzR9+WVYwenzfJBbBF
	cdmkpOZklqUW6dslcGWsWXyNseAZe8Wp68YNjAvYuhg5OCQETCR69vJ1MXICmWISF+6tBwpz
	cQgJLGWUOHOomR0iYSLxtHsZI0RiEaPEkeOnmCCc14wSF35/YgKp4hXQkljQspsVxGYRUJV4
	uvENC4jNJqAv8XH5cmYQW1QgTGLJt8dsEPWCEj8m32MBuUJEQFHi7hZ+kJnMAmsYJQ686ALb
	LCzgIdFyfi9Yr5BAnsTtK4fAruYUMJA4/VoHJMwsYC2xctI2RghbXmLzmrfMIHMkBM6xS/y8
	dIQJ4h4BiW+TD7FAfCwrsekAM8RjkhIHV9xgmcAoNgvJRbOQjJ2FZOwCRuZVjKKpBckFxUnp
	RSZ6xYm5xaV56XrJ+bmbGIHxdvrfswk7GO8dsD7EmAy0ciKzlGhyPjBe80riDY3NjCxMTUyN
	jcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAaHNpX+L+zCff7A9y8Lxm
	aZh2T/lFy68LL97MqVm/OI5ZPkyjVdG+5fTji7892fr0j9V9SI1aERD8+MDDrRwu77Z1fLA/
	PVfP/U3255//7vKfeJNqWlIvpZXLt6ZvSsXTpQvvm/9g6KjXti/kjfHcvDj0CM+vnQcK0x9n
	vXdg+HJwj8OCBcd3LVdiKc5INNRiLipOBABGQBA0zQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAd20uyFBBmun81nMvv+YxeLyrjls
	Fps/vGSz2N/ZwWjx+2SyxYI9JQ5sHi3NPWweW1sPsHrsmXiSzePLqmvMHn1bVjF6fN4kF8AW
	1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0hZJC
	WWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY83ia4wFz9grTl03bmBcwNbF
	yMkhIWAi8bR7GSOELSZx4d56oDgXh5DAIkaJI8dPMUE4rxklLvz+xARSxSugJbGgZTcriM0i
	oCrxdOMbFhCbTUBf4uPy5cwgtqhAmMSSb4/ZIOoFJX5MvgdUw8EhIqAocXcLP8hMZoE1jBIH
	XnSxg9QIC3hItJzfC9YrJJAncfvKITaQek4BA4nTr3VAwswC1hIrJ21jhLDlJTavecs8gVFg
	FpINs5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcDw/k97BuKrB4hCjAAej
	Eg/vA/6QICHWxLLiytxDjBIczEoivHkLgUK8KYmVValF+fFFpTmpxYcYk4EBMJFZSjQ5H5hq
	8kriDY1NzIwsjcwNLYyMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsXx1jsPck+9m
	+Z4uYjdgqgh46NY3aRF/SdvJrZ7rXMwq/uy/rD1pR0/izLojl2/IreidGvqq1Fo2NVV8x6qF
	jNwMMxv3J1R+0nyx4QT3vk/ZSy4e+92w2616r9MqIde5MhNOrW/h7xZe4HffoVXHl8/tnEtC
	/gM9lR3Fysdequp3nFBNCSnOUmIpzkg01GIuKk4EAOnz1XwrAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 01:07 PM, Joe Perches wrote:
> On Wed, 2013-10-09 at 13:00 +0900, Sangjung Woo wrote:
>> In order to be free automatically and make the cleanup paths more
>> simple, use devm_kzalloc() instead of kzalloc().
> []
>> diff --git a/drivers/rtc/rtc-pl030.c b/drivers/rtc/rtc-pl030.c
> []
>> @@ -106,7 +106,7 @@ static int pl030_probe(struct amba_device *dev, const struct amba_id *id)
>>   	if (ret)
>>   		goto err_req;
>>   
>> -	rtc = kmalloc(sizeof(*rtc), GFP_KERNEL);
>> +	rtc = devm_kzalloc(&dev->dev, sizeof(*rtc), GFP_KERNEL);

First of all, thanks for your review.

> You're not deleting a memset and you're
> converting a kmalloc.
You are right.
>
> Why do you need the zalloc version?
>
The key point of this patch is resource-managed memory allocation.
As you already know, memory space that is allocated by devm_kzalloc() 
function
is automatically freed on driver detach. That makes the code tidy and
reduces human's mistakes not to kfree().



