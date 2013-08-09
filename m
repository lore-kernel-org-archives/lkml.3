Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198Ab3HIO6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:58:04 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:35671 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883Ab3HIO6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:58:02 -0400
Date: Fri, 9 Aug 2013 10:57:56 -0400
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] idr: Document ida tree sections
Message-ID: <20130809145756.GL20515@mtj.dyndns.org>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
 <1375896905-6074-4-git-send-email-kmo@daterainc.com>
 <20130807202201.GA28039@mtj.dyndns.org>
 <20130807205117.GC11612@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807205117.GC11612@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 07, 2013 at 01:51:17PM -0700, Kent Overstreet wrote:
> + * So if the max section size is 64k, that's ~4096 sections, with 8 byte
> + * pointers that's a little over 32k for the pointers to sections.
> + *
> + * That means max size sections are order 4 page allocations.

Order 4 allocations for common data structure doesn't really sound
like a good idea to me.  It's gonna work fine on relatively large
machines but suck on mobile / small embedded devices, many of which
are still struggling with 32bit address space and compaction may not
be enabled.  It just doens't make sense to me to impose 64k
allocations from low level library function like ida.

Thanks.

-- 
tejun
