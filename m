Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaISBYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 21:24:21 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:37203 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaISBYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 21:24:20 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8J1O0f7003874, This message is accepted by code: ctloc85258
Message-ID: <541B85B1.1080901@realsil.com.cn>
Date: Fri, 19 Sep 2014 09:24:01 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>
Subject: Re: [PATCH] mfd: rtsx: fix PM suspend for 5227 & 5249
References: <1411004156-9057-1-git-send-email-micky_ching@realsil.com.cn> <20140918045316.GB8740@lee--X1> <541A7286.1080008@realsil.com.cn> <20140919002101.GB29852@lee--X1>
In-Reply-To: <20140919002101.GB29852@lee--X1>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 08:21 AM, Lee Jones wrote:
> On Thu, 18 Sep 2014, micky wrote:
>
>> On 09/18/2014 12:53 PM, Lee Jones wrote:
>>> On Thu, 18 Sep 2014, micky_ching@realsil.com.cn wrote:
>>>
>>>> From: Micky Ching <micky_ching@realsil.com.cn>
>>>>
>>>> Fix rts5227&5249 failed send buffer cmd after suspend,
>>>> PM_CTRL3 should reset before send any buffer cmd after suspend.
>>>> Otherwise, buffer cmd will failed, this will lead resume fail.
>>>>
>>>> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
>>>> ---
>>>>   drivers/mfd/rts5227.c        |   19 +++++++++++++++++++
>>>>   drivers/mfd/rts5249.c        |    4 ++++
>>>>   drivers/mfd/rtsx_pcr.h       |    1 +
>>>>   include/linux/mfd/rtsx_pci.h |   12 ++++++++++++
>>>>   4 files changed, 36 insertions(+)
>>> I think you'll find you just broke the build.
>>>
>>> What happens when you compile these as modules?
>> I build as modules with no warning or error, did you find anything wrong?
> Yes, you don't export the functions.
>
> EXPORT_SYMBOL()
No need export symbol, all rts52xx.c and rtsx_pcr.c will build into a 
single rtsx_pci.ko file.
and we do not want these functions to be called in other place.
Because they are not a good interface, and may be changed in the future.

>

