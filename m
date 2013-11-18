Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab3KRJMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:12:09 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:42044 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3KRJMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:12:01 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7f866d000001b8c-7c-5289d9dfd98d
Content-transfer-encoding: 8BIT
Message-id: <1384765870.26319.16.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH V2 1/2] f2fs: add a new function to support for
 merging contiguous read
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=27=E8=B0=AD=E5=A7=9D=27?= <shu.tan@samsung.com>
Date: Mon, 18 Nov 2013 18:11:10 +0900
In-reply-to: <000901cee3fe$edfa8660$c9ef9320$@samsung.com>
References: <000001cee293$3b6e3030$b24a9090$@samsung.com>
 <1384734560.26319.10.camel@kjgkr> <000901cee3fe$edfa8660$c9ef9320$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zfd37NzuDDHZsMbD43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxpcrr1kL
	VglV9P38w9rAuJGvi5GDQ0LARGLhc8EuRk4gU0ziwr31bF2MXBxCAssYJc7vXMoEkTCRmHdw
	KpgtJLCIUaJ7RymIzSsgKPFj8j0WkDnMAvISRy5lg4SZBdQlJs1bxAwx5xWjRMunPjaIel2J
	GzdbmEFsYYEMicapk1hBetkEtCU27zeAGK8o8Xb/XVYQW0RASeLX/EWsIHOYBZYzSjyffI4F
	JMEioCox48UOsCJOASuJGSeOsUMs62aUOD73N1iCX0BU4vDC7cwQDyhJ7G7vBCuSELjELjHl
	xjI2iEkCEt8mH2KBhISsxKYDUPWSEgdX3GCZwCgxC8mfsxD+nIXkzwWMzKsYRVMLkguKk9KL
	TPWKE3OLS/PS9ZLzczcxQiJv4g7G+wesDzEmA22cyCwlmpwPjNy8knhDYzMjC1MTU2Mjc0sz
	0oSVxHnTHyUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBkXMvHk6NVrSQrv/1hfMTOcw72
	63fnMyhelFGaa+navaDqb84yoYcS8q8k90lt+6rIUz65tcjy+eqezXuYL3vPn7tW0WNFdcYz
	JevwF9Jzb/3Y0LlK/nJVjZJIi2NN+iSdX/+KvmrOCPDxczMJ/7fx1JV5S24eaOoPyhW/eFjG
	+8LvsBYRSW4lluKMREMt5qLiRACHWYyT0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd37NzuDDL5/1bb43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8aXK69ZC1YJVfT9/MPawLiRr4uRk0NCwERi3sGpTBC2mMSFe+vZ
	QGwhgUWMEt07SkFsXgFBiR+T77F0MXJwMAvISxy5lA0SZhZQl5g0bxFzFyMXUPkrRomWT31s
	EPW6EjdutjCD2MICGRKNUyexgvSyCWhLbN5vADFeUeLt/rusILaIgJLEr/mLWEHmMAssZ5R4
	PvkcC0iCRUBVYsaLHWBFnAJWEjNOHGOHWNbNKHF87m+wBL+AqMThhduZIR5Qktjd3sk+gVFo
	FpK7ZyHcPQvJ3QsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEf2M6kdjCsbLA4xCnAw
	KvHwaoR1BgmxJpYVV+YeYpTgYFYS4V1xAyjEm5JYWZValB9fVJqTWnyIMRno8onMUqLJ+cCk
	k1cSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjCdfNZRq2095
	9KrocnOjZT1X+6XGk6nn5+0Tfbqw85mj/fxn26rZ/z14YO07qSHfS34r7/GnO1NF/uV0nPU+
	rzb70PFp3ee3JEy7n+9hd/PQicMbHk56oPhmh6vEijP3T61QOpbst5356I6LNgVzC55vaM36
	fcuwKYKj9XNgpiy38o2v8hPnZccosRRnJBpqMRcVJwIAYWeO2jADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-11-18 (월), 09:37 +0800, Chao Yu:
> Hi Kim,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Monday, November 18, 2013 8:29 AM
> > To: Chao Yu
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> > Subject: Re: [f2fs-dev] [PATCH V2 1/2] f2fs: add a new function to support for merging contiguous read
> > 
> > Hi Chao,
> > 
> > 2013-11-16 (토), 14:14 +0800, Chao Yu:
> > > For better read performance, we add a new function to support for merging contiguous read as the one for write.
> > 
> > Please consider 80 columns for the description.
> > I cannot fix this at every time though. :(
> 
> Got it, sorry about my carelessness in previous patch.
> 
> > 
> > >
> > > v1-->v2:
> > >  o add declarations here as Gu Zheng suggested.
> > >
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > Acked-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> > > ---
> > >  fs/f2fs/data.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/f2fs/f2fs.h |    4 ++++
> > >  2 files changed, 49 insertions(+)
> > >
> > > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > > index aa3438c..18107cb 100644
> > > --- a/fs/f2fs/data.c
> > > +++ b/fs/f2fs/data.c
> > > @@ -404,6 +404,51 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
> > >  	return 0;
> > >  }
> > >
> > > +void f2fs_submit_read_bio(struct f2fs_sb_info *sbi, int rw)
> > > +{
> > > +	down_read(&sbi->bio_sem);
> > 
> > Is there any reason to use down_read()?
> 
> Isn't that we use bio_sem to let w/r or w/w submitting be mutex?

As I examined the bio_sem, I think we don't need to use a semaphore for
read and write IOs.
Just it is enough to use a mutex for writes only.

> 
> > It seems that we need to declare sbi->bio_read and sbi->bio_write
> > instead of sbi->bio_sem.
> > In addition to that, we need to use down_write(&sbi->bio_read) here.
> 
> If so, it looks similar between (struct rw_semaphore) sbi->bio_read 
> and (struct bio *) sbi->read_bio.
> How about using read_bio_sem/rbio_sem to differentiate 
> from sbi->read_bio?

I think sbi->write_mutex and sbi->read_mutex are much better.

Could you refer the following patches?
Thanks,

-- 
Jaegeuk Kim
Samsung

