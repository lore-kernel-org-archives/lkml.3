Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaKRRwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:52:19 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:62463 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbaKRRwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:52:18 -0500
Message-ID: <546B874B.8060700@linaro.org>
Date: Tue, 18 Nov 2014 12:52:11 -0500
From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
CC: felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH]  usb: gadget: USB3 support to the legacy printer driver
References: <546A829A.8030106@linaro.org> <20141118003028.GA11280@saruman> <546B5578.8040809@linaro.org> <20141118151753.GB8223@saruman>
In-Reply-To: <20141118151753.GB8223@saruman>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 10:17 AM, Felipe Balbi wrote:
> Hi,
>
> On Tue, Nov 18, 2014 at 09:19:36AM -0500, Jorge Ramirez-Ortiz wrote:
>> Hi Felipe/Greg
>>
>> Thanks for your comments on my previous attempt.
>> I think I addressed them here.
> no you haven't. Read Documentation/SubmittingPatches, read the mailing
> list archives and you'll see your basic mistake.

For this fundamental mistake, could you not just share with me what I am missing?
I don't see anything wrong other than maybe adding more maintainers to the DL as per the scripts since the feature itself is self explanatory.

     

> you have no clue what these mean, do you ? How about reading the USB
> specification of even http://www.beyondlogic.org/usbnutshell/usb1.shtml


Unfortunately I do.
It was easier to temporarily hack the driver code for a test - while I was at it - rather than modifying the host code.
Since you asked for them, I though you would read the logs and wonder where the funny ids where coming from.
That hack above would have given you an answer: so I kind of know what the ids are for. honestly.
anyway, will send the new logs - it took me a while to find and modify the host test code.


>
> do you want to debug that and find the culprit since you're already at
> it ?

probably: I still need to get used to this process, thanks for bearing with me on this.

I spoke to Ricardo Ribalda three months ago while I was doing this stuff.
but yes, I might work on this -after I finish with this patch!- since I have access to the hardware locally.


>
>>
>> 3) Patch:
>> ---------
>>
>>
>>
>> From 9b5ee9330c5c02cf51328c350036c1dac998b732 Mon Sep 17 00:00:00 2001
>> From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
>> Date: Thu, 25 Sep 2014 16:17:20 -0400
>> Subject: [PATCH 2/3] usb: gadget: add USB3 support to the printer driver
>>
>> Add SS descriptors to support the capabilities provided by USB3 controller
>> drivers; unit tests run using a PLX 3380 [max transfer speed measured of 1Gbps]
>>
>> This driver shall fallback to lower operating modes when the higher ones are
>> not available.
>>
>> Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
>> ---
>>  drivers/usb/gadget/legacy/printer.c | 65 +++++++++++++++++++++++++++++++++----
>>  1 file changed, 59 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/legacy/printer.c b/drivers/usb/gadget/legacy/printer.c
>> index 6474081..456730b 100644
>> --- a/drivers/usb/gadget/legacy/printer.c
>> +++ b/drivers/usb/gadget/legacy/printer.c
>> @@ -208,6 +208,43 @@ static struct usb_descriptor_header *hs_printer_function[] = {
>>      NULL
>>  };
>>  
>> +/*
>> + * Added endpoint descriptors for 3.0 devices
>> + */
>> +
>> +static struct usb_endpoint_descriptor ss_ep_in_desc = {
>> +    .bLength =              USB_DT_ENDPOINT_SIZE,
>> +    .bDescriptorType =      USB_DT_ENDPOINT,
>> +    .bmAttributes =         USB_ENDPOINT_XFER_BULK,
>> +    .wMaxPacketSize =       cpu_to_le16(1024),
>> +};
>> As mentioned above, using the usb338x driver from PLX instead of the net2280 from
>> kernel.org, the effective file transfer rate increases 1Gbps.
>>
> all your tabs have been converted into spaces. Perhaps try:
>
> 	$ git help send-email
>
> and figure out how to use that ?
>

crap. really sorry about this!

