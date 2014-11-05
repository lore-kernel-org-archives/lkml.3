Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaKEJsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:48:54 -0500
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:57676 "EHLO
	smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884AbaKEJsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:48:51 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <5459F281.2010302@mev.co.uk>
Date: Wed, 05 Nov 2014 09:48:49 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] staging: comedi: per-file read/write subdevice choice
References: <1415124541-13648-1-git-send-email-abbotti@mev.co.uk> <DC148C5AA1CEBA4E87973D432B1C2D8826023C34@P3PWEX4MB008.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8826023C34@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 18:44, Hartley Sweeten wrote:
> On Tuesday, November 04, 2014 11:09 AM, Ian Abbott wrote:
>> This series of patches adds a couple of ioctl codes to the Comedi core
>> to allow the current "read" and "write" subdevice to be changed after
>> opening the comedi device.  The current read and write subdevice
>> information is stored in file private data allocated for the lifetime of
>> the file object, so the notion of current "read" and "write" subdevice
>> is local to the file object and does not alter anything in the main
>> control structure for the comedi device.  An extra level of indirection
>> is now required to access the main control structure.
>>
>> I've tested the multiple "read" subdevice case using a modified version
>> of the "comedi_test" module (modifying it to clone the existing AI
>> subdevice), and a modified version of the "comedi_test" application
>> (part of the "comedilib" installation) modified to use the new ioctls.
>> There isn't any support in comedilib itself yet.
>>
>> 1) staging: comedi: prepare support for per-file read and write
>>     subdevices
>> 2) staging: comedi: add ioctls to set per-file read and write subdevice
>>
>>   drivers/staging/comedi/comedi.h          |   2 +
>>   drivers/staging/comedi/comedi_compat32.c |   2 +
>>   drivers/staging/comedi/comedi_fops.c     | 217 +++++++++++++++++++++++++++----
>>   3 files changed, 196 insertions(+), 25 deletions(-)
>
> Ian,
>
> If I understand this correctly, the user can now open the "comediX"
> device which will give then access to the default dev->read_subdev
> and dev->write_subdev. They can then use the new ioctls to change
> the read/write subdevice and use them without having the open the
> "comediX_subdY" devices.
>
> If this is correct it seems like a good idea.

That's correct.

> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Thanks for the review!

> Also, does this mean we can get rid of comedi_alloc_subdevice_minor()
> and the "comediX_sudbY" stuff?

That would be a bit premature at this stage.  Maybe in a year or two.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
