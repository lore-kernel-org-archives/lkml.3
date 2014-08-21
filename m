Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaHUPvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:51:40 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:45375 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaHUPvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:51:38 -0400
Message-ID: <53F61586.3000107@gmail.com>
Date: Thu, 21 Aug 2014 10:51:34 -0500
From: Robert Jennings <rcj4747@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Himangi Saraogi <himangi774@gmail.com>
CC: benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] powerpc/pseries: Drop unnecessary continue
References: <20140813091847.GA3078@himangi-Dell> <1408596086.9307.3.camel@concordia>
In-Reply-To: <1408596086.9307.3.camel@concordia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512



On 08/20/2014 11:41 PM, Michael Ellerman wrote:
> On Wed, 2014-08-13 at 14:48 +0530, Himangi Saraogi wrote:
>> Continue is not needed at the bottom of a loop.
> 
> True.
> 
> I wonder though, is the code trying to continue to the outer loop?
> I stared at it for a minute but it wasn't obvious.
> 
> I wonder if Robert still remembers?

I don't recall what the intent was here.  Can't believe that it's been
almost 5 years since I wrote this.  I wish I had left a few more
comments in the code for me to go on.

Obviously the continue should be removed since it's not doing
anything.  I don't believe that we'd want a continue statement in
there to get outer loop.  That would change the current cmm_page_array
pointer (pa_curr) to the next in the list after it may have just been
reassigned to pa_last->next.

It may be the case that an earlier version of the code had statements
in the inner loop after that continue that I wanted to skip, or I just
did something silly.

- --Rob

> cheers
> 
>> diff --git a/arch/powerpc/platforms/pseries/cmm.c
>> b/arch/powerpc/platforms/pseries/cmm.c index 2d8bf15..fc44ad0
>> 100644 --- a/arch/powerpc/platforms/pseries/cmm.c +++
>> b/arch/powerpc/platforms/pseries/cmm.c @@ -555,7 +555,6 @@ static
>> int cmm_mem_going_offline(void *arg) pa_last = pa_last->next; 
>> free_page((unsigned long)cmm_page_list); cmm_page_list =
>> pa_last; -				continue; } } pa_curr = pa_curr->next;
> 
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT9hV/AAoJEHQMPZ7t8u1zkNIP/1UMhxuNOHaYucs6nuiKT+HY
i0fDGKAluFrF7pv1Onon9LPUEPSL4Smr7l+FoSSJOP59vHg7F3HnkMu43GQi9X9o
KTQTzt5v0XjKeoKaZcgRD5wIp2J9Rz7CVd3RuYrXZGbIo5WC793Ko+8bEMQkSZv3
75e15WuK1J37e7RHIEmj82oeNj8HAWphkS2+c4JyBWCwVABNLOmC9oY0H2UjPQKe
IOsd8GfHMc4ML+Mrfe14ejsNl7XAfy+Q+Mvot/tuZqSq6G1YiX6MQAXk2yW7QAvE
7tfKZvyPVHylERs5Otk4wwh1YmA0RMTjbf3rkPUyUQs14esOa9aOiVDbFci++C/t
m8c3bF3RbdlWaygnDAodWMH4IP7q9mmLMgk6TZ0LNypOUsqedblHrsNKKnC3jm/y
ju/PzLeU5vJ5UoKF+X6jKpHJB5pLh6v4PVWixXKc0nMiGsg/U/RLDxgow+aA2tfx
psttc5DsxucUqlt1X7Y3yUULOI5mNx4tB/Pd37vTG+KJ16UOzAwuc8oQ/9ulVIj0
omW1+qW0MzXQ0Mezt1iqtN8bqarkj3z/aLZ6vjetnDg60JNlEofpSnJb6ANixJlj
PL/nk3LZjjY6UW79ttikrSnsp6fAUIv8ykxukGZLdO/tUj4pUA5H/2Ab5P1SR0Cx
4M1e9AUR+xvU7KDfYryr
=9qwq
-----END PGP SIGNATURE-----
