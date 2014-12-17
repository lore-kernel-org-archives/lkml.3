Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaLQKGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:06:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:11503 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaLQKGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:06:33 -0500
X-AuditID: cbfee61a-f79c06d000004e71-31-5491559fe9bb
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <003e01d0152b$a7fd0b60$f7f72220$@samsung.com>
 <20141217060436.GA7624@jaegeuk-mac02.mot-mobility.com>
In-reply-to: <20141217060436.GA7624@jaegeuk-mac02.mot-mobility.com>
Subject: RE: [f2fs-dev][PATCH] f2fs: use ra_meta_pages to simplify readahead
 code in restore_node_summary
Date: Wed, 17 Dec 2014 18:04:51 +0800
Message-id: <001c01d019e1$1c949560$55bdc020$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIk3I3yxPaN7cN0WO4wVugkYeYO4gHeecmpm9sIlGA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jAd35oRNDDPa/lrS4tq+RyeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	Og9uZi+YzlNxeu0U1gbGW5xdjJwcEgImEgef/2CEsMUkLtxbz9bFyMUhJLCIUeJsQzMzhPOD
	UeLx0wssIFVsAioSyzv+M4HYIgJqEr37pjCBFDELTGaUmNV3FywhJFAk8XpLH5jNKeAs0Xjp
	GjuILSyQLfG7+wTQCg4OFgFViZ/H3EDCvAKWEssezWCCsAUlfky+B7aLWUBLYv3O40wQtrzE
	5jVvmSEuVZDYcfY1I8QNVhL3tu5ih6gRl9h45BbLBEahWUhGzUIyahaSUbOQtCxgZFnFKJpa
	kFxQnJSea6hXnJhbXJqXrpecn7uJERwPz6R2MK5ssDjEKMDBqMTD+/L6hBAh1sSy4srcQ4wS
	HMxKIryfAyeGCPGmJFZWpRblxxeV5qQWH2KU5mBREudVsm8LERJITyxJzU5NLUgtgskycXBK
	NTDGahsyTNn6sYfp1DExrtRZH+y4GlsNXx+cN92pRWfbgQr+raqfNMQMAlebe6/saZx+t0Va
	OcYo5sS9+Oai248Wv/+l+Wc7b/vilRts5Vf+ep3W/7Nw0pWyR0xp59ICEkOtdB4qbPowW6r7
	ecnWRyz7lnX0Lzz5poypf8uMSa/ORd698EDJtjRRiaU4I9FQi7moOBEAfOMQn4MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, December 17, 2014 2:05 PM
> To: Chao Yu
> Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][PATCH] f2fs: use ra_meta_pages to simplify readahead code in
> restore_node_summary
> 
> Hi Chao,
> 
> On Thu, Dec 11, 2014 at 06:16:27PM +0800, Chao Yu wrote:
> > Use more common function ra_meta_pages() with META_POR to readahead node blocks
> > in restore_node_summary() instead of ra_sum_pages(), hence we can simplify the
> > readahead code there, and also we can remove unused function ra_sum_pages().
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/node.c | 67 ++++++++++++----------------------------------------------
> >  1 file changed, 14 insertions(+), 53 deletions(-)

[snip]

> > -		invalidate_mapping_pages(inode->i_mapping, addr,
> > -							addr + nrpages);
> > +		truncate_inode_pages_range(META_MAPPING(sbi),
> > +						addr, addr + nrpages);
> 
> I found a bug here. :)

Thank you for your review! :)

> The truncate_inode_pages_range uses start and end parameters as byte offsets.
> So, you should use like (addr << PAGE_CACHE_SHIFT).
> 

Yes, you're correct, I will fix this and send v2 patch.

Regards,
Yu

> Thanks,
> 
> >  	}
> > -	return err;
> > +	return 0;
> >  }
> >
> >  static void remove_nats_in_journal(struct f2fs_sb_info *sbi)
> > --
> > 2.1.2

