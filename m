Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaFQCeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 22:34:03 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22272 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaFQCeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 22:34:00 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-e1-539fa91696e9
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <001201cf87c6$92b9fad0$b82df070$@samsung.com>
In-reply-to: <001201cf87c6$92b9fad0$b82df070$@samsung.com>
Subject: RE: [f2fs-dev] [PATCH] f2fs: refactor flush_nat_entries codes for
 reducing NAT writes
Date: Tue, 17 Jun 2014 10:33:12 +0800
Message-id: <002301cf89d4$97aaf7f0$c700e7d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHh8KYP10dtC0PDSzBuBmpl0+4OWptPxSuA
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jQV2xlfODDX7/lrV4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK+P3qbdMBW+4Kjbs
	OMTWwHiVo4uRk0NCwETiwYyT7BC2mMSFe+vZQGwhgemMEhdmuHQxcgHZPxglZiz9xgSSYBNQ
	kVje8R/MFhFQk+jdNwXMZhbIlJjzejIrRLOlxJojPxi7GDk4OAWsJJYsMwMJCwskSCz5e5UZ
	xGYRUJV4unEWWDkvUPmd3e+YIWxBiR+T77FAjNSSWL/zONR4eYnNa94yQ9ypILHj7GtGiBOM
	JPaemsoKUSMusfHILZYJjEKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjOOyfSe1gXNlgcYhRgINRiYf3oez8YCHWxLLiytxDjBIczEoivFzmQCHelMTKqtSi
	/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2MZyzWp24617rwhKhhVMiv
	96/LsxqPfhRNOWXx5cZkcZN+pWqOGRxzJEuC01Y+7Kxn3pl/z9/6n5CHLz/X19YVE9zW+/I9
	dLrEzSTJEc32+6P7xB0PT2y9d9J+42oT/vkPs19v02hTWsTdoPmummX+Q9blfeERxW65Upln
	Y07GLmj2L7YOsrVXYinOSDTUYi4qTgQAW+tUQHcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

There are problem in this patch, please ignore this patch, sorry for the noise.
I will resend later.

> -----Original Message-----
> From: Chao Yu [mailto:chao2.yu@samsung.com]
> Sent: Saturday, June 14, 2014 7:48 PM
> To: Jaegeuk Kim
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [PATCH] f2fs: refactor flush_nat_entries codes for reducing NAT writes
> 
> Although building NAT journal in cursum reduce the read/write work for NAT
> block, but previous design leave us lower performance when write checkpoint
> frequently for these cases:
> 1. if journal in cursum has already full, it's a bit of waste that we flush all
>    nat entries to page for persistence, but not to cache any entries.
> 2. if journal in cursum is not full, we fill nat entries to journal util
>    journal is full, then flush the left dirty entries to disk without merge
>    journaled entries, so these journaled entries may be flushed to disk at next
>    checkpoint but lost chance to flushed last time.
> 
> In this patch we merge dirty entries located in same NAT block to nat entry set,
> and linked all set to list, sorted ascending order by entries' count of set.
> Later we flush entries in sparse set into journal as many as we can, and then
> flush merged entries to disk.
> 


