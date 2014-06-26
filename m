Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbaFZJj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:39:58 -0400
Received: from smtp.citrix.com ([66.165.176.89]:11584 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbaFZJj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:39:56 -0400
X-IronPort-AV: E=Sophos;i="5.01,552,1400025600"; 
   d="scan'208";a="147508423"
Message-ID: <53ABEA5D.1040104@citrix.com>
Date: Thu, 26 Jun 2014 10:39:41 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, <cwang@twopensource.com>
CC: <steffen.klassert@secunet.com>, <minipli@googlemail.com>,
        <dborkman@redhat.com>, <tgraf@suug.ch>, <joe@perches.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH net-next 3/3 RFC] pktgen: Allow sending TCP packets
References: <1403728972-29548-1-git-send-email-zoltan.kiss@citrix.com>	<1403728972-29548-4-git-send-email-zoltan.kiss@citrix.com>	<CAHA+R7NR4PmLbwmKXL8iwdwm3STNmpT4iZCp3VgB2zAqWZm7XQ@mail.gmail.com> <20140625.174452.216399345748954052.davem@davemloft.net>
In-Reply-To: <20140625.174452.216399345748954052.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/14 01:44, David Miller wrote:
> From: Cong Wang <cwang@twopensource.com>
> Date: Wed, 25 Jun 2014 17:41:47 -0700
>
>> On Wed, Jun 25, 2014 at 1:42 PM, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
>>> This is a prototype patch to enable sending TCP packets with pktgen. The
>>> original motivation is to test TCP GSO with xen-netback/netfront, but I'm not
>>> sure about how the checksum should be set up, and also someone should verify the
>>> GSO settings I'm using.
>>>
>>
>> What's the point of sending TCP packets since you don't establish a TCP
>> connection?
>
> I guess they want to test checksumming and aggregation, things like that.
>
> The other side is of course going to spew reset packets back at the
> pktgen machine.
>

Yes, I just want to stress the driver, not the TCP stack on the other 
end? Netback/front doesn't handle UDP GSO, so to test TCP GSO we need to 
fed it with TCP packets.
It would be good if someone can advise me how to setup checksum and GSO 
bits.

Zoli
