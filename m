Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937139Ab3DJQtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:49:00 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46190 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936102Ab3DJQs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:48:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19NLVUIoHbAWDJciId49S2PjrIFawIC5OE=
Date: Wed, 10 Apr 2013 12:48:05 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Elijah Ragozin <illia.ragozin@grapecom.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND v2 1/1] ARM Feroceon: fix kexec by setting
 outer_cache.inv_all
Message-ID: <20130410164805.GA28693@titan.lakedaemon.net>
References: <51631B12.2010908@grapecom.com>
 <51631BAF.40408@grapecom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51631BAF.40408@grapecom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 10:34:07PM +0300, Elijah Ragozin wrote:
> On Feroceon the L2 cache becomes non-coherent with the CPU
> when the L1 caches are disabled. Thus the L2 needs to be invalidated
> after both L1 caches are disabled.
> 
> On kexec before the starting the code for relocation the kernel,
> the L1 caches are disabled in cpu_froc_fin (cpu_v7_proc_fin for Feroceon),
> but after L2 cache is never invalidated, because inv_all is not set
> in cache-feroceon-l2.c.
> So kernel relocation and decompression may has (and usually has) errors.
> Setting the function enables L2 invalidation and fixes the issue.
> 
> Signed-off-by: Illia Ragozin <illia.ragozin@grapecom.com>
> ---
>  arch/arm/mm/cache-feroceon-l2.c | 1 +
>  1 file changed, 1 insertion(+)

fwiw,

Acked-by: Jason Cooper <jason@lakedaemon.net>

Please put this in Russell King's patch tracker so he can pull it in.

thx,

Jason.
