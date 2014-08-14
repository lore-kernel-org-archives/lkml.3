Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbaHNLDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 07:03:38 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:49841 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbaHNLDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 07:03:36 -0400
Message-ID: <53EC9783.3020809@cogentembedded.com>
Date: Thu, 14 Aug 2014 15:03:31 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: leroy christophe <christophe.leroy@c-s.fr>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Issue with commit 33c133cc7598e60976a phy: IRQ cannot be shared
References: <53EC57B9.8080903@c-s.fr>
In-Reply-To: <53EC57B9.8080903@c-s.fr>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 8/14/2014 10:31 AM, leroy christophe wrote:

> I have an hardware with two ethernet interfaces, and with the two PHYs inside
> the same component INTEL LXT973 which has only one interrupt.
> I also have another hardware with two ethernet interfaces and two independant
> PHYs. But the two PHYs are wired to the same interrupt.
> This is working perfectly up to Linux 3.12.

    Hm, I'm surprised it works. Are you sure you're getting interrupts from 
both PHYs? Because if both Ethernet controllers are active simultaneously, 
only the first registered PHY IRQ handler should get all the interrupts.

> But since your commit, introduced in Linux 3.13, my interfaces don't work
> anymore as the second PHYs can't register IRQ.

    Strange too, the phylib should use polling in case request_irq() fails.

> Reading the commit log, I can't really understand the reason for the change.

    The shared IRQ handler should check for IRQ from its device and return 
IRQ_NONE if there's no IRQ active; phy_interrupt() doesn't do that (this is 
pushed to the workqueue).

> Is it really worth it, and therefore how shall my case be handled ?

    PHY IRQs are not necessary for the phylib state machine.

> Christophe

WBR, Sergei

