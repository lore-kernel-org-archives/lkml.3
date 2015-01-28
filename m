Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbbA1Ubl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:31:41 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52041 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334AbbA1Ubi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:31:38 -0500
Date: Thu, 29 Jan 2015 00:04:24 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Ganesh Mahendran <opensource.ganesh@gmail.com>,
        sergey.senozhatsky.work@gmail.com
Subject: Re: [PATCH v1 2/2] zram: remove init_lock in zram_make_request
Message-ID: <20150128150424.GC965@swordfish>
References: <1422432945-6764-1-git-send-email-minchan@kernel.org>
 <1422432945-6764-2-git-send-email-minchan@kernel.org>
 <20150128145651.GB965@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128145651.GB965@swordfish>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/28/15 23:56), Sergey Senozhatsky wrote:
> > -static inline int init_done(struct zram *zram)
> > +static inline bool init_done(struct zram *zram)
> >  {
> > -	return zram->meta != NULL;
> > +	/*
> > +	 * init_done can be used without holding zram->init_lock in
> > +	 * read/write handler(ie, zram_make_request) but we should make sure
> > +	 * that zram->init_done should set up after meta initialization is
> > +	 * done. Look at setup_init_done.
> > +	 */
> > +	bool ret = zram->init_done;
> 
> I don't like re-introduced ->init_done.
> another idea... how about using `zram->disksize == 0' instead of
> `->init_done' (previously `->meta != NULL')? should do the trick.
> 

a typo, I meant `->disksize != 0'.

	-ss
