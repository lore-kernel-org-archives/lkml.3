Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3IYR5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:57:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42960 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3IYR5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:57:06 -0400
Date: Wed, 25 Sep 2013 13:56:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCHv2] tracing/events: Add bounce tracing to swiotbl
Message-ID: <20130925175649.GC7253@phenom.dumpdata.com>
References: <1378325465-10384-1-git-send-email-zoltan.kiss@citrix.com>
 <5239CF01.1010001@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5239CF01.1010001@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 05:04:17PM +0100, Zoltan Kiss wrote:
> Hi,
> 
> I haven't got a reply in the past 2 weeks, so I would like to bump
> the patch, just to make sure it haven't fell off the radar.

Hey,

I have this in my queue to put on 3.13 as it is past the merge window.
.. with that in mind:


.. snip..
> >+	TP_printk("dev_name: %s dma_mask=%llx dev_addr=%llx "
> >+		"size=%zu swiotlb_force=%x",
> >+		__get_str(dev_name),
> >+		__entry->dma_mask,
> >+		(unsigned long long)__entry->dev_addr,
> >+		__entry->size,
> >+		__entry->swiotlb_force)

Would it make sense to do something like this:

		__entry->swiotlb_force ? "swiotlb_force" : "")

