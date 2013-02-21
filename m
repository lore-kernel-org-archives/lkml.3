Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3BUX3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 18:29:32 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:54753 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3BUX33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 18:29:29 -0500
Message-ID: <5126ADD6.6040006@linaro.org>
Date: Thu, 21 Feb 2013 15:29:26 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] [RFC] usb: gadget: composite: Allow idVendor and other
 module_params to be writable
References: <1361485647-9439-1-git-send-email-john.stultz@linaro.org> <xa1tvc9lnutf.fsf@mina86.com>
In-Reply-To: <xa1tvc9lnutf.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 02:52 PM, Michal Nazarewicz wrote:
> On Thu, Feb 21 2013, John Stultz wrote:
>> In many cases, documentation around composite drivers suggest
>> setting the idVendor and other module params as follows:
>>
>> $ insmod g_ffs.ko idVendor=<ID> iSerialNumber=<string>
>>
>> However, this won't work if the driver is not compiled in as a
>> module, as the module_param permissions are S_IRUGO.
>>
>> Thus this patch changes the composite module_param permissions
>> to S_IRUGO|S_IWUSR to allow the module_params to be set at
>> runtime via /sys/modules/<driver>/parameters/
> If the driver is not compiled as a module, setting those variables won't
> work anyway.  Or am I missing something?

Huh. It worked in my testing. But maybe that's only the first time its 
set? I'll play around with it some more, but yea, on further thought, 
without unloading the module those values probably shouldn't change. 
Sorry for the confusion on my part here.

> You can, however, pass them on Linux command line (with some prefix
> which I can never remember).
That's right. Yea. g_ffs.idVendor and g_ffs.idProduct works for me. 
Thanks for the reminder!

> If you want to configure things at run-time without having to compile
> stuff as modules, you need to wait for the configfs based gadgets.

Heh. I thought I was just sorting things out between the out-of-tree 
android composite, ccg in staging, and functionfs. And now there's 
*another*?

Any details on configfs based gadget? Is there a git tree somewhere?

thanks
-john
