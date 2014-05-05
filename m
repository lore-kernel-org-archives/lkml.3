Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaEEH4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:56:13 -0400
Received: from mout.gmx.net ([212.227.17.21]:64598 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbaEEH4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:56:12 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: jaegeuk.kim@samsung.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: f2fs causes system stall
Date: Mon, 05 May 2014 09:56:07 +0200
Message-ID: <1654591.8eRFrlOYSj@fb07-iapwap2>
User-Agent: KMail/4.12.4 (Linux/3.15.0-rc3-12.gfc9498b-desktop+; KDE/4.12.4; x86_64; ; )
In-Reply-To: <20140425143900.b9a7fe8a31287b5bbd5dff20@gmx.de>
References: <2601952.jk1l5iHOJT@ax5200p> <1398382436.4283.21.camel@kjgkr> <20140425143900.b9a7fe8a31287b5bbd5dff20@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="US-ASCII"
X-Provags-ID: V03:K0:HlOM2b/Y+tGxkUUVfnGIsW3kj2PfoMpCgPvU0zOCktU7gh3EBJR
 TmaoZR4icVXCseeqH4RODyUKoIKP+tnlqZYSqbODxI3LjZL7W5CXniTbE7HYbt9JrEo5y3m
 I46kGiH1SBZxV9MqKwtn8fRH81p0P03gWpGRUGA6xKe7vj1SVg0M1o8Th00vqeHAdsotTx2
 H6MSv30QxCEfegONkXZOw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaeguek,

Am Freitag, 25. April 2014, 14:39:00 schrieb Marc Dietrich:
> On Fri, 25 Apr 2014 08:33:56 +0900
> 
> Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:
> > Thank you very much.
> > 
> > Could you test the following patch?
> 
> seems to be fixed now. Thanks!

are you planing to submit this fix ("f2fs: submit bio at the reclaim path") to 
3.15?

Thanks,

Marc

> 
> > ---
> > 
> >  fs/f2fs/data.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index 150c12a..0147de7 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > 
> > @@ -833,6 +833,8 @@ out:
> >  	unlock_page(page);
> >  	if (need_balance_fs)
> >  	
> >  		f2fs_balance_fs(sbi);
> > 
> > +	if (wbc->for_reclaim)
> > +		f2fs_submit_merged_bio(sbi, DATA, WRITE);
> > 
> >  	return 0;
> >  
> >  redirty_out:

