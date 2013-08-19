Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab3HSWbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:31:39 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:31218 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3HSWbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:31:37 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfec37b-b7f306d0000047de-64-52129cc87d65
Message-id: <52129CC5.7080708@samsung.com>
Date: Mon, 19 Aug 2013 16:31:33 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
To: shuah.kh@samsung.com
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [ 00/34] 3.4.59-stable review
References: <20130818203259.653403173@linuxfoundation.org>
 <52125DA9.3090601@samsung.com> <20130819193538.GB24897@kroah.com>
 <201308192214.54917.s.L-H@gmx.de> <52129AC3.5020402@samsung.com>
In-reply-to: <52129AC3.5020402@samsung.com>
Content-transfer-encoding: 8bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9hP90Tc4SCDHb+5rFoXryezeLyrjls
	Fo+eXGSz+PrTwWLBxkeMDqweO2fdZff48DHOY//cNewenzfJBbBEcdmkpOZklqUW6dslcGUc
	PXKCsWCpUMXt6zeYGhhf8nUxcnJICJhIbJy8hBHCFpO4cG89WxcjF4eQwDJGia1rn7CCJHgF
	BCV+TL7HAmIzC5hJPGpZxwxiCwn0Mkm83e0K0bCRUeL0kjlMEA1aEs9b/oPZLAKqEg/6N4LZ
	bALqEp9f72CHaJaTaFqyGmgQB4eoQITE0eWaIGERAQmJr01X2SB2nWWUeDbdEcQWBhr59c8r
	qOMOMkos+7QH7AhOAW2JiVtvQzXISxy88pwFYr6yxJ/Lp5hA5ksIKEpsX201gVFkFpJ3ZiF5
	ZxaS7gWMzKsYxUqLkwuKk9JTK4z0ihNzi0vz0vWS83M3MUKipHoH492vNocYBTgYlXh4O5SE
	goRYE8uKK3MPMUpwMCuJ8MaXAIV4UxIrq1KL8uOLSnNSiw8xMnFwSjUw9u55dfGWif8BQ+mJ
	y/7VTdxy9SPv8ec+dtlTZsYf+JwouGBhbffX1ayLGCc/m/vwqM/72mOZ81+UF83ofnHr8Za0
	O1vahXoCDC0mZa681RC7dnr68bCjEd2zTt+cuW7NxDjGMvP8e9P2PXsoczpEk08v4d3H3QU3
	yu7cZQ5r0f4j4xq5jOP1ImklluKMREMt5qLiRAA3a3E9cAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 04:22 PM, Shuah Khan wrote:
> On 08/19/2013 02:14 PM, Stefan Lippers-Hollmann wrote:
>> Hi
>>
>> On Monday 19 August 2013, Greg Kroah-Hartman wrote:
>>> On Mon, Aug 19, 2013 at 12:02:17PM -0600, Shuah Khan wrote:
>>>> On 08/18/2013 02:34 PM, Greg Kroah-Hartman wrote:
>> […]
>>>> and the following traces in dmesg:
>>>> [  124.802169] init: udevtrigger post-stop process (353) terminated
>>>> with status 1
>>>> [  243.439212] INFO: task crda:723 blocked for more than 120 seconds.
>>>
>>> What is "crda"?
>>>
>>> Any luck with bisection?  It should go fast as the majority of patches
>>> here are non-x86.
>>
>> crda is a userspace helper, invoked by udev events, which sets -and
>> intersects as needed- the regulatory domain settings for (modern,
>> cfg80211 based) wlan hardware based on the device's EEPROM regdom hint,
>> local configuration (country code) and eventual IEEE 802.11d hints
>> (country IEs) beaconed by access points nearby. It hooks into udev with
>> these udev rules (Debian/ 1.1.2-1):
>>
>> $ grep -v -e ^$ -e ^\# /lib/udev/rules.d/60-crda.rules
>> SUBSYSTEM=="ieee80211", ACTION=="add", RUN+="/lib/crda/setregdomain"
>>
>> $ grep -v -e ^$ -e ^\# /lib/udev/rules.d/85-regulatory.rules
>> KERNEL=="regulatory*", ACTION=="change", SUBSYSTEM=="platform",
>> RUN+="/sbin/crda"
>>
>> Full source is at [2], it should be installed on pretty much every
>> distro/ system released with wlan support for the last >>3 years.
>>
>> There are two iwl4965 patches in this series, which might be among the
>> first ones to check - /if/ you actually have that hardware, the second
>> one (iwl4965: reset firmware after rfkill off) might also indirectly
>> have an effect on blutetooth (via rfkill).
>>
>> Regards
>>     Stefan Lippers-Hollmann
>>
>> [1]    http://wireless.kernel.org/en/developers/Regulatory/CRDA
>> [2]    https://github.com/mcgrof/crda
>>
>
> Greg,
>
> git bisect shows the following patch as the problem:
>
> [ 26/34] genetlink: fix family dump race
>
>
> -- Shuah
>

Interesting. The same patch is in 3.10.8 as well, and I don't see this 
problem on this system on 3.10.8.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
