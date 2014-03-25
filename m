Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbaCYWRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:17:01 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:65200 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaCYWQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:16:59 -0400
Message-ID: <53320055.9080307@gmail.com>
Date: Tue, 25 Mar 2014 23:16:53 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Alexander Elbs <alex@segv.de>, Nicolas Pitre <nico@fluxnic.net>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        bonbons@linux-vserver.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: mvsdio: unhandled interrupt, mmc writes queuing up
References: <20140325192759.GJ29769@segv.de>
In-Reply-To: <20140325192759.GJ29769@segv.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 08:27 PM, Alexander Elbs wrote:
>> On Wed, 19 Mar 2014, Bruno Prémont wrote:
>>> Since upgrading my Sheevaplug from 3.7.2 to 3.13.6 (FDT) I'm seeing
>>>   mvsdio f1090000.mvsdio: unhandled interrupt status=0x8810 en=0x0000 pio=0
>>> at varied timings.
> 
> I have the same problem on my sheevaplug.
> 
>> It has been many years since I've looked at the code for this driver.  
>> I'm therefore including Thomas Petazzoni to the CC list as he appears to 
>> have been the most active since then.
>>
>> The reported status seems to indicate missing data in the context of a 
>> transfer with CMD12, and a CRC error ensued of course.
>>
>> At this point I'd suggest testing intermediate kernels between 3.7 and 
>> 3.13, and try bisection until you find the offending commit.
>>
>> [...]
>>> I get same results with 3.14-rc7.
>>
>> Excellent, that reduces the search space significantly.  You can do a 
>> git bisect directly.
> 
> I did a git bisect.
>   good: no message "unhandled interrupt"
>   bad: message above appears
>   skipped: unbootable kernel, usually stuck after the line "Uncompressing Linux". 
> 
> So far I am down to a few commits after 3.11.
> 
> $ git bisect view --oneline
> 2326f04 (refs/bisect/bad) ARM: kirkwood: convert to DT irqchip and clocksource

Can you please try the patches contained in [1]?

They have been Acked-by Jason Cooper, but I guess we simply lost
track of them.

Sebastian

[1] https://lkml.org/lkml/2013/11/15/276

