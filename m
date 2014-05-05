Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaEEQaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 12:30:17 -0400
Received: from [208.74.158.173] ([208.74.158.173]:48549 "EHLO
	mail2.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbaEEQaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 12:30:15 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 May 2014 12:30:15 EDT
Message-ID: <5367BB2D.4080907@candelatech.com>
Date: Mon, 05 May 2014 09:24:13 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jesper Dangaard Brouer <brouer@redhat.com>
CC: John Fastabend <john.r.fastabend@intel.com>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>, davem@davemloft.net,
        steffen.klassert@secunet.com, fan.du@windriver.com,
        dborkman@redhat.com, minipli@googlemail.com, tgraf@suug.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH] netdev: pktgen xmit packet through vlan interface
References: <1399015092-28643-1-git-send-email-zhouzhouyi@gmail.com> <20140502151921.014fbeec@redhat.com> <5363A4E0.2000403@intel.com> <20140505171252.49773a5a@redhat.com>
In-Reply-To: <20140505171252.49773a5a@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 08:12 AM, Jesper Dangaard Brouer wrote:
> On Fri, 02 May 2014 07:00:00 -0700
> John Fastabend <john.r.fastabend@intel.com> wrote:
> 
>> On 5/2/2014 6:19 AM, Jesper Dangaard Brouer wrote:
>>> On Fri,  2 May 2014 15:18:12 +0800
>>> Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
>>>
>>>> As http://www.spinics.net/lists/netdev/msg165015.html
>>>> pktgen generates shared packet through vlan interface will cause
>>>> oops because of duplicate entering tc queue.
>>>>
>>>> Try to solve this problem by means of packet clone instead of sharing.
>>>
>>> I really don't like adding this stuff to the fast path of pktgen.
>>>
>>> Why would you use pktgen on a VLAN?
>>
>> Its a good way to test qdiscs. When you run pktgen over the VLAN
>> you exercise the lower devices qdisc.
> 
> I do (personally) need a faster way/tool to exercise the qdisc path.
> I'm currently using trafgen, but it is not fast enough for my 10G
> testing.
> 
> Perhaps we could add a pktgen option, that explicitly enable
> transmitting on qdisc path.  And when adding a VLAN device, auto enable
> that mode?

You could just force pktgen to not support multi-skb on vlan interfaces?

I thought we went through this a year or two ago and came up with
something like a 'pktgen-challenged' network interface flag?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

