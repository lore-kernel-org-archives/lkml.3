Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab3HVWCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 18:02:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29908 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab3HVWCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:02:13 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=x354YCjs4QAA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=afNR6u6jPpwA:10 a=tHz9FfFoAAAA:8 a=ys4VdIDcQSAxZwN_Nb8A:9 a=CjuIK1q_8ugA:10 a=6O0IECtVFhoA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 22 Aug 2013 18:02:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>,
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] tracing/events: Add bounce tracing to swiotbl-xen
Message-ID: <20130822180209.07a2bd00@gandalf.local.home>
In-Reply-To: <1377208048-8963-1-git-send-email-zoltan.kiss@citrix.com>
References: <1377208048-8963-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013 22:47:28 +0100
Zoltan Kiss <zoltan.kiss@citrix.com> wrote:


>  /*
>   * Used to do a quick range check in swiotlb_tbl_unmap_single and
>   * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
> @@ -358,6 +362,9 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
>  	/*
>  	 * Oh well, have to allocate and map a bounce buffer.
>  	 */
> +
> +	trace_bounced(dev, dev_addr, size, swiotlb_force);

Please use a more specific name. "bounce" is too generic. I know
tracepoints are grouped by systems, but its easier for tools to just
state a tracepoint name than the system:event pair.

trace_xen_bounced()
 or
trace_swiotlb_bounced()

Something other than just "bounced".

Thanks!

-- Steve

> +
>  	map = swiotlb_tbl_map_single(dev, start_dma_addr, phys, size, dir);
>  	if (map == SWIOTLB_MAP_ERROR)
>  		return DMA_ERROR_CODE;
