Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827Ab3DCB7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:59:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58695 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760672Ab3DCB7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:59:35 -0400
X-Sasl-enc: 292Hhu5Qc8EQIDqGtrRZg933bmzeAFyAPLf7IElCVcPl 1364954374
Message-ID: <515B8D09.9050304@signal11.us>
Date: Tue, 02 Apr 2013 21:59:37 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: werner@almesberger.net, netdev@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-zigbee-devel] [PATCH 1/6] mac802154: Immediately retry
 sending failed packets
References: <515B4D79.40805@signal11.us> <20130402231319.GD28141@ws> <515B84EB.8020006@signal11.us> <20130402.215625.1555279506975246223.davem@davemloft.net>
In-Reply-To: <20130402.215625.1555279506975246223.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 09:56 PM, David Miller wrote:
> From: Alan Ott <alan@signal11.us>
> Date: Tue, 02 Apr 2013 21:24:59 -0400
>
>> I like it for a couple of reasons.
>> 1. Most supported devices have only single packet output buffer, so
>> blocking in the driver is the most straight-forward way to handle it.
>> The alternative is to make each driver have a workqueue for xmit() (to
>> lift the blocking out from atomic context). This makes each driver simpler.
>>
>> 2. All of the flow control can be handled one time in the mac802154 layer.
> We have a perfectly working flow control mechanism in the generic
> networking queuing layer.  Please use it instead of inventing things.

I'm pretty sure that's what I'm doing in [1]. When I say "flow control
can be handled," I mean managing calls to netif_stop_queue() and
netif_wake_queue(). Is there something else I should be doing instead?

> If it does not meet your needs, fix it, rather than go off and do
> your own thing.  That way everyone benfits, not just you.

Fully agreed.

Alan.

[1] http://www.spinics.net/lists/netdev/msg231483.html

