Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaGJMSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:18:55 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:59776 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaGJMSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:18:53 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.72.173]
In-Reply-To: <87d2ddh1zd.fsf@nemi.mork.no>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
 <1404980258-30853-11-git-send-email-teg@jklm.no> <87pphdh85q.fsf@nemi.mork.no>
 <CAG-2HqWSRRfW1EygXd_1=eYFsTeDd3SsJBfF3BuH35hgGxogxA@mail.gmail.com> <87d2ddh1zd.fsf@nemi.mork.no>
From: Tom Gundersen <teg@jklm.no>
Date: Thu, 10 Jul 2014 14:18:32 +0200
Message-ID: <CAG-2HqVOviqCYrKL-F3o_cR66EAe2skbL20pR48CmEikG1o-7g@mail.gmail.com>
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

On Thu, Jul 10, 2014 at 1:44 PM, Bjørn Mork <bjorn@mork.no> wrote:
> Tom Gundersen <teg@jklm.no> writes:
>
>> The result of
>>
>> modprobe dummy numdummies=2
>>
>> is to create dummy0 and dummy1, always with the same names.
>>
>> The result of
>>
>> ip link add type dummy
>>
>> is to create dummyX, where X depends on what came before.
>
> Which is no different. That's exacly what happens when
> "modprobe dummy numdummies=2" creates the two first interfaces.
>
>
>  ip link add link wwan0 name dummy0 type vlan id 2
>  modprobe dummy numdummies=2
>
> ends up with dummy1 and dummy2 created by the dummy driver.
>
> You are trying to make up differences that just aren't there.

Ah, good point. You are right. So the dummy interfaces should be
labelled NET_NAME_ENUM.

I suppose the distinction should be that statically created devices
like these should be NET_NAME_PREDICTABLE only if they fail when the
name they want is already taken (rather than just picking the next
one).

Thanks for looking into this!

Cheers,

Tom
