Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaEZLYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:24:44 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:55010 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaEZLYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:24:43 -0400
Message-ID: <53832472.7070000@gmail.com>
Date: Mon, 26 May 2014 14:24:34 +0300
From: Amir Vadai <amirv.mellanox@gmail.com>
Reply-To: amirv@mellanox.com
Organization: Mellanox
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, idos@mellanox.com,
        Yevgeny Petrilin <yevgenyp@mellanox.com>
Subject: Re: Extend irq_set_affinity_notifier() to use a call chain
References: <5381DEDC.8050204@gmail.com> <alpine.DEB.2.02.1405261313570.21720@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1405261313570.21720@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/2014 2:15 PM, Thomas Gleixner wrote:
> On Sun, 25 May 2014, Amir Vadai wrote:
>> In order to do that, I need to add a new irq affinity notification
>> callback (In addition to the existing cpu_rmap notification). For
>> that I would like to extend irq_set_affinity_notifier() to have a
>> notifier call-chain instead of a single notifier callback.
>
> Why? "I would like" is a non argument.
Current implementation enables only one callback to be registered for 
irq affinity change notifications.

cpu_rmap is registered be notified - for RFS purposes.
mlx4_en (and probably other network drivers) needs to be notified too, 
in order to stop the napi polling on the old cpu and move to the new one.
To enable more than 1 notification callbacks, I suggest to use a 
notifier call chain.

Amir

>
> Thanks,
>
> 	tglx
>

