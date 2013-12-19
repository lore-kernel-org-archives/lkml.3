Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3LSGVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 01:21:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60412 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab3LSGVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 01:21:53 -0500
Message-ID: <52B29079.2040704@ti.com>
Date: Thu, 19 Dec 2013 11:51:45 +0530
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Huang Rui <ray.huang@amd.com>, <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] usb: usbtest: Always clear halt else further tests
 will fail
References: <1387361411-15139-1-git-send-email-rogerq@ti.com> <1387361411-15139-2-git-send-email-rogerq@ti.com> <20131219040146.GC19091@hr-dev.amd.com> <20131219054651.GD19091@hr-dev.amd.com>
In-Reply-To: <20131219054651.GD19091@hr-dev.amd.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 11:16 AM, Huang Rui wrote:
> On Thu, Dec 19, 2013 at 12:01:47PM +0800, Huang Rui wrote:
>> On Wed, Dec 18, 2013 at 03:40:11PM +0530, Roger Quadros wrote:
>>> In test_halt() we set an endpoint halt condition and return on halt verification
>>> failure, then the enpoint will remain halted and all further tests related
>                       ^^^^^^^
>>> to that enpoint will fail. This is because we don't tackle endpoint halt error condition
>             ^^^^^^^
> BTW, please fix these typo.

Hi Rui,

These patches have been already applied to Greg's usb tree without your Ack's or the typo fix.

Greg,

do you want me to resend the patches?

cheers,
-roger

> 
> Thanks,
> Rui
> 
>>> in any of the tests. To avoid that situation, make sure to clear the
>>> halt condition before exiting test_halt().
>>>
>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>> Reviewed-by: Felipe Balbi <balbi@ti.com>
>>
>> Acked-by: Huang Rui <ray.huang@amd.com>
>>
>>> ---
>>>  drivers/usb/misc/usbtest.c | 11 ++++++++++-
>>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
>>> index 6294e1b..300b726 100644
>>> --- a/drivers/usb/misc/usbtest.c
>>> +++ b/drivers/usb/misc/usbtest.c
>>> @@ -1545,8 +1545,17 @@ static int test_halt(struct usbtest_dev *tdev, int ep, struct urb *urb)
>>>  		return retval;
>>>  	}
>>>  	retval = verify_halted(tdev, ep, urb);
>>> -	if (retval < 0)
>>> +	if (retval < 0) {
>>> +		int ret;
>>> +
>>> +		/* clear halt anyways, else further tests will fail */
>>> +		ret = usb_clear_halt(urb->dev, urb->pipe);
>>> +		if (ret)
>>> +			ERROR(tdev, "ep %02x couldn't clear halt, %d\n",
>>> +			      ep, ret);
>>> +
>>>  		return retval;
>>> +	}
>>>  
>>>  	/* clear halt (tests API + protocol), verify it worked */
>>>  	retval = usb_clear_halt(urb->dev, urb->pipe);
>>> -- 
>>> 1.8.3.2
>>>
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

