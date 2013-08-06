Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3HFNFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 09:05:20 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56482 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3HFNFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 09:05:18 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-45-5200f48c0710
Message-id: <1375794314.13955.6.camel@AMDC1943>
Subject: Re: [RFC PATCH 0/4] mm: reclaim zbud pages on migration and compaction
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Bob Liu <bob.liu@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Tue, 06 Aug 2013 15:05:14 +0200
In-reply-to: <5200BEEF.7060904@oracle.com>
References: <1375771361-8388-1-git-send-email-k.kozlowski@samsung.com>
 <5200BEEF.7060904@oracle.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xy7o9XxiCDL638VvMWb+GzWLjjPWs
	Fl2nprJYnG16w25xedccNot7a/6zWqw9cpfdYvK7Z4wWh/atYnfg9Nj0aRK7x4kZv1k8Hhza
	zOLx8ektFo++LasYPTafrvb4vEkugD2KyyYlNSezLLVI3y6BK+PmsYtsBatZKz716zYwLmDp
	YuTkkBAwkWjuvQRli0lcuLeerYuRi0NIYCmjxKXL01ghnM+MEt/uHmIHqeIV0JfY9fI6K4gt
	LOAvsfHoXkYQm03AWGLz8iVsILaIgILE60/nmUBsZoFDTBIrb3KB2CwCqhJb//aB1XAKaEmc
	W7QAzBYSSJN49PMzI0S9usSkeYuYIS5Sktjd3skOEZeX2LzmLTPEDYISPybfY5nAKDALScss
	JGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESC193MC49ZnWIUYCDUYmHd8f1
	/4FCrIllxZW5hxglOJiVRHjLXzAECfGmJFZWpRblxxeV5qQWH2Jk4uCUamDsP36geurnonmZ
	ZYt43/830PTb5GLWFSZ4jrvqlM3GDyd/NvxhtBbwu/Fqjup12Su73Tkv/963av0cDpXZL9fp
	7OTW8H1p7FLktvLH8bYVElZf2XIfz79bKlG5aGbnlTq5ZWmbVnobb//mIZZocDlUmnMLp/bM
	7NW38uR2PRJ8Yl+8+HbwnmxnJZbijERDLeai4kQA1HKvkWMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2013-08-06 at 17:16 +0800, Bob Liu wrote:
> On 08/06/2013 02:42 PM, Krzysztof Kozlowski wrote:
> > This reclaim process is different than zbud_reclaim_page(). It acts more
> > like swapoff() by trying to unuse pages stored in zbud page and bring
> > them back to memory. The standard zbud_reclaim_page() on the other hand
> > tries to write them back.
> 
> I prefer to migrate zbud pages directly if it's possible than reclaiming
> them during compaction.

I think it is possible however it would be definitely more complex. In
case of migration the zswap handles should be updated as they are just
virtual addresses. Am I right?

Best regards,
Krzysztof


