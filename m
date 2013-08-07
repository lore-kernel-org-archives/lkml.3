Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab3HGHEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:04:09 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16517 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab3HGHEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:04:07 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-88-5201f16316ed
Message-id: <1375859042.17079.1.camel@AMDC1943>
Subject: Re: [RFC PATCH 3/4] mm: add zbud flag to page flags
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Wed, 07 Aug 2013 09:04:02 +0200
In-reply-to: <52012B35.90801@intel.com>
References: <1375771361-8388-1-git-send-email-k.kozlowski@samsung.com>
 <1375771361-8388-4-git-send-email-k.kozlowski@samsung.com>
 <52012B35.90801@intel.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xy7rJHxmDDJa+tLSYs34Nm8XGGetZ
	LT69fMBocbbpDbvF5V1z2CzurfnParH2yF12i8nvnjFaHNq3it2B02PxnpdMHps+TWL3ODHj
	N4vHg0ObWTz6tqxi9Nh8utrj8ya5APYoLpuU1JzMstQifbsErowFzdkFl1gr2hd8YGlg3MzS
	xcjJISFgIrHhxAVGCFtM4sK99WxdjFwcQgJLGSUeHVjOAuF8ZpRo2XyeGaSKV0Bfou3uF6AE
	B4ewgI3Eo/N8IGE2AWOJzcuXsIHYIgLqEqdWLmcHsZkFDjFJrLzJBWKzCKhK7DxyEayGE6jm
	YMcpdoj5Cxgl/m+5ygjRoC4xad4iZoiLlCR2t3dCDZKX2LzmLdQNghI/Jt9jmcAoMAtJyywk
	ZbOQlC1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERILX3cwLj1mdYhRgINRiYe3Qowx
	SIg1say4MvcQowQHs5IIr8h7oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGv28FSzcp1uQuCF/7
	Zm0mb7SY0SruvLkKqp9O123ZE9r99ewXdcEY31vvzmrEXTze/NlcklfwIVdPVvS5AkZzBVMx
	3msN3UuO3b2t4XRoXmTM6V5hSdPjWw5lZSX/3f9pdqRxMAM7341XvIF3+2qO/VFUPPJqycKX
	B6LXfNxdk8PgGjvjs/4eJZbijERDLeai4kQAzIj//GMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2013-08-06 at 09:58 -0700, Dave Hansen wrote:
> On 08/05/2013 11:42 PM, Krzysztof Kozlowski wrote:
> > +#ifdef CONFIG_ZBUD
> > +	/* Allocated by zbud. Flag is necessary to find zbud pages to unuse
> > +	 * during migration/compaction.
> > +	 */
> > +	PG_zbud,
> > +#endif
> 
> Do you _really_ need an absolutely new, unshared page flag?
> The zbud code doesn't really look like it uses any of the space in
> 'struct page'.
> 
> I think you could pretty easily alias PG_zbud=PG_slab, then use the
> page->{private,slab_cache} (or some other unused field) in 'struct page'
> to store a cookie to differentiate slab and zbud pages.

Thanks for idea, I will try that.

Best regards,
Krzysztof


