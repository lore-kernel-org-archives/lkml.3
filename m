Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168AbaJIFYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 01:24:05 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:17740 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaJIFYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 01:24:00 -0400
Message-ID: <54361BE9.8030801@c-s.fr>
Date: Thu, 09 Oct 2014 07:23:53 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: pantelis.antoniou@gmail.com, vbordug@ru.mvista.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] net: fs_enet: Remove non NAPI RX and add NAPI for
 TX
References: <20141007130454.13EF21AB266@localhost.localdomain> <20141008.160301.394010995208640934.davem@davemloft.net>
In-Reply-To: <20141008.160301.394010995208640934.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 08/10/2014 22:03, David Miller a écrit :
> From: Christophe Leroy <christophe.leroy@c-s.fr>
> Date: Tue,  7 Oct 2014 15:04:53 +0200 (CEST)
>
>> When using a MPC8xx as a router, 'perf' shows a significant time spent in
>> fs_enet_interrupt() and fs_enet_start_xmit().
>> 'perf annotate' shows that the time spent in fs_enet_start_xmit is indeed spent
>> between spin_unlock_irqrestore() and the following instruction, hence in
>> interrupt handling. This is due to the TX complete interrupt that fires after
>> each transmitted packet.
>> This patchset first remove all non NAPI handling as NAPI has become the only
>> mode for RX, then adds NAPI for handling TX complete.
>> This improves NAT TCP throughput by 21% on MPC885 with FEC.
>>
>> Tested on MPC885 with FEC.
>>
>> [PATCH 1/2] net: fs_enet: Remove non NAPI RX
>> [PATCH 2/2] net: fs_enet: Add NAPI TX
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> Series applied, thanks.
>
> Any particular reason you didn't just put the TX reclaim calls into
> the existing NAPI handler?
Not really. I used the gianfar.c driver as a model.
>
> That's what other drivers do, because TX reclaim can make SKBs
> available for RX packet receive on the local cpu.  So generally you
> have one NAPI context that first does any pending TX reclaim, then
> polls the RX ring for new packets.
>
Is that a better approach ?

