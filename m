Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaC1ST5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:19:57 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:65383 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaC1STz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:19:55 -0400
MIME-Version: 1.0
In-Reply-To: <1396030095.12610.343.camel@edumazet-glaptop2.roam.corp.google.com>
References: <cover.1395980768.git.decot@googlers.com> <cc4b88e880d31d8d71a5c8872a64c9d665cd097e.1395980768.git.decot@googlers.com>
 <20140328062537.GA2805@minipsycho.orion> <CAGVrzcZEuTCN0gtQ6pOSgT_3cd3Z8Z4OP2jn0QOD-QHbyPsAiA@mail.gmail.com>
 <1396028776.12610.341.camel@edumazet-glaptop2.roam.corp.google.com>
 <CAGVrzcbVwaEiSn6irSeBwJCk8QsVizNfWO2ZhMxJN8chymo_LQ@mail.gmail.com> <1396030095.12610.343.camel@edumazet-glaptop2.roam.corp.google.com>
From: David Decotigny <decot@googlers.com>
Date: Fri, 28 Mar 2014 11:19:34 -0700
Message-ID: <CAG88wWaQyBERFVW0GKPr8Bam0dgtPOxsXDi+bD430YJjyfsXEQ@mail.gmail.com>
Subject: Re: [PATCH v1] net-sysfs: expose number of link up/down transitions
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
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

Hi all,

Thank you all for your feedback. Indeed, these counters are meant to
detect link flapping situations, and we prefer to accumulate in the
kernel rather than doing it in user space based on the count of
up/down transitions. How about I update the patch with a new
IFLA_LINK_HEALTH that exposes the 2 counters as a new struct? Or: is
it safe/recommended for userspace backward-compatibility to append new
fields to structs like rtnl_link_statsX (I have the impression that
iproute2 would be ok with it)?

On Fri, Mar 28, 2014 at 11:08 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Fri, 2014-03-28 at 10:59 -0700, Florian Fainelli wrote:
>
>> What I meant is that this sort of information most likely is already
>> part of some sort of machine health check that runs periodically,
>> which probably collects gazillions of other metrics. Whether the link
>> flapping information comes from sysfs or was maintained by a small
>> script which counts link UP/DOWN events from 'ip monitor link' and
>> outputs this into a file boils down to the same thing: the information
>> is available to some degree.
>
> Yeah, I am not sure such a daemon runs on my netgear/OpenWrt router ;)
>
>
>
