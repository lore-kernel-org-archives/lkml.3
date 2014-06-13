Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaFMGMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:12:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44094 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaFMGMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:12:21 -0400
Message-ID: <539A95A3.1010301@ti.com>
Date: Fri, 13 Jun 2014 11:39:39 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <tglx@linutronix.de>
Subject: Re: [PATCH V2 05/19] irqchip: crossbar: Change allocation logic by
 reversing search for free irqs
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com> <1402574007-13987-6-git-send-email-r.sricharan@ti.com> <20140612125615.GT8664@titan.lakedaemon.net>
In-Reply-To: <20140612125615.GT8664@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Thursday 12 June 2014 06:26 PM, Jason Cooper wrote:
> On Thu, Jun 12, 2014 at 05:23:13PM +0530, Sricharan R wrote:
>> From: Nishanth Menon <nm@ti.com>
>>
>> Reverse the search algorithm to ensure that address mapping and IRQ
>> allocation logics are proper. This can open up new bugs which are
>> easily fixable rather than wait till allocation logic approaches
>> the limit to find new bugs.
> 
> Could you expand on this logic some more?  What class of bugs are you
> hoping to discover more easily?
> 

class 1. address space errors -> example:
reg = <a size_b>
ti,max-irqs =  is a wrong parameter

class 2: irq-reserved list - which decides which entries in the
address space is not actually wired in

class 3: wrong list of routable-irqs.

in general allocating from max to min tends to have benefits in
ensuring the different issues that may be present in dts is easily
caught at definition time, rather than at a later point in time.


Regards,
 Sricharan
