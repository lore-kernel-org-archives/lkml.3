Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaFXMQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:16:41 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20847 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaFXMQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:16:39 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-4b-53a96c24a7af
Message-id: <53A96C23.8040800@samsung.com>
Date: Tue, 24 Jun 2014 14:16:35 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com
Subject: Re: [PATCH] usb: gadget: add claimed field in struct usb_ep
References: <1402906836-12733-1-git-send-email-r.baldyga@samsung.com>
 <20140619150853.GG23782@saruman.home> <53A7C42F.1060603@samsung.com>
 <20140623182725.GD5073@saruman.home>
In-reply-to: <20140623182725.GD5073@saruman.home>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t/xa7oqOSuDDVb+17CY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9kd2Dz2z13D7tG3ZRWjx/Eb25k8Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mr4+G4hc8Fm7oobV1+zNDBO5exi5OSQEDCR+L3nOQuELSZx4d56ti5GLg4hgaWMEjM2
	/oJyPjJKzDtxmRGkildAS2JiUxNYB4uAqsSMN8/YQGw2AR2JLd8ngNWICkRI3Gs8zApRLyjx
	Y/I9sHoRAQGJ9S8usYMMZRboYpRY//UkkMPBISzgInH8kwjEss2MEt0/NoMN5RQwlPja+hqs
	mRlowf7WaWwQtrzE5jVvmScwCsxCsmMWkrJZSMoWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dL
	zs/dxAgJ6a87GJceszrEKMDBqMTDW7FjRbAQa2JZcWXuIUYJDmYlEd4vcSuDhXhTEiurUovy
	44tKc1KLDzEycXBKNTCqL/lU8YWxapffaTMZj923Jlbe6F7QutH2cf62Nm+tY0qXtlmlp7f+
	aetazDA7Z39QYCbPTINWlwC36hdczUzMnRbf3xjFJOalpvy8vCDFtZL5rcv8+Wv0fV/PqNoV
	v/mcs5BMc+++2/u+aryX37676diBPYVMjlL321RYqp7abIxwPlD/8J4SS3FGoqEWc1FxIgCf
	WWEKRwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 08:27 PM, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Jun 23, 2014 at 08:07:43AM +0200, Robert Baldyga wrote:
>> On 06/19/2014 05:08 PM, Felipe Balbi wrote:
>>> On Mon, Jun 16, 2014 at 10:20:36AM +0200, Robert Baldyga wrote:
>>>> This field allows to mark ep as claimed in more clear way. Claiming
>>>> endpoint by setting driver_data to non-null value is leaky solution
>>>> and makes code unreadable.
>>>
>>> how come ? How can it be unreadable ? how can it be leaky ?
>>>
>>
>> What if gadget will not assign any value to driver_data (just like
>> Gadget Zero do)? Endpoint will be seen as not used, and autoconfig will
> 
> huh ??? The gadget isn't the endpoint user, the function is. Look at
> f_sourcesink.c and f_loopback.c. If the function doesn't set anything to
> driver_data, then that's a bug on the function which needs fixing.
> 
> Moreover, if there's a function which doesn't set driver_data, we could
> just as well have a function which doesn't set "claimed", so the problem
> is the same.
> 

I mean the function, not the gadget. Sorry for confusion.
Mechanism I developed marks endpoint as claimed *inside autoconfig
function*. It's significant difference, because there's not possible to
forget to mark that endpoint is claimed. When endpoint is returned from
autoconfig function, it belongs to function, and the function doesn't
need to do anything to claim obtained endpoint - it's already done.
