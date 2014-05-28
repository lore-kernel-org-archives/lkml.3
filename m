Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbaE1WLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:11:52 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:44860 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbaE1WLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:11:51 -0400
MIME-Version: 1.0
X-Originating-IP: [2601:7:1680:338::529]
In-Reply-To: <CAPoQQ-17OHotfbczJvEoq=vAzu_+6-sV3M1ZAhDaQ45wB3NB4A@mail.gmail.com>
References: <1401236684-10579-1-git-send-email-dev@codyps.com>
	<1401236684-10579-12-git-send-email-dev@codyps.com>
	<063D6719AE5E284EB5DD2968C1650D6D1724EEAF@AcuExch.aculab.com>
	<CAPoQQ-17OHotfbczJvEoq=vAzu_+6-sV3M1ZAhDaQ45wB3NB4A@mail.gmail.com>
Date: Wed, 28 May 2014 17:11:49 -0500
Message-ID: <CAPoQQ-11vW3Q0=LcS-myNZ6hXeYBeu==_prwHJXHvLfkUSmZHQ@mail.gmail.com>
Subject: Re: [PATCH 11/16] byteorder: provide a linux/byteorder.h with {be,
 le}_to_cpu() and cpu_to_{be, le}() macros
From: Cody P Schafer <dev@codyps.com>
To: David Laight <David.Laight@aculab.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 5:05 PM, Cody P Schafer <dev@codyps.com> wrote:
> On Wed, May 28, 2014 at 3:45 AM, David Laight <David.Laight@aculab.com> wrote:
>> From: Cody P Schafer
>>> Rather manually specifying the size of the integer to be converted, key
>>> off of the type size. Reduces duplicate size info and the occurance of
>>> certain types of bugs (using the wrong sized conversion).
>> ...
>>> +#define be_to_cpu(v) \
>>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint8_t) , v, \
>>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint16_t), be16_to_cpu(v), \
>>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint32_t), be32_to_cpu(v), \
>>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint64_t), be64_to_cpu(v), \
>>> +             (void)0))))
>> ...
>>
>> I'm not at all sure that using the 'size' of the constant will reduce
>> the number of bugs - it just introduces a whole new category of bugs.
>
> Certainly, if you mis-size the argument (and thus have missized one of
> the variables containing the be value, probably a bug anyhow), there
> will be problems.
>
> I put this interface together because of an actual bug I wrote into
> the initial code of the hv_24x7 driver (resized a struct member
> without adjusting the be*_to_cpu() sizing).
> Having this "auto sizing" macro means I can avoid encoding the size of
> a struct field in multiple places.

To clarify, the point I'm making here is that this simply cuts out 1
more place we can screw up endianness conversion sizing.
