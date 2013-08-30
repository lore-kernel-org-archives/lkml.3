Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab3H3BLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 21:11:51 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:37084 "HELO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751995Ab3H3BLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 21:11:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130829.181001.145658561677052552.davem@davemloft.net>
References: <CAMuHMdVG9FmZNayrf7HMz4kC4X5QELeXUFjjzpAM80ND_QOm8A@mail.gmail.com>
 <CAEP_g=-XvRiHPzSAp2rgC9Hxdd+pGEHvSTEJ1A1SkWnk1-6xZA@mail.gmail.com> <20130829.181001.145658561677052552.davem@davemloft.net>
From: Jesse Gross <jesse@nicira.com>
Date: Thu, 29 Aug 2013 18:11:25 -0700
Message-ID: <CAEP_g=-XxgK9HVxvcaW3RS2zfa+77pB4cqfLFC0rcV7QJc+2BQ@mail.gmail.com>
Subject: Re: [-next] openvswitch BUILD_BUG_ON failed
To: David Miller <davem@davemloft.net>
Cc: geert@linux-m68k.org, Andy Zhou <azhou@nicira.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 3:10 PM, David Miller <davem@davemloft.net> wrote:
> From: Jesse Gross <jesse@nicira.com>
> Date: Thu, 29 Aug 2013 14:42:22 -0700
>
>> On Thu, Aug 29, 2013 at 2:21 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> However, I have some doubts about other alignment "enforcements":
>>>
>>> "__aligned(__alignof__(long))" makes the whole struct aligned to the
>>> alignment rule for "long":
>>>    1. This is only 2 bytes on m68k, i.e. != sizeof(long).
>>>    2. This is 4 bytes on many 32-bit platforms, which may be less than the
>>>       default alignment for "__be64" (cfr. some members of struct
>>>       ovs_key_ipv4_tunnel), so this may make those 64-bit members unaligned.
>>
>> Do any of those 32-bit architectures actually care about alignment of
>> 64 bit values? On 32-bit x86, a long is 32 bits but the alignment
>> requirement of __be64 is also 32 bit.
>
> All except x86-32 do, it is in fact the odd man out with respect to this
> issue.

Thanks, good to know.

Andy, do you want to modify your patch to just drop the alignment
specification as Geert suggested (but definitely keep the new build
assert that you added)? It's probably better to just send the patch to
netdev (against net-next) as well since you'll likely get better
comments there and we can fix this faster if you cut out the
middleman.
