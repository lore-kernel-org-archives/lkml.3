Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbaJaVRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:17:36 -0400
Received: from ns.iliad.fr ([212.27.33.1]:36037 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaJaVRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:17:34 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Oct 2014 17:17:34 EDT
Message-ID: <1414789630.14835.49.camel@sakura.staff.proxad.net>
Subject: Re: DMA allocations from CMA and fatal_signal_pending check
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>, lauraa@codeaurora.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, mina86@mina86.com, linux-mm@kvack.org,
        aneesh.kumar@linux.vnet.ibm.com, Gregory Fong <gregory.0xf0@gmail.com>,
        gioh.kim@lge.com, akpm@linux-foundation.org,
        Brian Norris <computersforpeace@gmail.com>,
        linux-arm-kernel@lists.infradead.org, m.szyprowski@samsung.com
Date: Fri, 31 Oct 2014 22:07:10 +0100
In-Reply-To: <20141031082818.GB14642@js1304-P5Q-DELUXE>
References: <544FE9BE.6040503@gmail.com>
	 <20141031082818.GB14642@js1304-P5Q-DELUXE>
Organization: Freebox
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2014-10-31 at 17:28 +0900, Joonsoo Kim wrote:

> I guess that it is okay that bcm_sysport_open() return -EINTR?

actually, since CMA alloc is hidden behind dma_alloc_coherent(), all you
get back is NULL and then return ENOMEM.

-- 
Maxime


