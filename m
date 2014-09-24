Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaIXJX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:23:27 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:61618 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaIXJXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:23:22 -0400
Message-ID: <54228D87.3070309@6wind.com>
Date: Wed, 24 Sep 2014 11:23:19 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Cong Wang <cwang@twopensource.com>
CC: netdev <netdev@vger.kernel.org>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com> <CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>
In-Reply-To: <CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 23/09/2014 21:22, Cong Wang a écrit :
> On Tue, Sep 23, 2014 at 6:20 AM, Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>>
>> Here is a small screenshot to show how it can be used by userland:
>> $ ip netns add foo
>> $ ip netns del foo
>> $ ip netns
>> $ touch /var/run/netns/init_net
>> $ mount --bind /proc/1/ns/net /var/run/netns/init_net
>> $ ip netns add foo
>> $ ip netns
>> foo (id: 3)
>> init_net (id: 1)
>> $ ip netns exec foo ip netns
>> foo (id: 3)
>> init_net (id: 1)
>> $ ip netns exec foo ip link add ipip1 link-netnsid 1 type ipip remote 10.16.0.121 local 10.16.0.249
>> $ ip netns exec foo ip l ls ipip1
>> 6: ipip1@NONE: <POINTOPOINT,NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default
>>      link/ipip 10.16.0.249 peer 10.16.0.121 link-netnsid 1
>>
>> The parameter link-netnsid shows us where the interface sends and receives
>> packets (and thus we know where encapsulated addresses are set).
>>
>
> So ipip1 is shown in netns foo but functioning in netns init_net? Getting the
> id of init_net in foo depends on your mount namespace, /var/run/netns/ may
> not visible inside foo, in this case, link-netnsid is meaningless. It
> is not your
> fault, network namespace already heavily relies on mount namespace (sysfs
> needs to be remount otherwise you can not create device with the same name.)
>
> On the other hand, what's the problem you are trying to solve? AFAIK,
> the ifindex
> issue is purely in output, IOW, the device still functions correctly
> even through
> its link ifindex is not correct after moving to another namespace. If
> not, it is bug
> we need to fix.
>
The problem is explained here:
http://thread.gmane.org/gmane.linux.network/315933/focus=316064
and here:
http://thread.gmane.org/gmane.linux.kernel.containers/28301/focus=4239


Regards,
Nicolas
