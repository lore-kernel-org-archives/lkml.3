Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbaEIUye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:54:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51393 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189AbaEIUyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:54:31 -0400
Message-ID: <536D406D.2080508@zytor.com>
Date: Fri, 09 May 2014 13:54:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
References: <20140509191914.GA7286@jtriplet-mobl1> <9233735.5FfZoZovqP@wuerfel>
In-Reply-To: <9233735.5FfZoZovqP@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 12:58 PM, Arnd Bergmann wrote:
> On Friday 09 May 2014 12:19:16 Josh Triplett wrote:
> 
>> +	if (!access_ok(VERIFY_WRITE, buf, count))
>> +		return -EFAULT;
>> +	if (port > 65535)
>> +		return 0;
> 
> This should probably test against IO_SPACE_LIMIT, which may be zero,
> something larger than 65536 or even ULONG_MAX, depending on the
> architecture.
> 
> In cases where this IO_SPACE_LIMIT is zero or ULONG_MAX, we should
> probably disallow access completely. The former case is for architectures
> that don't have any I/O ports, the other is either a mistake, or is
> used when inb is defined as readb, and the port numbers are just virtual
> addresses.
> 

PCI supports a 32-bit I/O address space, so if the architecture permits
it, having a 32-bit I/O space is perfectly legitimate.

It is worth noting that /dev/port has the same problem.

However, if we're going to have these devices I'm wondering if having
/dev/portw and /dev/portl (or something like that) might not make sense,
rather than requiring a system call per transaction.

Also, x86 supports unaligned I/O port references, but not all
architectures do.  On the other hand, x86 also supports ioperm().

	-hpa



