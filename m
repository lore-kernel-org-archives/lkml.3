Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbaLWTjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 14:39:20 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:44083 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbaLWTjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 14:39:17 -0500
Message-ID: <5499C4E2.8090407@ridgerun.com>
Date: Tue, 23 Dec 2014 13:39:14 -0600
From: Carsten Behling <carsten.behling@ridgerun.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: balbi@ti.com, linux-kernel@vger.kernel.org
Subject: Re: usb: musb: Scheduling of interrupt endpoints
References: <54947E99.4010908@ridgerun.com> <5499835B.508@ridgerun.com>
In-Reply-To: <5499835B.508@ridgerun.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following comment can be found in 'musb_schedule()':

'* REVISIT what we really want here is a regular schedule tree
  * like e.g. OHCI uses.'

So I assume the best practice would be to make an implementation based
on the code in in ohci-q.c. And it would be waste of time to port the old
interrupt endpoint scheduling feature of TI.

Am I right?

On 12/23/2014 08:59 AM, Carsten Behling wrote:
> Would it help if I send a patch as a suggestion and as basis for 
> discussion?
>
> On 12/19/2014 01:38 PM, Carsten Behling wrote:
>> Hi all,
>>
>> Long time ago, TI shipped a kernel named 
>> linux-2.6.32.17-psp03.01.01.39 with an additional kernel option
>> for scheduling of interrupt endpoints.
>>
>> AFAIK, this seems to be the only possibility to attach more that 4 in 
>> endpoints to MUSB (at least on a DM368).
>>
>> This feature reserves one hardware endpoint unit to time schedule 
>> interrupt in endpoints based
>> on its bInterval value triggered by the SOF interrupt.
>>
>> I didn't find any discussion about adding such a feature to the 
>> mainline kernel.
>> IMHO, this feature is absolutely necessary. But there may be reasons, 
>> not to add it (e.g. CPU load).
>>
>> Please let me know your thoughts and ideas.
>>
>> Best regards
>> -Carsten
>>
>

