Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaFCKRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:17:37 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:48939 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaFCKRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:17:36 -0400
Message-ID: <538DA0BD.5080208@mutualink.net>
Date: Tue, 03 Jun 2014 06:17:33 -0400
From: Mike Remski <mremski@mutualink.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: ftdi_sio BUG: NULL pointer dereference
References: <538C8963.4010909@mutualink.net> <20140602143347.GA1902@localhost> <538C953B.9020304@mutualink.net> <20140602154036.GA8662@localhost> <538CA020.4070204@mutualink.net> <20140602162027.GB13790@localhost> <538CA54C.4040803@mutualink.net> <20140602164957.GC13790@localhost> <538CB049.9020805@mutualink.net> <20140602174630.GD13790@localhost>
In-Reply-To: <20140602174630.GD13790@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 01:46 PM, Johan Hovold wrote:
> On Mon, Jun 02, 2014 at 01:11:37PM -0400, Mike Remski wrote:
>> On 06/02/2014 12:49 PM, Johan Hovold wrote:
>>> On Mon, Jun 02, 2014 at 12:24:44PM -0400, Mike Remski wrote:
>>>> On 06/02/2014 12:20 PM, Johan Hovold wrote:
>>>>> On Mon, Jun 02, 2014 at 12:02:40PM -0400, Mike Remski wrote:
>>>>>> On 06/02/2014 11:40 AM, Johan Hovold wrote:
>>>>>>> [ Please avoid top-posting. ]
>>>>>>>
>>>>>>> On Mon, Jun 02, 2014 at 11:16:11AM -0400, Mike Remski wrote:
>>>>> The third interface lacks endpoints and crashes the ftdi_sio driver.
>>>>> This shouldn't happen (even if you're forcing the wrong driver to bind),
>>>>> so I'll fix it up if still broken in v3.15-rc.
>>>>>
>>>> Johan,
>>>> Thanks again.  Yes, the device does indeed have an FTDI embedded in it;
>>>> they've programmed in their own ids.  They supply a Windows driver for
>>>> it, but that doesn't do me any good.  :)
>>> Not just their own ID's it seems.
>>>
>>> Have you tried just using the cdc-acm driver? The ports should up as
>>> /dev/ttyACMx instead of ttyUSBx.
>>>
>> Not yet, next on the list.
> You really should try this before anything else. :)
>
>> I'm suspecting that bNumEndpoints == 0 is causing endpoint[1].desc to
>> stay at NULL (line 1567 in 3.1.4.5 source), so by the time it gets used
>> later on, I'm hitting the NULL dereference.
> Yeah, the code is obviously broken (also in v3.15-rc). It should
> probably work to just return from ftdi_set_max_packet_size if
> num_endpoints is 0 if you want to try that (or you can use your ?:
> construct), but I should be able to fix this up properly on Wednesday.
>
> Thanks,
> Johan
Johan,
I had a chance to play around with code over in ftdi_sio.c;   adding this:

         if (!num_endpoints) {
                 return;
         }
  after the "Number of endpoints" message gets rid of the crash, 
everything looks to be working correctly.

Thanks again

m

-- 
Office: (978)401-4032 (x123 internally)
Cell: (603) 759-6953

