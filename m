Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaDNETU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 00:19:20 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:49908 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaDNETQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 00:19:16 -0400
Message-ID: <534B61C2.1080700@adjacentlink.com>
Date: Mon, 14 Apr 2014 00:19:14 -0400
From: Steven Galgano <sgalgano@adjacentlink.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mst@redhat.com, jasowang@redhat.com, xemul@parallels.com,
        wuzhy@linux.vnet.ibm.com, therbert@google.com, yamato@redhat.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Brian.Adamson@nrl.navy.mil,
        jgiovatto@adjacentlink.com
Subject: Re: [PATCH v2] tuntap: add flow control to support back pressure
References: <5347487B.4040608@adjacentlink.com>	<20140413141745.GB17839@redhat.com>	<534B3A33.9090401@adjacentlink.com> <20140413.214004.1087903132047842986.davem@davemloft.net>
In-Reply-To: <20140413.214004.1087903132047842986.davem@davemloft.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2014 09:40 PM, David Miller wrote:
> From: Steven Galgano <sgalgano@adjacentlink.com>
> Date: Sun, 13 Apr 2014 21:30:27 -0400
> 
>> Added optional per queue flow control support using IFF_FLOW_CONTROL. When the IFF_FLOW_CONTROL TUNSETIFF flag is specified it will set a per queue flag to indicate that the queue should be stopped using netif_tx_stop_queue(), rather than discarding frames once full. After reading a frame from the respective stopped queue, a netif_tx_wake_queue() is issued to signal resource availability.
>>
>> The per queue TUN_FLOW_CONTROL flag is stored in struct tun_file. This provides the flexibility to enable flow control on all, none or some queues when using IFF_MULTI_QUEUE. When not using IFF_MULTI_QUEUE, IFF_FLOW_CONTROL will apply to the single queue. No changes were made to the default drop frame policy.
>>
>> This change adds support for back pressure use cases.
>>
>> Reported-by: Brian Adamson <brian.adamson@nrl.navy.mil>
>> Tested-by: Joseph Giovatto <jgiovatto@djacentlink.com>
>> Signed-off-by: Steven Galgano <sgalgano@adjacentlink.com>
> 
> Please format your commit messages to ~80 columns of text.
> 
> It won't be automatically formatted by GIT and in fact it looks ugly
> with all the wrapping in text based tools.
> 
Added optional per queue flow control support using IFF_FLOW_CONTROL. When the 
IFF_FLOW_CONTROL TUNSETIFF flag is specified it will set a per queue flag to 
indicate that the queue should be stopped using netif_tx_stop_queue(), rather 
than discarding frames once full. After reading a frame from the respective 
stopped queue, a netif_tx_wake_queue() is issued to signal resource 
availability.

The per queue TUN_FLOW_CONTROL flag is stored in struct tun_file. This provides 
the flexibility to enable flow control on all, none or some queues when using 
IFF_MULTI_QUEUE. When not using IFF_MULTI_QUEUE, IFF_FLOW_CONTROL will apply to 
the single queue. No changes were made to the default drop frame policy.

This change adds support for back pressure use cases.

Reported-by: Brian Adamson <brian.adamson@nrl.navy.mil>
Tested-by: Joseph Giovatto <jgiovatto@djacentlink.com>
Signed-off-by: Steven Galgano <sgalgano@adjacentlink.com>


