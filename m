Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaAFIly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:41:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39796 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbaAFIlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:41:52 -0500
X-IronPort-AV: E=Sophos;i="4.95,611,1384272000"; 
   d="scan'208";a="9378055"
Message-ID: <52CA6C80.9060002@cn.fujitsu.com>
Date: Mon, 06 Jan 2014 16:42:40 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC: David Miller <davem@davemloft.net>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Li Zefan <lizefan@huawei.com>, Eric Dumazet <edumazet@google.com>,
        pshelar@nicira.com, jasowang@redhat.com,
        Simon Horman <horms@verge.net.au>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        Patrick McHardy <kaber@trash.net>, xemul@openvz.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/4] net_cls for sys container
References: <52C62A44.4070304@huawei.com> <CAM_iQpW0+Ftvk=QBE+0yMNW00VkBee1+yAEmbPkT+zjij9RX-Q@mail.gmail.com> <52CA614D.6040702@huawei.com>
In-Reply-To: <52CA614D.6040702@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/06 16:40:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/06 16:40:51,
	Serialize complete at 2014/01/06 16:40:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 03:54 PM, Libo Chen wrote:
> On 2014/1/3 13:20, Cong Wang wrote:
>> On Thu, Jan 2, 2014 at 7:11 PM, Libo Chen <clbchenlibo.chen@huawei.com> wrote:
>>> Hi guys,
>>>
>>> Now, lxc created with veth can not be under control by
>>> cls_cgroup.
>>>
>>> the former discussion:
>>> http://lkml.indiana.edu/hypermail/linux/kernel/1312.1/00214.html
>>>
>>> In short, because cls_cgroup relys classid attached to sock
>>> filter skb, but sock will be cleared inside dev_forward_skb()
>>> in veth_xmit().
>>
>>
>> So what are you trying to achieve here?
> 
> sys container using veth can be controlled by cls_cgroup basing on physic network interface
> 

It's a problem about virtual nic, not container/net namespace.

If veth device is running in host. the skb is transmitted firstly by veth device and then delivered
by physical device. if you set both qdisc rule on veth and physical device. which qdisc rule will take
effect?

In your patch, both qdisc rule are effective. it looks strange.
