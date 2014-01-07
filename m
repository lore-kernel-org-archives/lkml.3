Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaAGPBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:01:54 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:11805 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaAGPBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:01:47 -0500
X-AuditID: cbfec37b-b7f216d000006a8d-06-52cc16da6187
Message-id: <52CC1691.9040603@samsung.com>
Date: Tue, 07 Jan 2014 08:00:33 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Joerg Roedel <joro@8bytes.org>
Cc: akpm@linux-foundation.org, alexander.h.duyck@intel.com,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] dma-debug: enhance dma_debug_device_change() to check
 for mapping errors
References: <1384376168-2148-1-git-send-email-shuah.kh@samsung.com>
 <20131230141511.GC2799@8bytes.org> <52C700BC.1010200@samsung.com>
 <20140107142625.GC2742@8bytes.org>
In-reply-to: <20140107142625.GC2742@8bytes.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hP91bYmeCDOYdNreYs34Nm8XJZb+Z
	LTpnb2C3uLxrDpvF158ODqweTw7OY/LYOesuu8fiPS+ZPE7M+M3i8XmTXABrFJdNSmpOZllq
	kb5dAldGx4IzzAX93BX3+ncxNzC+4Ohi5OSQEDCRmHbiBCOELSZx4d56ti5GLg4hgWWMEt+2
	7GeCcHqZJK5NOMUKUiUksJFR4uYdjy5GDg5eAS2JZ19NQMIsAqoS61//ARvEJqAu8fn1DnaI
	cjmJpiWrmUFsUYEIiVdnJ7KA2LwCghI/Jt8Ds0UElCSuf25lBdnFLDCFUaK9YTrYLmGBJIlp
	8+dDHbEG6KIJz8CmcgroS9y/dJUNxGYWsJZYOWkbI4QtL7F5zVtmiM3KEn8un2ICOVRCQFFi
	+2qrCYwis5DsnoWkexaS7gWMzKsYxUqLkwuKk9JTK4z0ihNzi0vz0vWS83M3MUJipnoH492v
	NocYBTgYlXh4X+w9FSTEmlhWXJl7iFGCg1lJhJf5xukgId6UxMqq1KL8+KLSnNTiQ4xMHJxS
	DYzmL7ha1JjOl6ssF+fPdZxuaO7YpbqY6UDiogOfNkRNSO7cGWYzm3/7hg1hCyeenqlZe2+G
	lobMtD75yQskZ0z68Kta8FD9Ol5546V/lzfMzc1bzycTs2HHjc5twbE+7dITvjiuz/blesF1
	IrQqIqngtISSRFzC1VzD4BdKlxX/XJ90+az/u89KLMUZiYZazEXFiQA8wRjQdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 07:26 AM, Joerg Roedel wrote:
> On Fri, Jan 03, 2014 at 11:26:04AM -0700, Shuah Khan wrote:
>> On 12/30/2013 07:15 AM, Joerg Roedel wrote:
>>> I think it is better to check for this in a seperate function and use
>>> err_printk instead of dev_warn in the end to print the errors.
>>> The new function can then be called in the dma_debug_device_change
>>> callback like device_dma_allocations is.
>>>
>>
>> I did explore separate function option and backed off from it since
>> the new routine will have to duplicate what device_dma_allocations()
>> does except that it checks for entry->map_err_type.
>>
>> I still have the patch that does that saved away. If you still
>> prefer that approach, I can rework the patch and send it.
>
> You can get rid of the code duplication by defining for_each macros for
> the list traversals. So I would still prefer to have this check in a
> seperate function.
>
>
> 	Joerg
>
>

Joerg,

This patch and a follow-on cocinelli warning fix patch are in 
linux-next. Would you like me to send a patch relative to the change in 
linux-next or cut a new patch against the latest Linus's git. I can go 
either way. We just have to remember to drop those two patches from 
linux-next.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
