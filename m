Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab3ARKq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 05:46:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab3ARKqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 05:46:24 -0500
Message-ID: <50F927A5.5060409@redhat.com>
Date: Fri, 18 Jan 2013 10:44:53 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Carlos O'Donell" <carlos@systemhalted.org>
CC: Mike Frysinger <vapier@gentoo.org>, David Miller <davem@davemloft.net>,
        libc-alpha@sourceware.org, bhutchings@solarflare.com,
        yoshfuji@linux-ipv6.org, amwang@redhat.com, tmb@mageia.org,
        eblake@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, libvirt-list@redhat.com, tgraf@suug.ch,
        schwab@suse.de
Subject: Re: Redefinition of struct in6_addr in <netinet/in.h> and <linux/in6.h>
References: <201301161205.04502.vapier@gentoo.org> <50F75EA7.4060309@systemhalted.org> <20130116.221538.1756411165313441486.davem@davemloft.net> <201301172320.19905.vapier@gentoo.org> <CAE2sS1jMhnRcoo1oe7wQ+SP=40u9mkps6vXua8TQQ4Tbf2qKOQ@mail.gmail.com>
In-Reply-To: <CAE2sS1jMhnRcoo1oe7wQ+SP=40u9mkps6vXua8TQQ4Tbf2qKOQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 04:22 AM, Carlos O'Donell wrote:
> On Thu, Jan 17, 2013 at 11:20 PM, Mike Frysinger <vapier@gentoo.org> wrote:
>> On Wednesday 16 January 2013 22:15:38 David Miller wrote:
>>> From: Carlos O'Donell <carlos@systemhalted.org>
>>> Date: Wed, 16 Jan 2013 21:15:03 -0500
>>>
>>>> +/* If a glibc-based userspace has already included in.h, then we will
>>>> not + * define in6_addr (nor the defines), sockaddr_in6, or ipv6_mreq.
>>>> The + * ABI used by the kernel and by glibc match exactly. Neither the
>>>> kernel + * nor glibc should break this ABI without coordination.
>>>> + */
>>>> +#ifndef _NETINET_IN_H
>>>> +
>>>
>>> I think we should shoot for a non-glibc-centric solution.
>>>
>>> I can't imagine that other libc's won't have the same exact problem
>>> with their netinet/in.h conflicting with the kernel's, redefining
>>> structures like in6_addr, that we'd want to provide a protection
>>> scheme for here as well.
>>
>> yes, the kernel's use of __GLIBC__ in exported headers has already caused
>> problems in the past.  fortunately, it's been reduced down to just one case
>> now (stat.h).  let's not balloon it back up.
>> -mike
> 
> I also see coda.h has grown a __GLIBC__ usage.
> 
> In the next revision of the patch I created a single libc-compat.h header
> which encompasses the logic for any libc that wants to coordinate with
> the kernel headers.


> It's simple enough to move all of the __GLIBC__ uses into libc-compat.h,
> then you control userspace libc coordination from one file.

How about just deciding on a single macro/symbol both the
kernel and libc (any libc that needs this) define?  Something
like both the kernel and userland doing:

#ifndef __IPV6_BITS_DEFINED
#define __IPV6_BITS_DEFINED
...
define in6_addr, sockaddr_in6, ipv6_mreq, whatnot
#endif

So whichever the application includes first, wins.
Too naive?  I didn't see this option being discarded, so
not sure it was considered.

-- 
Pedro Alves

