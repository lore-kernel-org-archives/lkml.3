Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab3LBTbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:31:06 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:48234 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3LBTbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:31:01 -0500
X-AuditID: cbfec37c-b7f9d6d000003434-6d-529cdff34f43
Message-id: <529CDFF1.2080807@samsung.com>
Date: Mon, 02 Dec 2013 12:30:57 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Manuel Krause <manuelkrause@netscape.net>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linux-input@vger.kernel.org,
        linux-serial <linux-serial@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: 3.12.x looses serial mouse over hibernate + resume
References: <52951E69.7090602@netscape.net>
 <529B591F.1020909@hurleysoftware.com> <529CB07C.2040609@netscape.net>
 <19253701.sgP3OieFUq@dtor-d630.eng.vmware.com>
 <20131202164525.GA32406@core.coreip.homeip.net>
 <529CD303.4040103@netscape.net> <529CD528.9000709@samsung.com>
 <20131202190824.GB5245@core.coreip.homeip.net>
In-reply-to: <20131202190824.GB5245@core.coreip.homeip.net>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9hP90v9+cEGXxewm5xeNELRovmxevZ
	LG5++sZqcXnXHDaLM4t72S26Ji5ksTh26R+jxeMVb9ktvv50cOD02DnrLrvHij/r2TwW73nJ
	5LF/7hp2j489j5g9Pm+SC2CL4rJJSc3JLEst0rdL4Mr4cOEDc8FyjoqeyVuZGxgnsHUxcnJI
	CJhI3NvUxgJhi0lcuLceKM7FISSwjFHizLLp7BBOL5PE/tW/WCCcTYwS87sXM3UxcnDwCmhJ
	HD7sB9LNIqAq0XT9D9gkNgF1ic+vd7CD2EICchJNS1Yzg9iiAhESR1c/YwWxeQUEJX5MvgdW
	LyKgL7F99i9GkPnMAh+YJJ6vXQjWICxgL3Fw33eoK04wSVxe38YOsphTwFpiylwLkBpmIHPl
	pG2MELa8xOY1b5khFitL/Ll8CuxOCQFFie2rrSYwisxCsnoWku5ZSLoXMDKvYhQrLU4uKE5K
	T60w1itOzC0uzUvXS87P3cQIibKaHYz3vtocYhTgYFTi4e3YOidIiDWxrLgy9xCjBAezkgjv
	9AtAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYysuytWHjsZwaty4aZOvKSx7nLVk/H7Vs5k33S4
	L3Sy34fnrj947s4/Vsb+wMlxRYRyXvpazuxn/JFWkyY+V48+98b4inDY+la5WyY6cwWF0s/m
	lUqLiXJ3BDWenGy688tj2f6aDfOzVk9YHfs0d8FX6Vjf3EM9ZRdtTqd/Wn7xu5BMcbu3Yp4S
	S3FGoqEWc1FxIgAaOMzvkAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 12:08 PM, Dmitry Torokhov wrote:
> On Mon, Dec 02, 2013 at 11:44:56AM -0700, Shuah Khan wrote:

>>>
>>
>> I am glad the problem is fixed. But I am puzzled. pnp_bus_resume()
>> didn't handle restore prior to this change. state doesn't get passed
>> in to legacy resume routines. I had to add freeze to handle
>> PMSG_FREEZE case, sounds like restore is needed as well, however I
>> don't see where how restore is handled prior to this change.
>
> Take a look at drivers/base/platform.c::platform_pm_restore()
>
> Thanks.
>

Yes I see it now. Before the conversion, platform_legacy_resume() path 
is taken since pnp didn't have pm.

        if (drv->pm) {
                 if (drv->pm->restore)
                         ret = drv->pm->restore(dev);
        } else {
                 ret = platform_legacy_resume(dev);
         }

Thanks for fixing the problem.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
