Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaL2HaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 02:30:14 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17571 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaL2HaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 02:30:08 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-54-54a102fea2a4
Message-id: <54A102FC.4000307@samsung.com>
Date: Mon, 29 Dec 2014 08:30:04 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: udc-core: call udc_stop() before gadget unbind
References: <1418390248-6254-1-git-send-email-r.baldyga@samsung.com>
 <20141215051317.GC25410@shlinux2> <548EB262.6040208@samsung.com>
 <20141222163430.GH12815@saruman> <54990CE7.1030008@samsung.com>
 <20141223183120.GG9147@saruman>
In-reply-to: <20141223183120.GG9147@saruman>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t/xK7r/mBaGGDycbGhx8H69RfPi9WwW
	l3fNYbNYtKyV2YHFY//cNewex29sZ/L4vEkugDmKyyYlNSezLLVI3y6BK2Ndwyu2gimCFR9X
	zmZrYPzF28XIySEhYCLx4eJtRghbTOLCvfVsXYxcHEICSxklFm5/wgrhfGSUWPHzEFMXIwcH
	r4CWxM9bmiANLAKqEvO3TWYGsdkEdCS2fJ8ANkhUIELiw6qvbCA2r4CgxI/J91hAbBEBAYn1
	Ly6xg4xhFoiU2NIgChIWFgiQ+PzhBtSq14wSvQf6wOo5gWb2vgNJgNTrSdy/qAUSZhaQl9i8
	5i3zBEaBWUg2zEKomoWkagEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkGD9uoNx6TGr
	Q4wCHIxKPLwJJxaECLEmlhVX5h5ilOBgVhLhvf4bKMSbklhZlVqUH19UmpNafIiRiYNTqoFR
	f2nb638vYi4p6VT4nBGIrX2y5d2zNwXLD9vqBhy5vylz7sZDUgKJ1bwBnMp1KjrPIpeukWKe
	E/i+57ZY+6PvKm/cbk5M4J1bya4vVpl3yX9GWsNRz6XHT7tzVrHdkK91c/jF8X9Sx5f+deZu
	5qJnp2zpmZJ288vOUw/t/hU3rrouzSVwf8F0JZbijERDLeai4kQAn8R9tjQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 12/23/2014 07:31 PM, Felipe Balbi wrote:
> On Tue, Dec 23, 2014 at 07:34:15AM +0100, Robert Baldyga wrote:
>> On 12/22/2014 05:34 PM, Felipe Balbi wrote:
>>> On Mon, Dec 15, 2014 at 11:05:22AM +0100, Robert Baldyga wrote:
>>>> On 12/15/2014 06:13 AM, Peter Chen wrote:
>>>>> On Fri, Dec 12, 2014 at 02:17:28PM +0100, Robert Baldyga wrote:
>>>>>> As usb function drivers assumes that all usb request will be completed
>>>>>> before function unbind call, we should supply such behavior. In some
>>>>>> cases ep_disable() won't kill all request effectively, because some
>>>>>> IN requests can be in running state. In such situation it's possible
>>>>>> to have unbind function called before last request completion, which
>>>>>> can cause problems.
>>>>>
>>>>> Doesn't the function's disable/unbind should call usb_ep_dequeue to make
>>>>> sure the transfer has ended?
>>>>
>>>> USB function drivers like ECM or HID surely doesn't. It looks like
>>>> there's assumption that all requests will be completed by UDC driver.
>>>
>>> that's a bug on those drivers :-)
>>
>> So we can't make assumptions that requests will be completed in
>> ep_disable()?
> 
> oh, no you can. I misread it.
> 
>>>> Function ep_disable() should complete requests in hardware driver, but
>>>> at least in DWC2 driver not all requests are completed at this stage
>>>
>>> and that's a bug on dwc2 :-)
>>
>> I have already found that out. Another UDC drivers simply kill all
>> request without waiting for currently running, so I did the same in
>> DWC2. Here is my patch:
>> http://www.spinics.net/lists/linux-usb/msg118698.html
> 
> should be in my pull request already.

It looks like you applied wrong patch. I meant patch titled "drivers:
usb: dwc2: remove 'force' parameter from kill_all_requests()" is the
latest and complete fix. The patch you have applied named "usb: dwc2:
gadget: kill requests with 'force' in s3c_hsotg_udc_stop()" do not solve
problem completely without changes in udc-core, which we concluded are
not acceptable.

Sorry for the mess. I understand that titles of both patches are
confusing similar.

Best regards,
Robert Baldyga
