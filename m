Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaLRJ04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:26:56 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28027 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaLRJ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:26:53 -0500
X-AuditID: cbfee61a-f79c06d000004e71-f1-54929ddb1f82
From: Chao Yu <chao2.yu@samsung.com>
To: "'Changman Lee'" <cm224.lee@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <001d01d019e1$d6ad6c10$84084430$@samsung.com>
 <CAN863PuF-aSNGxe6=5k9LL-9V5maHnNnd7w-Sz2GQPFz-MHC7A@mail.gmail.com>
In-reply-to: <CAN863PuF-aSNGxe6=5k9LL-9V5maHnNnd7w-Sz2GQPFz-MHC7A@mail.gmail.com>
Subject: RE: [f2fs-dev] [PATCH v2] f2fs: use ra_meta_pages to simplify
 readahead code in restore_node_summary
Date: Thu, 18 Dec 2014 17:26:03 +0800
Message-id: <005101d01aa4$c1974760$44c5d620$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQNhD51p/iodgEgv9xHljGqe1appzQKUILEFmV57J5A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t9jQd3bcyeFGPx5pGNxpqebzeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqweO2fdZffYtKqTzWP3gs9MHp83yQWwRHHZpKTmZJalFunbJXBl
	LO4TKTjOUfGo8y9bA2MLexcjJ4eEgInE5+9PoWwxiQv31rN1MXJxCAlMZ5SY8H8NlPODUeL8
	iWesIFVsAioSyzv+M4HYIgI+Ev0//oLZzAKZEnNeT2aFaGhglHi1eA/QWA4OToFgiT+PA0Bq
	hAXyJfYtXc0IEmYRUJWYM9sbJMwrYCmxdP1jJghbUOLH5HssICXMAuoSU6bkQkyXl9i85i0z
	xJ0KEjvOvmaEuMBK4uC8eawQNeISG4/cYpnAKDQLyaRZCJNmIZk0C0nHAkaWVYyiqQXJBcVJ
	6bmGesWJucWleel6yfm5mxjBcfBMagfjygaLQ4wCHIxKPLwSepNChFgTy4orcw8xSnAwK4nw
	RucAhXhTEiurUovy44tKc1KLDzFKc7AoifMq2beFCAmkJ5akZqemFqQWwWSZODilGhh571l5
	LZ6yP2VJ4aTjzLqzPDaEhC8IOB2Zf9gzwJJN6vTZ6Jv7dluZnKquY9qleOuJ82/10hnCfzWv
	p/WeMzlTtz7L4feldZdvcS19+e7cvcPbJRn3TWgS6fSaZbGpOOMYY/SMzMeL2pzPW883/fQs
	tz5hr5nGBUfWBY8+Ok2VWDV95Yc1k1MVlFiKMxINtZiLihMBch0ESn8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Changman,

> -----Original Message-----
> From: Changman Lee [mailto:cm224.lee@gmail.com]
> Sent: Wednesday, December 17, 2014 11:20 PM
> To: Chao Yu
> Cc: Jaegeuk Kim; Changman Lee; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH v2] f2fs: use ra_meta_pages to simplify readahead code in
> restore_node_summary
> 
> Hi,
> 
> Is there any reason to use truncate_inode_pages_range instead of
> invalidate_mapping_pages?
> IMHO, it seems nice to just use invalidate_mapping_pages because pages
> of meta_inode shouldn't be dirty, locked, under writeback or mapped in
> this function.
> If there is my misunderstanding, let me know.

I think you're right, I use truncate_inode_pages_range because just following the
usage of readahead-invalidate pair in recovery flow, but without considering the
difference between them.

I will fix this as you suggested.

> 
> Thanks,
> 
> Reviewed-by: Changman Lee <cm224.lee@samsung.com>

And thanks for your review! :)

Regards,
Yu

