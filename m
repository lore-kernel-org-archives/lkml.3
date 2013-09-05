Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935514Ab3IECEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:04:46 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:46817 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763193Ab3IECEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:04:45 -0400
Message-ID: <5227E6AF.2040603@hp.com>
Date: Wed, 04 Sep 2013 22:04:31 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] dcache: Translating dentry into pathname without taking
 rename_lock
References: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com> <52278970.2080803@hp.com> <21031.39606.16374.72229@quad.stoffel.home>
In-Reply-To: <21031.39606.16374.72229@quad.stoffel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 04:40 PM, John Stoffel wrote:
>>>>>> "Waiman" == Waiman Long<waiman.long@hp.com>  writes:
> Waiman>  In term of AIM7 performance, this patch has a performance boost of
> Waiman>  about 6-7% on top of Linus' lockref patch on a 8-socket 80-core DL980.
>
> Waiman>  User Range          |   10-100  | 200-10000 | 1100-2000 |
> Waiman>  Mean JPM w/o patch  | 4,365,114 | 7,211,115 | 6,964,439 |
> Waiman>  Mean JPM with patch | 3,872,850 | 7,655,958 | 7,422,598 |
> Waiman>  % Change            |  -11.3%   |   +6.2%   |   +6.6%   |
>
> This -11% impact is worisome to me, because at smaller numbers of
> users, I would still expect the performance to go up.  So why the big
> drop?
>
> Also, how is the impact of these changes on smaller 1 socket, 4 core
> systems?  Just because it helps a couple of big boxes, doesn't mean it
> won't hurt the more common small case.
>
> John

I don't believe the patch will make it slower with less user. It is more 
a result of run-to-run variation. The short workload typically completed 
in a very short time. In the 10-100 user range, the completion times 
range from 0.02-0.11s. With a higher user count, it needs several 
seconds to run and hence the results are more reliable.

Longman
