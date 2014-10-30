Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161197AbaJ3U3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 16:29:24 -0400
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:34917 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933358AbaJ3U3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 16:29:24 -0400
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54529FA1.8000702@mev.co.uk>
Date: Thu, 30 Oct 2014 20:29:21 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] staging: comedi: don't allow write() on async command
 set up for "read"
References: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk> <1414672952-1587-6-git-send-email-abbotti@mev.co.uk> <DC148C5AA1CEBA4E87973D432B1C2D882600D3B7@P3PWEX4MB008.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D882600D3B7@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/10/14 18:07, Hartley Sweeten wrote:
> On Thursday, October 30, 2014 5:43 AM, Ian Abbott wrote:
[snip]
>>   	add_wait_queue(&async->wait_head, &wait);
>>   	on_wait_queue = true;
>> @@ -2146,6 +2150,10 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
>>   				retval = -EACCES;
>>   				break;
>>   			}
>> +			if (!(async->cmd.flags & CMDF_WRITE)) {
>> +				retval = -EINVAL;
>> +				break;
>> +			}
>
> Same question as with PATCH 4/7.
>
> Is this test needed in the while () loop. Also, are the s->busy tests needed here?

Yes, for similar reasons.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
