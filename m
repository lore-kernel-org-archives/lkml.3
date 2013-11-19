Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab3KSBms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 20:42:48 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:12863 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3KSBmr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 20:42:47 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-1b-528ac215d77b
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <000001cee293$3b6e3030$b24a9090$@samsung.com>
 <1384734560.26319.10.camel@kjgkr>
 <000901cee3fe$edfa8660$c9ef9320$@samsung.com> <1384765870.26319.16.camel@kjgkr>
In-reply-to: <1384765870.26319.16.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH V2 1/2] f2fs: add a new function to support for
 merging contiguous read
Date: Tue, 19 Nov 2013 09:41:54 +0800
Message-id: <001101cee4c8$a51286d0$ef379470$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQEjOp1BQ4p72/eUWik9AupolSecHAFKR9WBAljK8Y8CUi66IptTYK2g
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jQV3RQ11BBvuvC1tc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxrRJ29gK
	7ktUfPqk0MC4WbiLkZNDQsBEom3qHWYIW0ziwr31bF2MXBxCAtMZJTa/+8UO4fxglGjZ9Z4J
	pIpNQEViecd/MFtEQFpi1qd5LCA2s8BsoI7ZjhAN6xkl/v6HaOAU0JO4tWMuWJGwQIZE49RJ
	rCA2i4CqxO4bB8BsXgFLiWPvb7BA2IISPybfgxqqLjFp3iJmCFtb4sm7C6wQpypI7Dj7mhHi
	CDeJLa3NjBA14hIbj9ximcAoNAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz
	0vWS83M3MYKj4Jn0DsZVDRaHGAU4GJV4eCe4dwUJsSaWFVfmHmKU4GBWEuHdvwcoxJuSWFmV
	WpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgTHjdsii/I7uiylaM2TX
	24d3/VnDFfTp1qta23nqxW0Nflc8hL433A7Uj9wunH5/abWr7OWcRpuzAhxR3PdPP6wX2Pn2
	2pF5tucOL/RQiGmcUWdwPmGtSdsFqclm3QoHvJttOF2uZfkVuW1eG9nI9ovr+7ukB/9mvL//
	cYLiqqiag28tS/fXWiuxFGckGmoxFxUnAgAe2UgUfgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Monday, November 18, 2013 5:11 PM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net; '谭姝'
> Subject: RE: [f2fs-dev] [PATCH V2 1/2] f2fs: add a new function to support for
> merging contiguous read
> 
> Hi,
> 
> 2013-11-18 (월), 09:37 +0800, Chao Yu:
> > Hi Kim,
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > > Sent: Monday, November 18, 2013 8:29 AM
> > > To: Chao Yu
> > > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net; 谭姝
> > > Subject: Re: [f2fs-dev] [PATCH V2 1/2] f2fs: add a new function to support for
> merging contiguous read
> > >
> > > Hi Chao,
> > >
> > > 2013-11-16 (토), 14:14 +0800, Chao Yu:
> > > > For better read performance, we add a new function to support for merging
> contiguous read as the one for write.
> > >
> > > Please consider 80 columns for the description.
> > > I cannot fix this at every time though. :(
> >
> > Got it, sorry about my carelessness in previous patch.
> >
> > >
> > > >
> > > > v1-->v2:
> > > >  o add declarations here as Gu Zheng suggested.
> > > >
> > > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > > Acked-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> > > > ---
> > > >  fs/f2fs/data.c |   45
> +++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/f2fs/f2fs.h |    4 ++++
> > > >  2 files changed, 49 insertions(+)
> > > >
> > > > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > > > index aa3438c..18107cb 100644
> > > > --- a/fs/f2fs/data.c
> > > > +++ b/fs/f2fs/data.c
> > > > @@ -404,6 +404,51 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct
> page *page,
> > > >  	return 0;
> > > >  }
> > > >
> > > > +void f2fs_submit_read_bio(struct f2fs_sb_info *sbi, int rw)
> > > > +{
> > > > +	down_read(&sbi->bio_sem);
> > >
> > > Is there any reason to use down_read()?
> >
> > Isn't that we use bio_sem to let w/r or w/w submitting be mutex?
> 
> As I examined the bio_sem, I think we don't need to use a semaphore for
> read and write IOs.
> Just it is enough to use a mutex for writes only.

Agreed, it could also improve efficiency of read/write request concurrent.

> 
> >
> > > It seems that we need to declare sbi->bio_read and sbi->bio_write
> > > instead of sbi->bio_sem.
> > > In addition to that, we need to use down_write(&sbi->bio_read) here.
> >
> > If so, it looks similar between (struct rw_semaphore) sbi->bio_read
> > and (struct bio *) sbi->read_bio.
> > How about using read_bio_sem/rbio_sem to differentiate
> > from sbi->read_bio?
> 
> I think sbi->write_mutex and sbi->read_mutex are much better.
> 
> Could you refer the following patches?

It's better, I will refer your patch.
And how about this following patch to reduce race of write_mutex 
between DATA/NODE/META writer?

> Thanks,
> 
> --
> Jaegeuk Kim
> Samsung

