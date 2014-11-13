Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbaKMSpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:45:17 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58110 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933512AbaKMSpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:45:14 -0500
Message-ID: <5464FC37.9010305@suse.cz>
Date: Thu, 13 Nov 2014 19:45:11 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.17 023/319] drivers/net: Disable UFO through virtio
References: <20141112010952.553519040@linuxfoundation.org>		 <20141112010956.540146480@linuxfoundation.org>	 <1415826239.3398.113.camel@decadent.org.uk> <5464EF03.9020002@suse.cz> <1415903703.3398.115.camel@decadent.org.uk>
In-Reply-To: <1415903703.3398.115.camel@decadent.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/13/2014, 07:35 PM, Ben Hutchings wrote:
> On Thu, 2014-11-13 at 18:48 +0100, Jiri Slaby wrote:
>> On 11/12/2014, 10:03 PM, Ben Hutchings wrote:
>>> On Wed, 2014-11-12 at 10:12 +0900, Greg Kroah-Hartman wrote:
>>>> 3.17-stable review patch.  If anyone has any objections,
>>>> please let me know.
>>>> 
>>>> ------------------
>>>> 
>>>> From: Ben Hutchings <ben@decadent.org.uk>
>>>> 
>>>> [ Upstream commit 3d0ad09412ffe00c9afa201d01effdb6023d09b4 ]
>>>> 
>>>> IPv6 does not allow fragmentation by routers, so there is no
>>>>  fragmentation ID in the fixed header.  UFO for IPv6 requires
>>>> the ID to be passed separately, but there is no provision for
>>>> this in the virtio net protocol.
>>>> 
>>>> Until recently our software implementation of UFO/IPv6
>>>> generated a new ID, but this was a bug.  Now we will use ID=0
>>>> for any UFO/IPv6 packet passed through a tap, which is even
>>>> worse.
>>>> 
>>>> Unfortunately there is no distinction between UFO/IPv4 and v6
>>>>  features, so disable UFO on taps and virtio_net completely
>>>> until we have a proper solution.
>>> [...]
>>> 
>>> Please drop this patch for 3.14 and 3.17.  It causes problems
>>> for migration of VMs and we're probably going to revert part of
>>> this. The following patch ("drivers/net, ipv6: Select IPv6
>>> fragment idents for virtio UFO packets") might no longer apply,
>>> in which case you can drop that as well until we have this
>>> sorted out upstream.
>> 
>> The same holds for 3.12, I suppose?
> 
> Right.

Great, I dropped that one.

Thanks!

- -- 
js
suse labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUZPw3AAoJEL0lsQQGtHBJuegP/R1DEoyC2tBsWD78lPFirrF7
bMgXR/KWruqMa2UL9heWgaJOhrFtsmUiaRWgkFapuGyjpMmWm5ZH1qpZTsBo9Y0u
rXFsxJgPF3X2OCBLj7AcaKPsGahYSTpBMY665e+lhO5uqYDx/2B84QqWsLlm3yls
JuWNdMmct/6h8mkGbwTGQ+iM9ancqF2vwNd70Rax1KwydowOxN5/uQfWrkUGUJga
Hh2PKF0OB7goI5MlYPeLiFPLqTigB0k7Rs4G1bFElM8ATTxQ5Fz89rMjd7KXN6kD
ND8mtlMXIvOuTQN1w14Zrke11RFsy2OG5qHDt6xw0Z2dvoflUHdzRAdW3u1ikpI0
7q36uHeokdAI45iqQEmFdSjJmpS1dsSpVNIirrugePi0HSE5oz/wma4762V3mTfk
C1QAkOVxGW8WiwSvmKzqMHeCXIHxekxuaHtQlHPXmZ8foTtliU74jbp8RAZiwyZW
Onaj6cU6K1KWAqgZBsSRmz8YP6yU0xKxjD1b/QK47drEJtHQmog7hfx9bYi+Jd9v
47PL38ZYI0ncwQBtybFbOMtqCjHnK5eQowZJY/1fQlaffQf4cZf5dIiU7lAdLsad
torFKi0drQsLkT5mCTHYGGC/UbyxM4BC/XSaBWXDOvXHPIdr4gC+YYDCS2ZSR4oo
6XJG/XuyKEAkIkgl5bwJ
=qzaW
-----END PGP SIGNATURE-----
