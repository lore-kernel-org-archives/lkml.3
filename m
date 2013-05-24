Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab3EXRG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:06:59 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:56636 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756757Ab3EXRG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:06:58 -0400
Date: Fri, 24 May 2013 18:06:44 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: majianpeng <majianpeng@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm/kmemleak.c: Merge the consecutive scan-areas.
Message-ID: <20130524170644.GB22600@arm.com>
References: <519224DF.3070807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519224DF.3070807@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 12:49:51PM +0100, majianpeng wrote:
> If the scan-areas are adjacent,it can merge in order to reduce memomy.

Have you found any significant reduction in the memory size?

What we miss though is removing an area (and I found a use-case for it).

> +    hlist_for_each_entry(area, &object->area_list, node) {
> +        if (ptr + size == area->start) {
> +            area->start = ptr;
> +            area->size += size;
> +            goto out_unlock;
> +        } else if (ptr == area->start + area->size) {
> +            area->size += size;
> +            goto out_unlock;

I prefer to keep 'goto' only for the error path. You could add a 'bool
merged' and another 'if' block for area allocation.

I'll pick the other too patches.

Thanks.

-- 
Catalin
