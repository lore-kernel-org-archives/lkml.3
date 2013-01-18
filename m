Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3AROhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:37:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925Ab3AROhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:37:39 -0500
Message-ID: <50F95DF3.7080602@redhat.com>
Date: Fri, 18 Jan 2013 14:36:35 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
CC: "Carlos O'Donell" <carlos@systemhalted.org>,
        Mike Frysinger <vapier@gentoo.org>, David Miller <davem@davemloft.net>,
        libc-alpha@sourceware.org, bhutchings@solarflare.com,
        amwang@redhat.com, tmb@mageia.org, eblake@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvirt-list@redhat.com, tgraf@suug.ch, schwab@suse.de
Subject: Re: Redefinition of struct in6_addr in <netinet/in.h> and <linux/in6.h>
References: <201301161205.04502.vapier@gentoo.org> <50F75EA7.4060309@systemhalted.org> <20130116.221538.1756411165313441486.davem@davemloft.net> <201301172320.19905.vapier@gentoo.org> <CAE2sS1jMhnRcoo1oe7wQ+SP=40u9mkps6vXua8TQQ4Tbf2qKOQ@mail.gmail.com> <50F927A5.5060409@redhat.com> <50F94FA6.6070005@systemhalted.org> <50F95B0A.1090205@linux-ipv6.org>
In-Reply-To: <50F95B0A.1090205@linux-ipv6.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 02:24 PM, YOSHIFUJI Hideaki wrote:

>>>> It's simple enough to move all of the __GLIBC__ uses into libc-compat.h,
>>>> then you control userspace libc coordination from one file.
>>>
>>> How about just deciding on a single macro/symbol both the
>>> kernel and libc (any libc that needs this) define?  Something
>>> like both the kernel and userland doing:
>>>
>>> #ifndef __IPV6_BITS_DEFINED
>>> #define __IPV6_BITS_DEFINED
>>> ...
>>> define in6_addr, sockaddr_in6, ipv6_mreq, whatnot
>>> #endif
> 
> Hmm, how should we handle future structs/enums then?
> For example, if I want to have in6_flowlabel_req{} defined in
> glibc, what should we do?

Include the glibc header first?  Or is this some other
use case?

The point wasn't that you'd have only one macro for all
structs/enums (you could split into __IPV6_IN6_ADDR_DEFINED,
__IPV6_SOCKADDR_IN6_DEFINED, etc.) but to have the kernel
and libc agree on guard macros, instead of having the kernel
do #ifdef __GLIBC__ and glibc doing #ifdef _NETINET_IN_H.

But as Carlos says, the devil is in the details, and
I sure am not qualified on the details here.

-- 
Pedro Alves

