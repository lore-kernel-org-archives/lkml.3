Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3CGIMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:12:52 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42490 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3CGIMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:12:51 -0500
X-AuditID: 9c930179-b7c78ae000000e4b-2b-51384bff942c
Date: Thu, 7 Mar 2013 17:12:58 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ARM: mm: disable kmap_high_get() for SMP
Message-ID: <20130307081258.GA14839@lge.com>
References: <1362372667-953-1-git-send-email-iamjoonsoo.kim@lge.com>
 <alpine.LFD.2.03.1303051642110.28820@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1303051642110.28820@syhkavp.arg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Nicolas.

On Tue, Mar 05, 2013 at 05:36:12PM +0800, Nicolas Pitre wrote:
> On Mon, 4 Mar 2013, Joonsoo Kim wrote:
> 
> > With SMP and enabling kmap_high_get(), it makes users of kmap_atomic()
> > sequential ordered, because kmap_high_get() use global kmap_lock().
> > It is not welcome situation, so turn off this optimization for SMP.
> 
> I'm not sure I understand the problem.
> 
> The lock taken by kmap_high_get() is released right away before that 
> function returns and therefore this is not actually serializing 
> anything.

Yes, you understand what I want to say correctly.
Sorry for bad explanation.

Following is reasons why I send this patch with RFC tag.

If we have more cpus, performance degration is possible although
it is very short time to holding the lock in kmap_high_get().

And kmap has maximum 512 entries(512 * 4K = 2M) and some mobile devices 
has 2G memory(highmem 1G>), so probability for finding matched entry
is approximately < 1/512. This probability can be more decreasing
for device which have more memory. So I think that waste time to find
matched entry is more than saved time.

Above is my humble opinion, so please let me know what I am missing.

Thanks.

> 
> 
> Nicolas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
