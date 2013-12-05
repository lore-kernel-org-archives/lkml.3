Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab3LEQxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:53:31 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:61540 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3LEQxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:53:30 -0500
Date: Thu, 5 Dec 2013 11:53:25 -0500
From: Tejun Heo <tj@kernel.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 08/23] mm/memblock: Add memblock memory allocation apis
Message-ID: <20131205165325.GA24062@mtj.dyndns.org>
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
 <1386037658-3161-9-git-send-email-santosh.shilimkar@ti.com>
 <20131203232445.GX8277@htj.dyndns.org>
 <52A0AB34.2030703@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A0AB34.2030703@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 05, 2013 at 06:35:00PM +0200, Grygorii Strashko wrote:
> >> +#define memblock_virt_alloc_align(x, align) \
> >> +	memblock_virt_alloc_try_nid(x, align, BOOTMEM_LOW_LIMIT, \
> >> +				     BOOTMEM_ALLOC_ACCESSIBLE, MAX_NUMNODES)
> > 
> > Also, do we really need this align variant separate when the caller
> > can simply specify 0 for the default?
> 
> Unfortunately Yes. 
> We need it to keep compatibility with bootmem/nobootmem
> which don't handle 0 as default align value.

Hmm... why wouldn't just interpreting 0 to SMP_CACHE_BYTES in the
memblock_virt*() function work?

Thanks.

-- 
tejun
