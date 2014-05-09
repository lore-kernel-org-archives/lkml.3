Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbaEIVVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:21:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51690 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757079AbaEIVVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:21:05 -0400
Message-ID: <536D46AD.3070608@zytor.com>
Date: Fri, 09 May 2014 14:20:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Josh Triplett <josh@joshtriplett.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
References: <20140509191914.GA7286@jtriplet-mobl1> <9233735.5FfZoZovqP@wuerfel> <536D406D.2080508@zytor.com> <4366326.1D6xUnlac7@wuerfel>
In-Reply-To: <4366326.1D6xUnlac7@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 02:12 PM, Arnd Bergmann wrote:
> 
>> However, if we're going to have these devices I'm wondering if having
>> /dev/portw and /dev/portl (or something like that) might not make sense,
>> rather than requiring a system call per transaction.
> 
> Actually the behavior of /dev/port for >1 byte writes seems questionable
> already: There are very few devices on which writing to consecutive
> port numbers makes sense. Normally you just want to write a series
> of bytes (or 16/32 bit words) into the same port number instead,
> as the outsb()/outsw()/outsl() functions do.
> 

Indeed.  I missed the detail that it increments the port index; it is
virtually guaranteed to be bogus.

	-hpa


