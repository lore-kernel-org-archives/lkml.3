Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaF3Dus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 23:50:48 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:15413 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751757AbaF3Dup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 23:50:45 -0400
X-IronPort-AV: E=Sophos;i="5.00,804,1396972800"; 
   d="scan'208";a="32600004"
Message-ID: <53B0DBE2.9030300@cn.fujitsu.com>
Date: Mon, 30 Jun 2014 11:39:14 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Jens <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>,
        Kent <kmo@daterainc.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] bio-integrity: add "bip_max_vcnt" into struct bio_integrity_payload
References: <53AD4385.8080105@cn.fujitsu.com> <yq1fvin9uje.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1fvin9uje.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,
On 06/30/2014 07:15 AM, Martin K. Petersen wrote:

>>>>>> "Gu" == Gu Zheng <guz.fnst@cn.fujitsu.com> writes:
> 
> [Sorry about the delay. I'm on vacation right now.]
> 
> Gu> But it seems that bip_integrity_vecs() will return the wrong number
> Gu> if the bio is not based on any bio_set for some reason(bio->bi_pool
> Gu> == NULL), because in that case, the bip_inline_vecs[0] is malloced
> Gu> directly.  So here we add the bip_max_vcnt to record the count of
> Gu> vector slots, and cleanup the function bip_integrity_vecs().
> 
> I'm in agreement with your fix.

Thanks.

> 
> However, I'm still not sure what the use case is for bios without an
> associated bioset. I do not see any callers that pass in a NULL bioset.

Please refer to bio_kmalloc()--alloc bio via kmalloc.
And IMO, the API(e.g. bio_alloc_bioset) is EXPORT, any guys(including
some out of mainline code, some special drivers) can alloc a bio via
kmalloc without based on associated bioset.

Regards,
Gu

> 


