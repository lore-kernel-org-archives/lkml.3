Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbbAZA3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 19:29:44 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:44776 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbAZA3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 19:29:40 -0500
Message-ID: <54C58A66.8070500@roeck-us.net>
Date: Sun, 25 Jan 2015 16:29:26 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans Holmberg <hans.holmberg@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3.10 25/50] gpiolib: of: Correct error handling in of_get_named_gpiod_flags
References: <20150125180702.521559311@linuxfoundation.org> <20150125180703.970882239@linuxfoundation.org> <20150125213149.GA3313@roeck-us.net> <20150125220518.GA29924@kroah.com>
In-Reply-To: <20150125220518.GA29924@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54C58A73.0118,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2015 02:05 PM, Greg Kroah-Hartman wrote:
> On Sun, Jan 25, 2015 at 01:31:49PM -0800, Guenter Roeck wrote:
>> On Sun, Jan 25, 2015 at 10:07:15AM -0800, Greg Kroah-Hartman wrote:
>>> 3.10-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Hans Holmberg <hans.holmberg@intel.com>
>>>
>>> commit 7b8792bbdffdff3abda704f89c6a45ea97afdc62 upstream.
>>>
>>> of_get_named_gpiod_flags fails with -EPROBE_DEFER in cases
>>> where the gpio chip is available and the GPIO translation fails.
>>>
>>> This causes drivers to be re-probed erroneusly, and hides the
>>> real problem(i.e. the GPIO number being out of range).
>>>
>>> Signed-off-by: Hans Holmberg <hans.holmberg@intel.com>
>>> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
>>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>
>> This patch is causing several build failures.
>>
>> Error log:
>> drivers/gpio/gpiolib-of.c: In function 'of_gpiochip_find_and_xlate':
>> drivers/gpio/gpiolib-of.c:50:3: error: implicit declaration of function 'ERR_PTR'
>>
>> since "#include <linux/err.h>" is missing in drivers/gpio/gpiolib-of.c
>> in the 3.10 kernel.
>
> Thanks for letting me know, I've pushed out a fix for this in the quilt
> tree of patches.
>

Confirmed; build and qemu tests now pass with no errors.

Guenter


