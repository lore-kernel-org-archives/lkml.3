Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbaEMWLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:11:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46464 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310AbaEMWLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:11:20 -0400
Message-ID: <53729873.2030805@zytor.com>
Date: Tue, 13 May 2014 15:10:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
References: <20140509191914.GA7286@jtriplet-mobl1> <9233735.5FfZoZovqP@wuerfel> <536D406D.2080508@zytor.com> <4366326.1D6xUnlac7@wuerfel> <536D46AD.3070608@zytor.com> <20140509223837.GB5725@thin>
In-Reply-To: <20140509223837.GB5725@thin>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 03:38 PM, Josh Triplett wrote:
> On Fri, May 09, 2014 at 02:20:45PM -0700, H. Peter Anvin wrote:
>> On 05/09/2014 02:12 PM, Arnd Bergmann wrote:
>>>
>>>> However, if we're going to have these devices I'm wondering if having
>>>> /dev/portw and /dev/portl (or something like that) might not make sense,
>>>> rather than requiring a system call per transaction.
>>>
>>> Actually the behavior of /dev/port for >1 byte writes seems questionable
>>> already: There are very few devices on which writing to consecutive
>>> port numbers makes sense. Normally you just want to write a series
>>> of bytes (or 16/32 bit words) into the same port number instead,
>>> as the outsb()/outsw()/outsl() functions do.
>>>
>>
>> Indeed.  I missed the detail that it increments the port index; it is
>> virtually guaranteed to be bogus.
> 
> Exactly.  It might make sense to have ioport8/ioport16/ioport32 devices
> that accept arbitrary-length reads and writes (divisible by the size)
> and do the equivalent of the string I/O instructions outs/ins, but for
> the moment I'd like to add the single device that people always seem to
> want and can't get from /dev/port.  If someone's doing enough writes
> that doing a syscall per in/out instruction seems like too much
> overhead, they can write a real device driver or use ioperm/iopl.
> 

I really have a problem with the logic "our current interface is wrong,
so let's introduce another wrong interface which solves a narrow use
case".  In some ways it would actually be *better* to use an ioctl
interface on /dev/port in that case...

	-hpa



