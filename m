Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaDYTci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:32:38 -0400
Received: from 4dim-gw.4dim.as ([81.7.137.98]:28392 "EHLO
	SECOEXCHANGE.secomea.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752959AbaDYTcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:32:36 -0400
Message-ID: <535AB84B.20207@secomea.com>
Date: Fri, 25 Apr 2014 21:32:27 +0200
From: =?UTF-8?B?U3Zlbm5pbmcgU8O4cmVuc2Vu?= <sss@secomea.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: guard against coalescing packets from buggy network
 drivers
References: <535A78ED.3020309@secomea.com>	 <1398440595.29914.77.camel@edumazet-glaptop2.roam.corp.google.com>	 <535A86F3.5010602@secomea.com> <1398444575.29914.93.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1398444575.29914.93.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [178.21.90.126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25-04-2014 18:49, Eric Dumazet wrote:
> On Fri, 2014-04-25 at 18:01 +0200, Svenning Sørensen wrote:
>
>> You are right, of course, there are more effective ways to catch buggy
>> drivers.
>> But they will probably also be much more expensive.
>> This one is very cheap, being in a relatively cold path, especially
>> compared to the memcpy in the same path.
> It seems you missed the recent tipc thread then.
Yes, I'm not subscribed to the mailing list at the moment - too much 
traffic and too little time..

>
> They are many ways this code path can be abused, your patch only takes
> care of one case.
>
> In tipc case, they added skb to shinfo->frag_list without changing
> skb->data_len.
>
> So skb_tailroom(to) was not returning 0 as it should.
>
> The invariant should be more strict.
>
> BUG_ON(to->data + to->len != skb_tail_pointer(to));
>
> I still think a BUG() to catch this is better.
>
> There is no guarantee the developer/user will catch a WARN(),
> the bug could sit there a long time.
>
> I have no pity for serious bugs like that.
Neither do I.
Either BUG or WARN would have worked for me and would have saved me a 
lot of time in chasing this bug in a monster size (almost 800 files!) 
third party driver for this unfamiliar chip on newly developed embedded 
hardware (so I couldn't be sure it wasn't a hardware bug) with nothing 
else than a serial port and a few MB flash to store log files on.


>
> Since you spot buggy drivers, please provide their fixes or at least
> name them so that we can take care of them.
>
> Thanks
>
>
Strange, I was almost certain that I saw at least one with the same bug, 
but I can't seem to find it any longer.
Maybe I looked too quick, or maybe it's been fixed by the git pull I've 
made in the meantime.
I'll take a closer look if I get some spare time some day..
