Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbaC1SAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:00:17 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40978 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaC1SAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:00:11 -0400
MIME-Version: 1.0
In-Reply-To: <1396028776.12610.341.camel@edumazet-glaptop2.roam.corp.google.com>
References: <cover.1395980768.git.decot@googlers.com> <cc4b88e880d31d8d71a5c8872a64c9d665cd097e.1395980768.git.decot@googlers.com>
 <20140328062537.GA2805@minipsycho.orion> <CAGVrzcZEuTCN0gtQ6pOSgT_3cd3Z8Z4OP2jn0QOD-QHbyPsAiA@mail.gmail.com>
 <1396028776.12610.341.camel@edumazet-glaptop2.roam.corp.google.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 28 Mar 2014 10:59:31 -0700
Message-ID: <CAGVrzcbVwaEiSn6irSeBwJCk8QsVizNfWO2ZhMxJN8chymo_LQ@mail.gmail.com>
Subject: Re: [PATCH v1] net-sysfs: expose number of link up/down transitions
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>, David Decotigny <decot@googlers.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Weilong Chen <chenweilong@huawei.com>, Amir Vadai <amirv@mellanox.com>,
        Michael Dalton <mwdalton@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-28 10:46 GMT-07:00 Eric Dumazet <eric.dumazet@gmail.com>:
> On Fri, 2014-03-28 at 09:51 -0700, Florian Fainelli wrote:
>> 2014-03-27 23:25 GMT-07:00 Jiri Pirko <jiri@resnulli.us>:
>> >
>> > If this is exposed in sysfs, this needs to be exposed via RT netlink as
>> > well.
>>
>> This makes me wonder if this really needs to be a kernel-maintained
>> pair of counters. Since this seems to be useful for monitoring e.g:
>> servers for link flapping, I would assume that some user-space
>> script/program does read these sysfs entries periodically to report a
>> healthy link. If that's the case, what prevents the same
>> script/program from listening to netlink events and count the link
>> UP/DOWN events from there and report that?
>
> The same would be true for any counter in networking stack...
>
> I do not feel we need to have a daemon running to 'count' events.
>
> I like being able to run "ip -s link" , "ifconfig -a" or "nstat -a"
> without having to connect to a daemon. This daemon will likely have
> different api / constraints from distro to distro.
>
> To me, first thing is a counter, then eventually events for daemons.

What I meant is that this sort of information most likely is already
part of some sort of machine health check that runs periodically,
which probably collects gazillions of other metrics. Whether the link
flapping information comes from sysfs or was maintained by a small
script which counts link UP/DOWN events from 'ip monitor link' and
outputs this into a file boils down to the same thing: the information
is available to some degree.

That said, this is a cheap pair of a counter in a slow path, so maybe
it is fine to have it without requiring any user-space dependency to
be read...

>
> drop_monitor could eventually disappear if we had counters everywhere we
> need them.
>
>
>



-- 
Florian
