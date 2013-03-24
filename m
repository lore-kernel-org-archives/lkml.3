Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3CXTLP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 15:11:15 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:59289 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab3CXTLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 15:11:14 -0400
Message-ID: <1364152267.3620.31.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] Fix IXP4xx coherent allocations
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Miller <davem@davemloft.net>
CC: <khc@pm.waw.pl>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <c.aeschlimann@acn-group.ch>
Date: Sun, 24 Mar 2013 19:11:07 +0000
In-Reply-To: <20130323.195740.2108147521543354261.davem@davemloft.net>
References: <m3obe9lxil.fsf@intrepid.localdomain>
	 <20130323.195740.2108147521543354261.davem@davemloft.net>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19744.005
X-TM-AS-Result: No--21.877800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-23 at 19:57 -0400, David Miller wrote:
> From: Krzysztof Halasa <khc@pm.waw.pl>
> Date: Sat, 23 Mar 2013 20:35:46 +0100
> 
> > ARM core code currently requires coherent DMA mask to be set. Make sure
> > we limit PCI devices to 64 MiB while allowing on-chip devices to access
> > the whole 4 GiB address space.
> > 
> > This fixes a v3.7+ regression which broke IXP4xx built-in network devices.
> > 
> > Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>
> 
> This requirement is not reasonable.
> 
> The DMA API documentation clearly states what the default must be,
> and what drivers are guarenteed will be the default.

I'm failing to see where it says the default can't be narrower than 32
bits due to platform limits.  And how do you think DMA mapping is
supposed to work for PCI devices on these platforms, anyway?

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

