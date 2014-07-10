Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaGJKMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:12:51 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:58082 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaGJKMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:12:49 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.72.173]
In-Reply-To: <87pphdh85q.fsf@nemi.mork.no>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
 <1404980258-30853-11-git-send-email-teg@jklm.no> <87pphdh85q.fsf@nemi.mork.no>
From: Tom Gundersen <teg@jklm.no>
Date: Thu, 10 Jul 2014 12:12:28 +0200
Message-ID: <CAG-2HqWSRRfW1EygXd_1=eYFsTeDd3SsJBfF3BuH35hgGxogxA@mail.gmail.com>
Subject: Re: [PATCH v7 10/33] net: dummy - set name assign type
To: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        dingtianhong <dingtianhong@huawei.com>,
        Tan Xiaojun <tanxiaojun@huawei.com>,
        WANG Cong <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 11:31 AM, Bjørn Mork <bjorn@mork.no> wrote:
> Tom Gundersen <teg@jklm.no> writes:
>
>> A fixed number of indistinguishable dummy devices are allocated at module init time,
>> the names are therefore PREDICTABLE rather than ENUM.
>
> OK?  So if I go do
>
>  modprobe dummy numdummies=2
>  ip link add type dummy
>  ip link add type dummy
>
> then I'd have dummy0 and dummy1 with NET_NAME_PREDICTABLE, but dummy2 and
> dummy3 with NET_NAME_ENUM (from your rtnetlink patch).

Correct. Granted, this is definitely a grey area (the distinction
between the name assign types is less important for virtual devices),
but I still think this makes sense:

The result of

modprobe dummy numdummies=2

is to create dummy0 and dummy1, always with the same names.

The result of

ip link add type dummy

is to create dummyX, where X depends on what came before.

> I think this just demonstrates that there aren't that many different
> name types.  There is no real difference between your NET_NAME_ENUM and
> NET_NAME_PREDICTABLE, resulting in arbitrary choices like this one.

It is true that in some cases the distinction is less important, but
that does not negate the usefulness: For instance, the kernel may
assign names to interfaces based on information provided by their
firmware. These names may be useful to keep, and it may be important
for userspace to be told that they are backed by something sensible.

> The same goes for NET_NAME_USER and NET_NAME_RENAMED. These are the same
> from a kernel point of view.

You mean to collapse the two, and just label renamed interfaces
NET_NAME_USER instead?

> If userspace wants to keep track of device
> name history then it is free to do so without any need for a RENAMED
> type.

Just for the record, I don't see how userspace can keep track of
device name history (as some of the history may predate userspace
being around). Getting the history is not important though, what we
care about is the nature of the current name.

Cheers,

Tom
