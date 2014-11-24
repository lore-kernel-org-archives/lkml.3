Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbaKXOcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:32:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:39335 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbaKXOcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:32:21 -0500
Date: Mon, 24 Nov 2014 15:32:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 01/16] irqdomain: Introduce new interfaces to support
 hierarchy irqdomains
In-Reply-To: <54733A4E.8020304@huawei.com>
Message-ID: <alpine.DEB.2.11.1411241525470.6439@nanos>
References: <20141112133941.647950773@linutronix.de> <20141112134119.881823615@linutronix.de> <547325A9.3000109@huawei.com> <alpine.DEB.2.11.1411241405560.6439@nanos> <54733A4E.8020304@huawei.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Yun Wu (Abel) wrote:
> On 2014/11/24 21:13, Thomas Gleixner wrote:
> > In the hierarchical case we do not touch the hardware in the
> > allocation step, so we need to activate the allocated interrupt in the
> > hardware before we can use it. And that's clearly a domain interface
> > not a irq chip issue.
> > 
> 
> Makes sense, now the interrupt domain seems to be the best place.
> And when the @domain parameter can be really useful? I haven't see
> anyone using it so far.

All irqdomain callbacks take the domain pointer as their first
parameter. So for consistency sake we made it that way.

You can argue in circles about whether the domain argument could be
removed. It's going to stay for now as it does not matter at all.

Thanks,

	tglx
