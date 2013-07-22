Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab3GVNZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:25:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41086 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3GVNZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:25:01 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f436d000000f81-6f-51ed32ab4766
Content-transfer-encoding: 8BIT
Message-id: <1374499486.26443.39.camel@kjgkr>
Subject: Re: [PATCH] f2fs: update file name in the inode block during
 f2fs_rename
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Kim Jaegeuk <jaegeuk.kim@gmail.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Jul 2013 22:24:46 +0900
In-reply-to: <20130719074937.GD4165@ZenIV.linux.org.uk>
References: <1374138684-28520-1-git-send-email-jaegeuk.kim@samsung.com>
 <20130718092211.GA4165@ZenIV.linux.org.uk>
 <CAOtxgyetWtucBEQJmCU0nLNk9_r42yQSC1+X1i+iHM18rDge+Q@mail.gmail.com>
 <20130719074937.GD4165@ZenIV.linux.org.uk>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zfd3VRm8DDebMsLC4fWUSi8WlRe4W
	e/aeZLG4vGsOm8X5v8dZHVg9ds66y+6xe8FnJo/Pm+Q8Nj15yxTAEsVlk5Kak1mWWqRvl8CV
	sXDuIraC22IVW7p+szYwfhDsYuTkkBAwkbh7bgIbhC0mceHeeiCbi0NIYBmjRPfisywwRT1T
	PzBBJKYzSix9/xQswSsgKPFj8j0gm4ODWUBe4silbJAws4C6xKR5i5gh6l8zSux4s58Jol5X
	4vyhOUwg9cICwRIv38SDmGwC2hKb9xuAVAgJKEq83X+XFcQWEVCVuHPqDNhaZoEJjBIXF9xi
	BEmwACXWrD7IDGJzCphLzFn+hwVi1wtGiU+f3oAl+AVEJQ4v3M4M8YCSxO72TnaQIgmBW+wS
	P66tY4OYJCDxbfIhsAckBGQlNh2AqpeUOLjiBgvQzllI3pyF8OYsJG8uYGRexSiaWpBcUJyU
	XmSsV5yYW1yal66XnJ+7iREShf07GO8esD7EmAy0cSKzlGhyPjCK80riDY3NjCxMTUyNjcwt
	zUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA6Mb0pXcC8zWBORZnv68MnFpW
	vOq7ilC87txH4be5X5rVyXE8ftjr5dm+/1jasudFbG8X3tic/G9pHcuMCZ1vVDaVFlt2fay5
	nnmRNce3zUFMl+vqxJp1PYcmbLdi/61Zw3uJvyTeskCO/3yIZK7nvQ6pbuXt9trbdx66+nJx
	U12gcc0NXemLSizFGYmGWsxFxYkAMfkOxtgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jQd3VRm8DDR7cMba4fWUSi8WlRe4W
	e/aeZLG4vGsOm8X5v8dZHVg9ds66y+6xe8FnJo/Pm+Q8Nj15yxTAEtXAaJORmpiSWqSQmpec
	n5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFdJoSwxpxQoFJBYXKykb4dp
	QmiIm64FTGOErm9IEFyPkQEaSFjHmLFw7iK2gttiFVu6frM2MH4Q7GLk5JAQMJHomfqBCcIW
	k7hwbz1bFyMXh5DAdEaJpe+fsoAkeAUEJX5Mvgdkc3AwC8hLHLmUDRJmFlCXmDRvETNE/WtG
	iR1v9jNB1OtKnD80hwmkXlggWOLlm3gQk01AW2LzfgOQCiEBRYm3+++ygtgiAqoSd06dYQIZ
	wywwgVHi4oJbjCAJFqDEmtUHmUFsTgFziTnL/7BA7HrBKPHp0xuwBL+AqMThhduZIR5Qktjd
	3sk+gVFoFpKzZyGcPQvJ2QsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMf4M6kdjCsb
	LA4xCnAwKvHwNgS8CRRiTSwrrsw9xCjBwawkwrtR722gEG9KYmVValF+fFFpTmrxIcZkoMsn
	MkuJJucD009eSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTBG
	8dQFqNVERMauOmi191ST4FbL3d6tfwsn79S9n7O6TnKC18TFGmsTN1UaP27iDDHWNND3bD4y
	9bdw4zad3dliTT+kTS9vS6u4v2XRqmrB/182T1LRO8H1ddsHiau5U1q7WYXOfancfVto65o2
	q0dKPU2n1rttlPtpYnb2x4nNT+Rs7px+WHNUiaU4I9FQi7moOBEAtORCcTUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

2013-07-19 (금), 08:49 +0100, Al Viro:
> On Fri, Jul 19, 2013 at 12:40:47PM +0900, Kim Jaegeuk wrote:
> > Hi,
> > 
> > 2013. 7. 18. ???? 6:22?? "Al Viro" <viro@zeniv.linux.org.uk>???? ????:
> > >
> > > On Thu, Jul 18, 2013 at 06:11:23PM +0900, Jaegeuk Kim wrote:
> > > > The error is reproducible by:
> > > >
> > > > After this, when we retrieve the inode->i_name of test2 by dump.f2fs,
> > we get
> > > > test1 instead of test2.
> > > > This is because f2fs didn't update the file name during the f2fs_rename.
> > >
> > > Er...  Correct me if I'm wrong, but f2fs appears to support link(2) and
> > > if rename(2) creates some problem for dump.f2fs, I would expect an
> > > equivalent link()+unlink() combination to do the same...
> > 
> > Right. I will check that too.
> > Thank you. :)
> 
> You do realize that having unlink() hunt for the surviving links would be
> both very costly and painful wrt locking, right?

What I meant that I need to check f2fs_sync_file() to deal with the
link() + unlink() combination case.

> 
> The real question is, what are the warranties for that ->i_name thing?
> What should it be while there are multiple links?  Matter of fact,
> after looking at the users... What about ->i_pino in the same scenario
> (link+unlink instead of rename)?

The only usage of both i_name and i_pino is for the roll-forward
recovery. 

Let me give a scenario like this.
1. create "file a"
2. fsync "file a"
  -> At this moment, in order to recover "file a", naive f2fs needs to
conduct costly checkpoint to flush all the dentry blocks.

But, in the roll-forward machinism with a dentry recovery routine,
1. create "file a"
2. fsync "file a"
  -> The f2fs stores i_name as "file a" and its i_pino so that
recover_dentry() can add link again with "file a" under i_pino.

But, there are some creteria like:
1. link_count should be one, and
2. its i_name should be correct.

But, I think i_pino is correctly fixed at f2fs_sync_file() even if there
have been experienced link() + unlink() combinations before.
But, i_name should have to be fixed too not just for f2fs_rename().
This is what I concerned before.

> 
> BTW, while looking at i_pino... Why does get_parent_ino() bother with
> igrab/iput?  If you have found an alias, just use parent_ino(dentry)
> and be done with that - as it is, you have a race with d_move() there,
> so you'd need to reproduce parent_ino() locking anyway (->d_lock on
> dentry holds d_move() away and stabilizes ->d_parent->d_inode)

Oh, I didn't realize that.
I'll fix like that.
Thanks,

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung

