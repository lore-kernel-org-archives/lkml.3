Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbaAOAua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:50:30 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54621 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaAOAu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:50:27 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        Simon Horman <horms@verge.net.au>, Patrick McHardy <kaber@trash.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jasowang@redhat.com, Serge Hallyn <serge.hallyn@ubuntu.com>,
        pshelar@nicira.com, Eric Dumazet <edumazet@google.com>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, xemul@openvz.org
References: <52C62A44.4070304@huawei.com>
	<CAM_iQpW0+Ftvk=QBE+0yMNW00VkBee1+yAEmbPkT+zjij9RX-Q@mail.gmail.com>
	<52CA614D.6040702@huawei.com> <52CA6C80.9060002@cn.fujitsu.com>
	<52CA8026.4010106@huawei.com>
Date: Tue, 14 Jan 2014 16:50:11 -0800
In-Reply-To: <52CA8026.4010106@huawei.com> (Libo Chen's message of "Mon, 6 Jan
	2014 18:06:30 +0800")
Message-ID: <87y52idq64.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18WjYsL53r/Jd/TOwVFwviSW9W53LTVXBM=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4808]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Libo Chen <clbchenlibo.chen@huawei.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH net-next 0/4] net_cls for sys container
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Libo Chen <clbchenlibo.chen@huawei.com> writes:

> yes
> On 2014/1/6 16:42, Gao feng wrote:
>> On 01/06/2014 03:54 PM, Libo Chen wrote:
>>> On 2014/1/3 13:20, Cong Wang wrote:
>>>> On Thu, Jan 2, 2014 at 7:11 PM, Libo Chen <clbchenlibo.chen@huawei.com> wrote:
>>>>> Hi guys,
>>>>>
>>>>> Now, lxc created with veth can not be under control by
>>>>> cls_cgroup.
>>>>>
>>>>> the former discussion:
>>>>> http://lkml.indiana.edu/hypermail/linux/kernel/1312.1/00214.html
>>>>>
>>>>> In short, because cls_cgroup relys classid attached to sock
>>>>> filter skb, but sock will be cleared inside dev_forward_skb()
>>>>> in veth_xmit().
>>>>
>>>>
>>>> So what are you trying to achieve here?
>>>
>>> sys container using veth can be controlled by cls_cgroup basing on physic network interface
>>>
>> 
>> It's a problem about virtual nic, not container/net namespace.
>
> yes
>
>> 
>> If veth device is running in host. the skb is transmitted firstly by veth device and then delivered
>> by physical device. if you set both qdisc rule on veth and physical device. which qdisc rule will take
>> effect?
>
> both, the end result depends on a smaller.
>
>> 
>> In your patch, both qdisc rule are effective. it looks strange.
>> 
>
> qdisc is based nic, does not distinguish virtual or physics. if you are all set,
> it means that what you want.  so the logic is not the problemI and this appears to be normal.

My personal opinion on the matter is that the network class cgroup is
brain dead and should not be used.  It is impossible to use for
incomming packets, and it is part of the the problem plagued cgroup
subsystem.

You have real network interfaces to do your classification with you
don't need to enhance the network class cgroup.

The more this is asked about the more I think the network class cgroup
should be be taken out into the woods some dark night and left in a
shallow grave, never to bother us again.


Eric

