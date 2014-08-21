Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaHUIip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:38:45 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43861 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaHUIim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:38:42 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-b3-53f5b00fd2a5
Message-id: <53F5B00A.8020909@samsung.com>
Date: Thu, 21 Aug 2014 10:38:34 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC v4 15/21] media: Add registration helpers for V4L2 flash
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
 <1405087464-13762-16-git-send-email-j.anaszewski@samsung.com>
 <53CCF59E.3070200@iki.fi> <53DF9C2A.8060403@samsung.com>
 <20140811122628.GG16460@valkosipuli.retiisi.org.uk>
 <53E8C4BA.6050805@samsung.com>
 <20140814043436.GM16460@valkosipuli.retiisi.org.uk>
 <53EC7278.6040101@samsung.com>
 <20140820144110.GT16460@valkosipuli.retiisi.org.uk>
In-reply-to: <20140820144110.GT16460@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xq7r8G74GG+yayGKxccZ6Vov5R86x
	Wiz5uYvJ4mzTG3aLy7vmsFlsfbOO0aJnw1ZWizP7V7I5cHhM+b2R1ePw14UsHn1bVjF6fN4k
	F8ASxWWTkpqTWZZapG+XwJWxeMUSpoILXBW/v59gbGA8x9HFyMEhIWAi8fWFZxcjJ5ApJnHh
	3nq2LkYuDiGBpYwSE3tXMkI4Hxkl1h0+yApSxSugJfHiz3EWEJtFQFXi+Z1ONhCbTcBQ4ueL
	10wgtqhAhMSf0/ug6gUlfky+B1YvIqAm8XTTQxaQocwC1xklVrx7yA6SEBYIkFhweSYrxLbl
	zBLvu06BdXAKOEjsXnwJbBKzgLXEyknbGCFseYnNa94yT2AUmIVkySwkZbOQlC1gZF7FKJpa
	mlxQnJSea6RXnJhbXJqXrpecn7uJERLoX3cwLj1mdYhRgINRiYf35qIvwUKsiWXFlbmHGCU4
	mJVEeG36vgYL8aYkVlalFuXHF5XmpBYfYmTi4JRqYEy+1sf1SPnGhmWPnO58V3khv2rCh9vi
	/RPl64xamYJ/13PfviSwWin09NpLk17pWibpvSlRjrV653aEyWLhgTOtDpqppzZV70xlSV7w
	McjWc6qsYqt/pcyD94H1q8oW9i1Yp2gc27ecb/K8yS9F607/MUmVXaG6Jv9nYpVwns9zD4YS
	n/Wul5RYijMSDbWYi4oTARBE3wRSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On 08/20/2014 04:41 PM, Sakari Ailus wrote:
> Hi Jacek,

[...]
>>>>
>>>> LED Class Flash driver gains V4L2 Flash API when
>>>> CONFIG_V4L2_FLASH_LED_CLASS is defined. This is accomplished in
>>>> the probe function by either calling v4l2_flash_init function
>>>> or the macro of this name, when the CONFIG_V4L2_FLASH_LED_CLASS
>>>> macro isn't defined.
>>>>
>>>> If the v4l2-flash.c was to call the LED API directly, then the
>>>> led-class-flash module symbols would have to be available at
>>>> v4l2-flash.o linking time.
>>>
>>> Is this an issue? EXPORT_SYMBOL_GPL() for the relevant symbols should be
>>> enough.
>>
>> It isn't enough. If I call e.g. led_set_flash_brightness
>> directly from v4l2-flash.c and configure led-class-flash to be built as
>> a module then I am getting "undefined reference to
>> led_set_flash_brightness" error during linking phase.
>
> You should not. You also should change the check as (unless you've changed
> it already):
>
> #if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
>
> This will evaluate to non-zero if the macro arguent or the argument
> postfixed with "_MODULE" is defined.

I've missed this macro. Indeed, it is possible to avoid the need
for ops with it. I will fix it in the next version of the patch set.
Thanks for the hint.

Best Regards,
Jacek Anaszewski

