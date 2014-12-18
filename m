Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaLRII6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 03:08:58 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:44760 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaLRII4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 03:08:56 -0500
X-AuditID: cbfee68e-f79b46d000002b74-c9-54928b963275
Date: Thu, 18 Dec 2014 17:07:43 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Changman Lee'" <cm224.lee@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: merge two uchar variable in struct
 node_info to reduce memory cost
Message-id: <20141218080743.GA3335@lcm>
References: <000001d0184a$3f09d580$bd1d8080$@samsung.com>
 <CAN863PvqCJJ-m3NimjX7FKeY941rjSgmzupfPEMHm_qXgRBwfQ@mail.gmail.com>
 <004c01d01a96$2b5b3a80$8211af80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <004c01d01a96$2b5b3a80$8211af80$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsWyRsSkTXda96QQg60XpS3+N31kszjT081m
	8WT9LGaLS4vcLfbsPclicXnXHDYHNo+ds+6ye2xa1cnmsXvBZyaPvi2rGD0+b5ILYI3isklJ
	zcksSy3St0vgymhatJilYDJfxYGlvxgbGJ9zdTFyckgImEh8ffONDcIWk7hwbz2YLSSwlFFi
	9b90mJodT/ZBxRcxStzYzN7FyAVk/2SUuLNuBRNIgkVAVeLIqZ2sIDabgJZE++m1LCC2iICS
	xK/5i8DizAJbGSV2LI8GsYUFciU2LFvBCGLzCqhLvJr/jA1i6AZGidufDrJAJAQlfky+xwLR
	rCWxfudxJghbWuLR3xnsIDangJXEsUNHwa4TFVCRmHJyG9ggCYFD7BLvZ69nhbhOQOLb5ENA
	gziAErISmw4wQ3wmKXFwxQ2WCYxis5Csm4Vk3Swk6xYwMq9iFE0tSC4oTkovMtIrTswtLs1L
	10vOz93ECIy10/+e9e1gvHnA+hCjAAejEg+vhN6kECHWxLLiytxDjKZAV0xklhJNzgdGdF5J
	vKGxmZGFqYmpsZG5pZmSOG+C1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzae/w3rYo8
	cOf6PJ77+Zoet8vdG4w1fMKe7M7ZPZ3b5HgN61RtvZjG6KKQzp3ltocM/jK/DElZJP384qMV
	oe/mzdmpqKsVsPXgv68LhTg+zeFTmSN1gm/a9tcpjjXxMb/2Hqw5c3DH7TcVxXaLWBPXxsa9
	Cdu6L6b2CQPvs6P1yW/n/zB56pelxFKckWioxVxUnAgAnOALRrACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jAd1p3ZNCDHbMFbf43/SRzeJMTzeb
	xZP1s5gtLi1yt9iz9ySLxeVdc9gc2Dx2zrrL7rFpVSebx+4Fn5k8+rasYvT4vEkugDWqgdEm
	IzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gCJYWyxJxS
	oFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWNG06LFLAWT+SoOLP3F2MD4nKuLkZND
	QsBEYseTfWwQtpjEhXvrwWwhgUWMEjc2s3cxcgHZPxkl7qxbwQSSYBFQlThyaicriM0moCXR
	fnotC4gtIqAk8Wv+IrA4s8BWRokdy6NBbGGBXIkNy1Ywgti8AuoSr+Y/Y4MYuoFR4vangywQ
	CUGJH5PvsUA0a0ms33mcCcKWlnj0dwY7iM0pYCVx7NBRsOtEBVQkppzcxjaBUWAWkvZZSNpn
	IWlfwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4lp9J72Bc1WBxiFGAg1GJh1dCb1KI
	EGtiWXFl7iFGCQ5mJRHe6BygEG9KYmVValF+fFFpTmrxIUZTYHBMZJYSTc4Hppm8knhDYxMz
	I0sjMwsjE3NzJXFeJfu2ECGB9MSS1OzU1ILUIpg+Jg5OqQZGKcVy3hMqF4s/TC01lP3bKTOb
	3cBtt+uMZVtVZ65Qd7iygtm5OnGlz6Vt380fpLXHPY3LNJ4T/7yNpWH3+9CmJbaHHi+bLrDz
	6467SfHV8osep09Jmh0cMqN3caTnpspkD2GzFQ3c2TW7l7TvZ3ptrnXhUtVhw1UZme/fHE3V
	qo0NfpvWNPGqEktxRqKhFnNRcSIAkwRAaPsCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 02:29:51PM +0800, Chao Yu wrote:
> Hi Changman,
> 
> > -----Original Message-----
> > From: Changman Lee [mailto:cm224.lee@gmail.com]
> > Sent: Wednesday, December 17, 2014 11:09 PM
> > To: Chao Yu
> > Cc: Jaegeuk Kim; Changman Lee; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Subject: Re: [f2fs-dev] [PATCH v2] f2fs: merge two uchar variable in struct node_info to reduce
> > memory cost
> > 
> > Hi Yu,
> > 
> > This patch is effective only in 32 bit machine. In case of 64 bit
> > machine, nat_entry will be aligned in 8 bytes due to pointer variable
> > (i.e. struct list_head). So it can't get any benefit to reduce memory
> > usage. In the case of node_info, however, it will be gain in terms of
> > memory usage.
> > Hence, I think it's not correct for commit log to describe this patch.
> > 
> 
> Thanks for your review! :)
> 
> AFFIK, in 64 bit machine, size of struct nat_entry is 40 bytes before this patch
> apply, the reason is that our compiler will fill 3 bytes pads after flag as
> nid's offset should align to type size of nid, and then fill 7 byte pads after
> version as size of structure should align to 64 bits when the struct size is bigger
> than 64 bits.
> layout of struct nat_entry:
> |-----8 bytes-----|
> |list.next        |
> |list.prev        |
> |flag    |nid     |
> |ino     |blk_addr|
> |version          |
> After we apply this patch, size of struct nat_entry will be reduced to 32 bytes.
> Please correct me if I'm wrong.

Hi,

Sorry, you're right.
I miscalculated.

Thanks,

> 
> Anyway, I agreed that commit log should be uptodate.
> 
> Thanks,
> Yu
> 
> > Thanks,
> > 
> > Reviewed-by: Changman Lee <cm224.lee@samsung.com>
> > 
