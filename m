Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaBTAaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:30:03 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:44240 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaBTA37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:29:59 -0500
X-AuditID: cbfec37d-b7ff46d000005528-1b-53054c862c01
Message-id: <53054C83.8000409@samsung.com>
Date: Wed, 19 Feb 2014 17:29:55 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        qiuxishi@huawei.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.10 00/26] 3.10.31-stable review
References: <20140218224530.398913499@linuxfoundation.org>
In-reply-to: <20140218224530.398913499@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.5]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t9hX902H9Zgg74mSYs569ewWTQvXs9m
	cXnXHDaLD2tPsVh8m7ab0eLrTweLBRsfMVo86nvL7sDh8WLhFmaPnbPusnu0HHnL6nFixm8W
	j/1z17B7fN4kF8AWxWWTkpqTWZZapG+XwJXx4vh0toIL3BW72rYzNTDO5uxi5OSQEDCR+Ht8
	IiOELSZx4d56ti5GLg4hgWWMEpNOzWWCcHqZJPouHoDKbGCU2PZ0P1CGg4NXQEui+bslSDeL
	gKrE0tffwSaxCahLfH69gx3EFhKQk2haspoZxBYViJB4dXYiC4jNKyAo8WPyPRaQmSICzYwS
	+/b1gm1jFljBKHH85Us2kCphAVOJ2Ueb2CAmWUmc3DMHbCqngLXEzxdLWEFsZiB75aRtjBC2
	vMTmNW+ZIeqVJf5cPsUE8ZuCxI2Fy1gnMIrMQrJ8FpL2WUjaFzAyr2IUKy1OLihOSk+tMNEr
	TswtLs1L10vOz93ECImv2h2M97/aHGIU4GBU4uGNuM4SLMSaWFZcmXuIUYKDWUmEN5qNNViI
	NyWxsiq1KD++qDQntfgQIxMHp1QDY7GQeVvt0RWX/mvphE5519JyLlYpf5mrskbSa76ysi9/
	j6aFMfK9W1phLf4oseGofW7oj8M7I+0Nftzeuu32oXvbNy384x97lumaqP/K4JnW1hc+LnIT
	dbqgbdCzKO9bwfbbTs+OMblYz3vLzS0/u+HwjtkPG98uW7YiX2tHdbdqxZbVtQ0Wa5RYijMS
	DbWYi4oTAewFIQCNAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 03:46 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.31 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Feb 20 22:45:20 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.31-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compile and boot tests passed on AMD system. Boot failed on Intel 
systems. I think the following changes are the suspect, so far by 
process of elimination - these two aren't in 3.12 and 3.13

#	modified:   mm/hugetlb.c
#	modified:   mm/memory-failure.c

However, my strong suspect is the following:

Xishi Qiu <qiuxishi@huawei.com>
     mm: fix process accidentally killed by mce because of huge page 
migration

I don't see how this could cause problems, none the less, I will test 
without these changes and let you know.


Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
     mm/memory-failure.c: fix memory leak in successful soft offlining

I will test without these changes and let you know.

-- Shuah

Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
