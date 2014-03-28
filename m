Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaC1F4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 01:56:52 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38315 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaC1F4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 01:56:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140328161725.e044dd9417cae3020068f350@canb.auug.org.au>
References: <cover.1395980768.git.decot@googlers.com> <cc4b88e880d31d8d71a5c8872a64c9d665cd097e.1395980768.git.decot@googlers.com>
 <20140328161725.e044dd9417cae3020068f350@canb.auug.org.au>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 27 Mar 2014 22:56:10 -0700
Message-ID: <CAGVrzcbW3A5RPibKO=i92dj0815eYV6aFRWhOfXA-KgNAgk9kg@mail.gmail.com>
Subject: Re: [PATCH v1] net-sysfs: expose number of link up/down transitions
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Decotigny <decot@googlers.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Weilong Chen <chenweilong@huawei.com>, Jiri Pirko <jiri@resnulli.us>,
        Amir Vadai <amirv@mellanox.com>, Michael Dalton <mwdalton@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-27 22:17 GMT-07:00 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi David,
>
> On Thu, 27 Mar 2014 21:35:00 -0700 David Decotigny <decot@googlers.com> wrote:
>>
>> Tested:
>>   grep . /sys/class/net/*/count_link_*
>>   + ip link set dev X down/up
>>
>> Signed-off-by: David Decotigny <decot@googlers.com>
>
> It is not a very enlightening commit message.  You should tell us why we
> should add this to the kernel.

This might be useful to detect unstable links for instance, by
measuring how many link transitions you get, which could indicate that
either your NIC or your link partner is at fault.

If possible this should come with a Documentation/ABI/testing/ entry,
quite a lot of network sysfs attributes are lacking one at the moment,
but there is no reason why this should continue.
--
Florian
