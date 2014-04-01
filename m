Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaDAJfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:35:47 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:43906 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaDAJfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:35:45 -0400
Date: Tue, 1 Apr 2014 11:35:44 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: zhuyj <zyjzyj2000@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: ipv6:remove ipv6 global address after the interface is down
Message-ID: <20140401093544.GF24150@order.stressinduktion.org>
Mail-Followup-To: zhuyj <zyjzyj2000@gmail.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <533A8737.8050108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <533A8737.8050108@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 05:30:31PM +0800, zhuyj wrote:
> Hi, Paul
> 
> With kernel 2.6.34.x, the following problem will appear.
> 
>  TargetA ------------------------- TargetB
> 3000::1/64 3000::2/64
> 
>  TargetA
>    - bring the interface down by doing an "ifconfig eth1 down"
>    - bring the interface back up by doing an "ifconfig eth1 up"
> 
> TargetB
>    - ping6 3000::1
>       ping6 succeeds the first time
>    - after bringing the interface on TargetA down and then back up, 
> ping6 to the interface fails.
> 
> With the latest mainline kernel(3.4+), this problem is resolved. When 
> eth1 is down, ipv6 address and route item are removed.
> But with kernel 2.6.34.x, when eth1 is down, ipv6 address remains while 
> route item is removed.
> 
> So when eth1 is up and assign the previous ipv6 address, with 2.6.34.x, 
> some errors will appear. But with latest mainline kernel, it can work well.
> 
> So I made a patch to fix this problem in kernel 2.6.34.x. Please merge 
> this to kernel2.6.34.x.

2.6.34 stable is EOL and won't get updated anymore. If this is problem is also
present in other, still maintained, stable kernel this would be possible.

Can you identify the upstream commit which repaired this problem and when it
got introduced?

Thanks,

  Hannes

