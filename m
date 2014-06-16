Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbaFPPB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:01:28 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:45536 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbaFPPBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:01:24 -0400
MIME-Version: 1.0
In-Reply-To: <87wqckqrxe.fsf@x220.int.ebiederm.org>
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
	<20140611133919.GZ4581@linux.vnet.ibm.com>
	<CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>
	<539879B8.4010204@canonical.com>
	<20140611161857.GC4581@linux.vnet.ibm.com>
	<53989F7B.6000004@canonical.com>
	<874mzr41kf.fsf@x220.int.ebiederm.org>
	<20140611225228.GO4581@linux.vnet.ibm.com>
	<87ioo7vy5s.fsf@x220.int.ebiederm.org>
	<20140611234902.GQ4581@linux.vnet.ibm.com>
	<87bntzt24g.fsf@x220.int.ebiederm.org>
	<CAJE_dJzzj2uf+YEXhAngJDKev=Lc4O6fyKfHoO2PbzD90VuuVw@mail.gmail.com>
	<874mzrszlk.fsf@x220.int.ebiederm.org>
	<CAJE_dJzShXxjsywRo_kwa0ez6Seu7+dModbz2Lvha5iuJw7FTw@mail.gmail.com>
	<CAJE_dJzjcWP=e_CPM1M64URVHiEFFb+fP6g2YKZVdoFntkQMZg@mail.gmail.com>
	<87wqckqrxe.fsf@x220.int.ebiederm.org>
Date: Mon, 16 Jun 2014 12:01:23 -0300
Message-ID: <CAJE_dJyaxDiR3zY0KdUgoFyv8SiMTOfMMZOP0JH6je_wC_=mBQ@mail.gmail.com>
Subject: Re: Possible netns creation and execution performance/scalability
 regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
From: Rafael Tinoco <rafael.tinoco@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dave Chiluk <chiluk@canonical.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...

On Fri, Jun 13, 2014 at 9:02 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Rafael Tinoco <rafael.tinoco@canonical.com> writes:
>
>> Okay,
>>
>> Tests with the same script were done.
>> I'm comparing : master + patch vs 3.15.0-rc5 (last sync'ed rcu commit)
>> and 3.9 last bisect good.
>>
>> Same tests were made. I'm comparing the following versions:
>>
>> 1) master + suggested patch
>> 2) 3.15.0-rc5 (last rcu commit in my clone)
>> 3) 3.9-rc2 (last bisect good)
>
> I am having a hard time making sense of your numbers.
>
> If I have read your email correctly my suggested patch caused:
> "ip netns add" numbers to improve
> 1x "ip netns exec" to improve some
> 2x "ip netns exec" to show no improvement
> "ip link add" to show no effect (after the 2x ip netns exec)

 - "netns add" are as good as they were before this regression.
 - "netns exec" are improved but still 50% of the last good bisect commit.
 - "link add" didn't show difference.

> This is interesting in a lot of ways.
> - This seems to confirm that the only rcu usage in ip netns add
>   was switch_task_namespaces.  Which is convinient as that rules
>   out most of the network stack when looking for performance oddities.
>
> - "ip netns exec" had an expected performance improvement
> - "ip netns exec" is still slow (so something odd is still going on)
> - "ip link add" appears immaterial to the performance problem.
>
> It would be interesting to switch the "ip link add" and "ip netns exec"
> in your test case to confirm that there is nothing interesting/slow
> going on in "ip link add"

 - will do that.

>
> Which leaves me with the question what ip "ip netns exec" remains
> that is using rcu and is slowing all of this down.

 - will check this also.

> Eric

Tks

Rafael
