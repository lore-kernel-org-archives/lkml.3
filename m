Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3BQHn1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 02:43:27 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:14038 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736Ab3BQHn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 02:43:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sun, 17 Feb 2013 15:43:20 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] of: use platform_device_add
Message-ID: <20130217074317.GB16632@S2101-09.ap.freescale.net>
References: <1358473200-17886-1-git-send-email-grant.likely@secretlab.ca>
 <1358473200-17886-2-git-send-email-grant.likely@secretlab.ca>
 <20130217030331.GA15048@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130217030331.GA15048@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 11:03:35AM +0800, Shawn Guo wrote:
> On Fri, Jan 18, 2013 at 01:40:00AM +0000, Grant Likely wrote:
> > This allows platform_device_add a chance to call insert_resource on all
> > of the resources from OF. At a minimum this fills in proc/iomem and
> > presumably makes resource tracking and conflict detection work better.
> > However, it has the side effect of moving all OF generated platform
> > devices from /sys/devices to /sys/devices/platform/. It /shouldn't/
> > break userspace because userspace is not supposed to depend on the full
> > path (because userspace always does what it is supposed to, right?).
> > 
> > This may cause breakage if either:
> > 1) any two nodes in a given device tree have overlapping & staggered
> >    regions (ie. 0x80..0xbf and 0xa0..0xdf; where one is not contained
> >    within the other). In this case one of the devices will fail to
> >    register and an exception will be needed in platform_device_add() to
> >    complain but not fail.
> 
> Grant,
> 
> The patch introduce a regression on imx6q boot.

It also breaks all of_amba_device users.

of_amba_device_create() --> amba_device_add() --> request_resource()
and fails.

Shawn

