Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3KPAQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:16:43 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:17602 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3KPAQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:16:35 -0500
X-AuditID: cbfec37c-b7fd86d00000670b-f9-5286b962fd6f
Message-id: <5286B95F.4040306@samsung.com>
Date: Fri, 15 Nov 2013 17:16:31 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: len.brown@intel.com, pavel@ucw.cz, gregkh@linuxfoundation.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, anton@enomsg.org, dwmw2@infradead.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] power: Change device_wakeup_enable() to check for null
 dev_name(dev)
References: <1384560238-10708-1-git-send-email-shuah.kh@samsung.com>
 <4035469.UfR6Rto3I2@vostro.rjw.lan>
In-reply-to: <4035469.UfR6Rto3I2@vostro.rjw.lan>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+wr27SzrYgg9lfeS0ObtW0mLhyMrNF
	8+L1bBazpuxlsri8aw6bxefeI4wWd08dZbM4c/oSq8XXnw4WCzY+YnTg8pjQ/4nRY+esu+we
	m1doeSze85LJY//cNeweW662s3isWP2d3ePzJrkAjigum5TUnMyy1CJ9uwSujA+HlrEVXOCs
	+LvpPlMD4xP2LkZODgkBE4mPMx4xQ9hiEhfurWfrYuTiEBJYxijRPuc5C4TTyyQx/fwGRghn
	I6PEh+mzGUFaeAW0JD49+g1mswioSiz8dRLMZhNQl/j8egfYCiEBOYmmJavBVogKREgcXf2M
	FaJXUOLH5HssILaIgLbE3J5TzCALmAW+MUocmnsUrEhYIFri9+znUIOyJE7/2QZUxMHBKWAg
	sfNCJUiYWcBM4lHLOmYIW15i85q3zBDlyhJ/Lp9iAimXEFCU2L7aagKjyCwkm2ch6Z6FpHsB
	I/MqRrHS4uSC4qT01ApjveLE3OLSvHS95PzcTYyQ+KvZwXjvq80hRgEORiUe3gS/tiAh1sSy
	4srcQ4wSHMxKIryHZgOFeFMSK6tSi/Lji0pzUosPMTJxcEo1MMbM370j13JxaMuCrW/S2M02
	6ap3P9x7Unebi2H9Kz/jjw/tWruibYwfqnm8tvWtOPOuuFe1oPMkZ0PjnzscjgvcufqXpjcU
	zmHplLzH3vZse2HOiUK32TxbElks//UHTV2Vd6/+RsV93kl/ROx4ns+q2xqxlveuTeRWM/WC
	i1+VXk18fOdwphJLcUaioRZzUXEiAPq2q6udAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 05:21 PM, Rafael J. Wysocki wrote:
> On Friday, November 15, 2013 05:03:57 PM Shuah Khan wrote:
>> device_wakeup_enable() uses dev_name(dev) as the wakeup source name.
>> When it gets called with a device with its name not yet set, ws structure
>> with ws->name = NULL gets created.
>>
>> When kernel is booted with wakeup_source_activate enabled, it will panic
>> when the trace point code tries to derefernces ws->name.
>>
>> Change device_wakeup_enable() to check for dev_name(dev) null condition
>> and return -EINVAL to avoid panics when device_wakeup_enable() gets called
>> before device is fully initialized with its name.
  		return -EINVAL;
>
> Can you please use WARN_ON(!dev_name(dev)) here?  While I agree that it is a
> bad idea to crash the kernel because dev has no name, that indicates a driver
> bug that shouldn't be too easy to ignore.
>
> Thanks!
>

Right. ok I will re-cut the patch with WARN_ON and send it. fyi I did 
send fix for the driver (power_supply) as well.

http://www.kernelhub.org/?msg=362354&p=2

-- Shuah
-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
