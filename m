Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaE0IQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:16:46 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:34955 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753074AbaE0IQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:16:42 -0400
Message-ID: <5384498A.9080900@mellanox.com>
Date: Tue, 27 May 2014 11:15:06 +0300
From: Amir Vadai <amirv@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, <idos@mellanox.com>,
        Yevgeny Petrilin <yevgenyp@mellanox.com>
Subject: Re: Extend irq_set_affinity_notifier() to use a call chain
References: <5381DEDC.8050204@gmail.com> <alpine.DEB.2.02.1405261313570.21720@ionos.tec.linutronix.de> <53832472.7070000@gmail.com> <alpine.DEB.2.02.1405261327500.21720@ionos.tec.linutronix.de> <53832D28.1050207@mellanox.com> <alpine.DEB.2.02.1405261412110.21720@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1405261412110.21720@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.13.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/2014 3:39 PM, Thomas Gleixner wrote:

[...]

>
> The rmap _IS_ instantiated by the driver, and both the driver and the
> networking core know about it.
>
> So it's not completely different consumers. Just because it's a
> library does not mean it's disjunct from the code which uses it.
>
> Aside of the fact, that maintaining a per irq notifier chain is going
> to be ugly as hell due to life time and locking issues, it's just
> opening a can of worms. How do you make sure that the invocation order
> is correct? What are the dependency rules of the driver restarting the
> napi session versus updating the rmap?
>
> Even if you'd solve that and have a callback in the driver, then the
> callback never can restart the napi session directly. All it can do is
> set a flag which needs to be checked in the RX path, right?
>
> So what's the point of adding notifier call chain complexity, ordering
> problems etc., if you can simply note the fact that the affinity
> changed in the rmap itself and check that in the RX path?

I will try to find a solution in the spirit of what you suggested - to 
let the rmap library notify napi about affinity changes - without adding 
this complexity to the code.

Thanks,
Amir

>
> Thanks,
>
> 	tglx

