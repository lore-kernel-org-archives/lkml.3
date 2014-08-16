Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaHPU3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 16:29:22 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:63312 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaHPU3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 16:29:21 -0400
Message-ID: <53EFBF1C.5060407@colorfullife.com>
Date: Sat, 16 Aug 2014 22:29:16 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andrew Vagin <avagin@parallels.com>
CC: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathias Krause <minipli@googlemail.com>, Joe Perches <joe@perches.com>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH] ipc: always handle a new value of auto_msgmni
References: <1407936117-2985-1-git-send-email-avagin@openvz.org> <53EC8369.8030406@colorfullife.com> <20140814133449.GB15307@paralelels.com>
In-Reply-To: <20140814133449.GB15307@paralelels.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 08/14/2014 03:34 PM, Andrew Vagin wrote:
> On Thu, Aug 14, 2014 at 11:37:45AM +0200, Manfred Spraul wrote:
>> Hi Andrey,
>>
>> [...]
>> What do you use auto_msgmni for? 
> We disable it to check that criu restores a value of the msgmni sysctl correctly.
>
> https://github.com/xemul/criu/blob/master/test/zdtm/live/static/ipc_namespace.c
Thanks for the link, if I see it right, my patch would break your code:

http://marc.info/?l=linux-kernel&m=140782863804950

It removes auto_msgmni - and
What do you think, should I leave auto_msgmni as a stale variable, 
perhaps with a pr_info() that it doesn't have any effect?


--
     Manfred
