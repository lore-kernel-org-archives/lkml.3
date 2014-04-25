Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaDYPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:16:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:42903 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaDYPQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:16:22 -0400
Date: Fri, 25 Apr 2014 17:16:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "tkhai@yandex.ru" <tkhai@yandex.ru>
Subject: Re: Real-time scheduling policies and hyper-threading
Message-ID: <20140425151620.GK11096@twins.programming.kicks-ass.net>
References: <36851398363372@webcorp2g.yandex-team.ru>
 <20140424185858.GB26782@laptop.programming.kicks-ass.net>
 <17051398423889@webcorp2e.yandex-team.ru>
 <20140425131620.GB11096@twins.programming.kicks-ass.net>
 <34791398438136@webcorp2g.yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34791398438136@webcorp2g.yandex-team.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 07:02:16PM +0400, Roman Gushchin wrote:
> Of course, there is always a trade-off between latency and performance utilization,
> but the common practice here is to keep cpu load between 40% and 70%. So, there is
> fast always a free CPU thread, and a good chance that there is a free core.
> In this case, both latency and average performance depends on how effectively 
> all physical cores are utilized.
> 
> Below is the comparison of average response times (in microseconds) under CFS and RT
> scheduler with my patches depending on the number of simultaneous requests. 
> It's a 32-thread processor with 16 physical cores.
> 
> nr_req  CFS  RT*      diff      
> 1       9664     9237    +4.41% 
> 2       9179     9107    +0.79% 
> 3       9179     9310    -1.43% 
> 4       9325     9245    +0.86% 
> 5       9562     9387    +1.83% 
> 6       9523     9478    +0.47% 
> 7       10105   9727    +3.74%  
> 8       9900     9781    +1.21% 
> 9       10077   9871    +2.04%  
> 10     10270   9963    +2.99%   
> 11     10604   10231   +3.52%   
> 12     10760   10299   +4.29%   
> 13     11022   10316   +6.40%   
> 14     11595   10310   +11.08%  
> 15     11489   10200   +11.22%  
> 16     12059   10404   +13.72%  
> 17     12056   10691   +11.32%  
> 18     12208   11027   +9.67%   
> 19     12412   11337   +8.66%   
> 20     12634   11663   +7.69%   
> 21     12843   12165   +5.28%   
> 22     13181   12273   +6.89%   
> 23     13214   12560   +4.95%   
> 24     13465   12822   +4.78%   
> 25     13469   13106   +2.70%   
> 26     13725   13329   +2.88%   
> 27     13943   13581   +2.60%   
> 28     14007   13845   +1.16%   
> 29     14242   14040   +1.41%   
> 30     14386   14265   +0.84%   
> 31     14909   14478   +2.90%   
> 32     14772   14769   +0.02%   
> 
> Probably, it's possible to tune CFS for this case, but I have no idea how.

Well, like with everything, trace the heck out of it, see where it makes
the 'wrong' decision, then try and cure it.

The 'problem' seems to be in the 13-20 requests range.
