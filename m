Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbaE2NjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:39:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52167 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757079AbaE2NjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:39:03 -0400
Message-ID: <5387385B.1030203@zytor.com>
Date: Thu, 29 May 2014 06:38:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: josh@joshtriplett.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
References: <20140509191914.GA7286@jtriplet-mobl1> <63645237.lSKEVJUKkQ@wuerfel> <53865820.7010309@zytor.com> <16228376.RHijyT1ZPk@wuerfel>
In-Reply-To: <16228376.RHijyT1ZPk@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 02:26 AM, Arnd Bergmann wrote:
> On Wednesday 28 May 2014 14:41:52 H. Peter Anvin wrote:
>> On 05/19/2014 05:36 AM, Arnd Bergmann wrote:
>>>
>>> My feeling is that all devices we can think of fall into at least one
>>> of these categories:
>>>
>>> * legacy PC stuff that needs only byte access
>>> * PCI devices that can be accessed through sysfs
>>> * devices on x86 that can be accessed using iopl
>>>
>>
>> I don't believe PCI I/O space devices can be accessed through sysfs, but
>> perhaps I'm wrong?  (mmapping I/O space is not portable.)
> 
> The interface is there, both a read/write and mmap on the resource
> bin_attribute. But it seems you're right, neither of them is implemented
> on all architectures.
> 
> Only powerpc, microblaze, alpha, sparc and xtensa allow users to mmap
> I/O space, even though a lot of others could. The read-write interface
> is only defined for alpha, ia64, microblaze and powerpc.
> 

And how is that read/write interface defined?  Does it have the same
silly handling of data sizes?

	-hpa


