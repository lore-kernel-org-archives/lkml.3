Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab3BFMxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:53:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:33882 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab3BFMxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:53:19 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7f7d6d000000f4e-9e-5112523e3139
Content-transfer-encoding: 8BIT
Message-id: <5112523A.10302@samsung.com>
Date: Wed, 06 Feb 2013 21:53:14 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc: Modify leap year test for more simpler way
References: <51124FF2.2070605@samsung.com>
In-reply-to: <51124FF2.2070605@samsung.com>
X-Forwarded-Message-Id: <51124FF2.2070605@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zTV27IKFAg+bnkhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvjResjxoJjIhVt+w+yNzDeEOhi5OSQEDCR+L32ByuELSZx4d56
	ti5GLg4hgWWMEovu7QZKcIAV/TrpBBFfxChxctUxZpAGXgFBiR+T77GA1DALyEscuZQNEmYW
	UJeYNG8RWImQQBeTxKl3YhDlGhIt99vZQGwWAVWJ88sbmEBsNgE5ibdN3xhBxogKREj86ucA
	CYsI6Ej0Pm9lBFnLLHCNUWLXpBY2kBphAReJCTt1IMZrSSxeMpkdxOYU0Jb4efIV1CtmEheW
	tzJD2PPYJe4eqIdYKyDxbfIhFoivZCU2HYAqkZQ4uOIGywRG8VlI/pqF8NcsJH8tYGRexSia
	WpBcUJyUnmuoV5yYW1yal66XnJ+7iRESIVI7GFc2WBxiFOBgVOLhvaEnGCjEmlhWXJl7iFGC
	g1lJhDfPSShQiDclsbIqtSg/vqg0J7X4EGMy0H0TmaVEk/OB0ZtXEm9obGBsaGhpaGZqaWpA
	mrCSOC/jqScBQgLpiSWp2ampBalFMFuYODilGhjdu5ja1DyWNUdfqhZ36WTXf9hYwhI/8cce
	2ZI191W6/n/VbvwXt9/+bUdSbFpKg2CX2rc1xyxVuvkFvt9p+Hs7cuKLE1bNRy4fP2dz7Hrh
	IvmrAjHxD2ZvnC63h9dw2q3iI8eOWDFvyYp6e/jkMwll7hNHi+fuL73lfO2F0O8Vn4+3Bpdy
	ba1SYinOSDTUYi4qTgQA2OWuXNQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t9jAV27IKFAg39f+Cwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxovWR4wFx0Qq2vYfZG9g
	vCHQxcjBISFgIvHrpFMXIyeQKSZx4d56ti5GLg4hgUWMEidXHWMGSfAKCEr8mHyPBaSeWUBe
	4silbJAws4C6xKR5i8BKhAS6mCROvRODKNeQaLnfzgZiswioSpxf3sAEYrMJyEm8bfrGCDJG
	VCBC4lc/B0hYREBHovd5KyPIWmaBa4wSuya1sIHUCAu4SEzYqQMxXkti8ZLJ7CA2p4C2xM+T
	r1ghTjaTuLC8lXkCo+AsJIfOQjh0FpJDFzAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQI
	jsBnUjsYVzZYHGIU4GBU4uG9oScYKMSaWFZcmXuIUYKDWUmEN89JKFCINyWxsiq1KD++qDQn
	tfgQYzLQnxOZpUST84HJIa8k3tDYxMzI0sjM2MTc2Jg0YSVxXsZTTwKEBNITS1KzU1MLUotg
	tjBxcEo1MKawqrxXzV54XDluoU2ow9YHvfJnfdtfJhTO8z7hwhcWIzc98NXmrwv3dtysnMa8
	csb/8m5GVv14hx++NRvuTZg87wX39oXblN4dT9v3Vjj8lE6wUvuCGamHeNV27kwVWZhzv+hy
	0k+RCxYvAz/zMO5a9uNHadGvNWWVppkeffb/ORht6/8cW6LEUpyRaKjFXFScCABYcQgjBAMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 02월 06일 20:42, Venu Byravarasu wrote:
> By definition, leap year is one, which is a divisible by 4 & 400, excluding multiples of 100s.
> Hence I feel this patch is not correct.

No, I think you might misunderstood the it's meaning. The former code checks
whether if it is multiple of 4 or not. Formal mathematical way to verify multiple of 4
is just checks the last two digits are multiple of 4. This '(!year % 4) && (year % 100)'
part does it. But with only that checking, it may miss the case of multiple of 400 which
is also multiple of 4. That's why '!(year % 400)' part was needed.
Then my modification checks in hexadecimal, whether if number has any of 1st and 2nd bit
with value 1. Because any number which has all bits above the 3rd can be divided with 4(2^2).
(e.g. 44(0b101100) = 2^5+2^3+2^2 = 2^2(2^3 + 2 + 1)) So It does same things with
less instructions.

Thanks,
Jonghwa

> Thanks,
> Venu
>
>
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Jonghwa Lee
>> Sent: Wednesday, February 06, 2013 4:53 PM
>> To: linux-kernel@vger.kernel.org
>> Cc: a.zummo@towertech.it; Andrew Morton; rtc-linux@googlegroups.com;
>> Jonghwa Lee
>> Subject: [PATCH] rtc: Modify leap year test for more simpler way
>>
>> Leap year which is multiple of 4, just needed 2 LSB for verifying.
>> A year with zero for all thease two bits means that it is leap year.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> ---
>>  include/linux/rtc.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/rtc.h b/include/linux/rtc.h
>> index 9531845..d662b8d 100644
>> --- a/include/linux/rtc.h
>> +++ b/include/linux/rtc.h
>> @@ -181,7 +181,7 @@ void rtc_timer_do_work(struct work_struct *work);
>>
>>  static inline bool is_leap_year(unsigned int year)
>>  {
>> -	return (!(year % 4) && (year % 100)) || !(year % 400);
>> +	return !(year & 0x3);
>>  }
>>
>>  #ifdef CONFIG_RTC_HCTOSYS_DEVICE
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

