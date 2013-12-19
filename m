Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3LSJA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:00:58 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:31610 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab3LSJAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:00:53 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f206d000000aee-03-52b2b5c3b7f8
Content-transfer-encoding: 8BIT
Message-id: <1387443585.2101.216.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: move all the bio initialization into
 __bio_alloc
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>,
        "'fsdevel'" <linux-fsdevel@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'f2fs'" <linux-f2fs-devel@lists.sourceforge.net>
Date: Thu, 19 Dec 2013 17:59:45 +0900
In-reply-to: <000a01cefc59$0a9b4580$1fd1d080$@samsung.com>
References: <52B17905.7040708@cn.fujitsu.com>
 <000a01cefc59$0a9b4580$1fd1d080$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zQ93DWzcFGcxYomvxv+kjm8Xz9gPM
	FpcWuVvs2XuSxeLyrjlsDqwe/w9OYvbYveAzk0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	zFqaWDCLo+LQri3sDYwb2boYOTkkBEwk5j07wAxhi0lcuLceKM7FISSwjFHi0MxrzDBF0/9/
	YYRILGKUaNg5FyzBKyAo8WPyPZYuRg4OZgF5iSOXskHCzALqEpPmLWKGqH/FKPHg6WZ2kBpe
	AV2JrW+sQWqEBSIkft5ayAQSZhPQlti83wAkLCSgKPF2/11WEFtEQEni1/xFrCBjmAV2Mko8
	2vGRDaSeRUBVYvGfQBCTU8BKYu0mVYjWWImj/buZQGx+AVGJwwu3Q12vJLG7vZMdZIyEwDV2
	iVVbGsESLAICEt8mHwK7XkJAVmITLBgkJQ6uuMEygVFiFpIfZyH8OAvJjwsYmVcxiqYWJBcU
	J6UXmegVJ+YWl+al6yXn525ihETfhB2M9w5YH2JMBto4kVlKNDkfGL15JfGGxmZGFqYmpsZG
	5pZmpAkrifOqPUoKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cA4X9djVjmP7sdLr+tD7R5w
	M6iU18fpM5ut/xnYwuhqLnM3I5V1VtiPE5eZJ1i/ZAquuicf7tEk3N5TcYktMFFyhtFpU6lr
	TafbFrBuvOnu+HlZf0U3S2byjNOGvE6bNv1/+X5RScq5tvK0fUHTHfN0Vgt6rLX38TdT4lwn
	/sPOi110O1ecpxJLcUaioRZzUXEiAIU9GYnUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd3DWzcFGTxcoGnxv+kjm8Xz9gPM
	FpcWuVvs2XuSxeLyrjlsDqwe/w9OYvbYveAzk0ffllWMHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZsxamlgwi6Pi0K4t7A2MG9m6GDk5JARMJKb//8IIYYtJ
	XLi3HijOxSEksIhRomHnXGaQBK+AoMSPyfdYuhg5OJgF5CWOXMoGCTMLqEtMmreIGaL+FaPE
	g6eb2UFqeAV0Jba+sQapERaIkPh5ayETSJhNQFti834DkLCQgKLE2/13WUFsEQEliV/zF7GC
	jGEW2Mko8WjHRzaQehYBVYnFfwJBTE4BK4m1m1QhWmMljvbvZgKx+QVEJQ4v3M4Mcb2SxO72
	TvYJjEKzkNw8C+HmWUhuXsDIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOLafSe9gXNVg
	cYhRgINRiYc34PnGICHWxLLiytxDjBIczEoivJrLNwUJ8aYkVlalFuXHF5XmpBYfYkwGOnsi
	s5Rocj4w7eSVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2Pa
	umTPL5c9Duoyx9sEC9wLXPBR/sKJf+HvD9Y2re+3mxgq+kCUZUGrToxgdFVVQEDSXfnweZIG
	H6281rne4/1v621s35av9qrg2DJtAY2/rKcvb2L4fP3bxg1vnf2kAti6hbSWab85OLG9+heb
	S+BduW8i4VV3Q30/+Up0OTTslow/vt1AS4mlOCPRUIu5qDgRAIyiYGExAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

I agreed with Chao.
It is more readable to use something like "is_read" instead of "rw".
Thanks,

2013-12-19 (목), 09:23 +0800, Chao Yu:
> Hi Gu,
> 
> > -----Original Message-----
> > From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> > Sent: Wednesday, December 18, 2013 6:29 PM
> > To: Kim
> > Cc: fsdevel; linux-kernel; f2fs
> > Subject: [f2fs-dev] [PATCH] f2fs: move all the bio initialization into __bio_alloc
> > 
> > Move all the bio initialization into __bio_alloc, and some minor cleanups are
> > also added.
> 
> Looks more neat!
> 
> > @@ -178,17 +179,16 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
> >  			block_t blk_addr, struct f2fs_io_info *fio)
> >  {
> >  	enum page_type btype = PAGE_TYPE_OF_BIO(fio->type);
> > -	struct block_device *bdev = sbi->sb->s_bdev;
> >  	struct f2fs_bio_info *io;
> > -	int bio_blocks;
> > +	int rw = is_read_io(fio->rw);
> 
> Maybe it's more neat to use 'is_read' to instead of 'rw'.
> 
> Thanks
> 

-- 
Jaegeuk Kim
Samsung

