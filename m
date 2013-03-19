Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab3CSOVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:21:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab3CSOVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:21:52 -0400
Message-ID: <5148747C.9020803@redhat.com>
Date: Tue, 19 Mar 2013 10:21:48 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hpet, allow user controlled mmap for user processes
References: <51444171.1080905@ladisch.de> <1363609488-25250-1-git-send-email-prarit@redhat.com> <5148171D.10807@ladisch.de>
In-Reply-To: <5148171D.10807@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/19/2013 03:43 AM, Clemens Ladisch wrote:
> Prarit Bhargava wrote:
>> The CONFIG_HPET_MMAP Kconfig option exposes the memory map of the HPET
>> registers to userspace.  The Kconfig help points out that in some cases this
>> can be a security risk as some systems may erroneously configure the map such
>> that additional data is exposed to userspace.
>>
>> This is a problem for distributions -- some users want the MMAP functionality
>> but it comes with a significant security risk.  In an effort to mitigate this
>> risk, and due to the low number of users of the MMAP functionality, I've
>> introduced a kernel parameter, hpet_mmap_enable, that is required in order
>> to actually have the HPET MMAP exposed.
>>
>> [v2]: Clemens suggested modifying the Kconfig help text and making the
>> default setting configurable.
>>
>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>> Cc: Clemens Ladisch <clemens@ladisch.de>
> 
>> +++ b/Documentation/kernel-parameters.txt
>> +	hpet_mmap_enable [X86, HPET_MMAP] option to expose HPET MMAP to
>> +			 userspace.  By default this is disabled.
> 
> This now takes a value.
> 
>> +	int "Enable HPET MMAP access by default"
>> +	range 0 1
> 
> Shouldn't this be bool?

I'll fix those in v3.

> 
>> +	default 0
> 
> This breaks backwards compatibility.

Does backwards compatibility matter for something like?  I have no problem
setting it to 1 but I'm more curious from a general kernel point of view.

I'll change this in v3 as well.

P.


P.

> 
> 
> Regards,
> Clemens
