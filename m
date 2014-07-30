Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaG3Ret (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:34:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48263 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbaG3Rer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:34:47 -0400
Message-ID: <53D92CAC.3070002@ti.com>
Date: Wed, 30 Jul 2014 23:04:36 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: John Fastabend <john.fastabend@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-api@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] ethtool: adding support for multiple slave port
 configuration
References: <1406291305-22286-1-git-send-email-mugunthanvnm@ti.com> <1406429221.29010.151.camel@deadeye.wl.decadent.org.uk> <53D52452.2020300@gmail.com>
In-Reply-To: <53D52452.2020300@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 July 2014 09:39 PM, John Fastabend wrote:
> On 07/26/2014 07:47 PM, Ben Hutchings wrote:
>> On Fri, 2014-07-25 at 17:58 +0530, Mugunthan V N wrote:
>>> Some Ethernet Swtich controllers like CPSW in AM335x, TI814x, DRA7x and
>>> AM43xx SoCs, Network Coprocessor in AM5K2E0x, Realtek Switch
>>> controllers
>>> etc has to capability of conneting multiple networks using L2 switching
>>> and has multiple phys. With the existing code, ethtool can communicate
>>> only to one phy.
>>>
>>> To enable user to communicate multiple phy connected to single Ethernet
>>> Switch controller, intoducing a optional new parameter in Ethtool
>>> interface
>>> to pass which slave to set/get the phy configuration.
>>
>> There was some discussion about configuration APIs for hardware/firmware
>> bridges earlier this year and I thought there was a consensus for
>> assigning a network device to each port.  This would remove the need to
>> identify ports within a device.  But I may have misremembered.
>>
>
> I like the approach of creating a network device for each port over
> having to use ethtool to program/discover them. I am currently looking
> at writing management applications for this and IMO it is much easier
> to discover and listen for events on network devices vs polling ethtool
> and iterating through slave indexs. Also you miss a lot of functionality
> that may be useful MTU for example that is not available configured via
> ethtool.
>
> One of the sticking points in earlier discussions was how to handle
> devices that have limited support for slave devices. When we create a
> netdev we expect the stack can bind to it and TX/RX packets which as
> I understand is not always possible? (I missed why we couldn't recv the
> packets over a switch port though with some skb->dev manipulation). In
> this case a feature flag could be used to resolve the feature
> dependencies.
>
>

John

I am also interested in participating in the above management api
development.

Regards
Mugunthan V N
