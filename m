Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaDYQCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:02:09 -0400
Received: from 4dim-gw.4dim.as ([81.7.137.98]:22276 "EHLO
	SECOEXCHANGE.secomea.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751351AbaDYQCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:02:04 -0400
Message-ID: <535A86F3.5010602@secomea.com>
Date: Fri, 25 Apr 2014 18:01:55 +0200
From: =?UTF-8?B?U3Zlbm5pbmcgU8O4cmVuc2Vu?= <sss@secomea.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: guard against coalescing packets from buggy network
 drivers
References: <535A78ED.3020309@secomea.com> <1398440595.29914.77.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1398440595.29914.77.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [178.21.90.126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25-04-2014 17:43, Eric Dumazet wrote:
>
> If you want a debugging patch, this should happen way before TCP stack
> or even IP stack.
>
> Say you want to use this buggy driver on a router, this code path will
> never bit hit.
>
You are right, of course, there are more effective ways to catch buggy 
drivers.
But they will probably also be much more expensive.
This one is very cheap, being in a relatively cold path, especially 
compared to the memcpy in the same path.

Svenning
