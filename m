Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaKDL3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:29:43 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24861 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaKDL3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:29:42 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfec7f4-b7f6c6d00000120b-4b-5458b8a3ef9b
Content-transfer-encoding: 8BIT
Message-id: <5458B8A3.4050100@samsung.com>
Date: Tue, 04 Nov 2014 12:29:39 +0100
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
To: Neil Zhang <zhangwm@marvell.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb: gadget: don't create new string_container if already
 exist
References: <1414496039-5655-1-git-send-email-zhangwm@marvell.com>
 <544F95C3.2080306@samsung.com>
 <9034CBD80F070943B59700D7F8149ED9024ED2A5B7@SC-VEXCH4.marvell.com>
In-reply-to: <9034CBD80F070943B59700D7F8149ED9024ED2A5B7@SC-VEXCH4.marvell.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xy7qLd0SEGCx4ZWlx8H69RfPi9WwW
	l3fNYbNYtKyV2WL1xSXsDqwe++euYfeYvPAis8fxG9uZPD5vkgtgieKySUnNySxLLdK3S+DK
	uNW8mrlgInfF68OtrA2Mkzi7GDk5JARMJN4e2McKYYtJXLi3nq2LkYtDSGApo8ScxavZQBK8
	AoISPybfY+li5OBgFpCXOHIpGyTMLGAm8ahlHTNE/WdGiQ8dr5lAangFtCRutRuA1LAIqErM
	nHydGcRmEzCW2HuwgxHEFhUIk9i+ZgJYXERgAaPEhmfeEDPjJDaf/8YCYgsD1TRsnQA1fwWj
	xK2pzWCHcgr4S8yd2ss4gVFgFpLzZiGcNwvJeQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn
	525ihITwlx2Mi49ZHWIU4GBU4uHNUI8IEWJNLCuuzD3EKMHBrCTCu7oKKMSbklhZlVqUH19U
	mpNafIiRiYNTqoGxvUcw1NNkqp11An/Q/BUvVU4mHvuTdV2vd6fCjWX1nJz2czukbl3fxmvX
	s0lNkG1NQufvr+/mFnWpbF+kFPV7sUpu0YKZfcd2nkj9U1rkttXxRpdZWHFKRdnFa06N5yfd
	+Pk/X1fdcuG9RbOWquprX81kZ6l62SSbsP9VVtFXj82Goo361c5KLMUZiYZazEXFiQBJ+PUJ
	PwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 04.11.2014 o 12:05, Neil Zhang pisze:
>
>> -----Original Message-----
>> From: Andrzej Pietrasiewicz [mailto:andrzej.p@samsung.com]
>> Sent: 2014年10月28日 21:10
>> To: Neil Zhang; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
>> Cc: balbi@ti.com; gregkh@linuxfoundation.org
>> Subject: Re: [PATCH] usb: gadget: don't create new string_container if already
>> exist
>>

<snip>

>>
>> The problem you are describing does not exist in mainline kernel, where
>> functions are always unbound as part of the whole gadget's unbind - regardless
>> of whether it is a legacy gadget or configfs-composed gadget. When the whole
>> gadget is unbound, composite_dev_cleanup() is called which zeroes cdev-
>>> next_string_id and frees all gadget strings containers.
>>
>
> Yes, you are right that the current mainline won't suffer this issue.
> But it will be needed if we want to implement similar features like android do.

What features do you think of?
Mainlining the android gadget has been attempted a number of times
and is unlikely to succeed.

A configurable gadget can be composed with configfs interface,
so no need to add anything new.

That said, I think that the proper way of eliminating the problem
described is freeing the resources on function unbind rather than
preventing composite from allocating more (duplicate) resources
on bind, which your patch does.

AP
