Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaLTAzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 19:55:09 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62524 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbaLTAzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 19:55:07 -0500
Date: Sat, 20 Dec 2014 09:54:58 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ganesh Mahendran <opensource.ganesh@gmail.com>, ngupta@vflare.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/zsmalloc: add statistics support
Message-ID: <20141220005458.GA15630@blaptop>
References: <1418993719-14291-1-git-send-email-opensource.ganesh@gmail.com>
 <20141219143244.1e5fabad8b6733204486f5bc@linux-foundation.org>
 <20141219233937.GA11975@blaptop>
 <20141219154548.3aa4cc02b3322f926aa4c1d6@linux-foundation.org>
 <20141219235852.GB11975@blaptop>
 <20141219160648.5cea8a6b0c764caa6100a585@linux-foundation.org>
 <20141220001043.GC11975@blaptop>
 <20141219161756.bcf7421acb4bc7a286c1afa3@linux-foundation.org>
 <20141220002303.GD11975@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141220002303.GD11975@blaptop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 09:23:03AM +0900, Minchan Kim wrote:
> On Fri, Dec 19, 2014 at 04:17:56PM -0800, Andrew Morton wrote:
> > On Sat, 20 Dec 2014 09:10:43 +0900 Minchan Kim <minchan@kernel.org> wrote:
> > 
> > > > It involves rehashing a lengthy argument with Greg.
> > > 
> > > Okay. Then, Ganesh,
> > > please add warn message about duplicaed name possibility althoug
> > > it's unlikely as it is.
> > 
> > Oh, getting EEXIST is easy with this patch.  Just create and destroy a
> > pool 2^32 times and the counter wraps ;) It's hardly a serious issue
> > for a debugging patch.
> 
> I meant that I wanted to change from index to name passed from caller like this
> 
> zram:
> 	zs_create_pool(GFP_NOIO | __GFP_HIGHMEM, zram->disk->first_minor);

Correction for clear my intention

	sprintf(buf, "%zram%d", zram->disk->first_minor);
 	zs_create_pool(GFP_NOIO | __GFP_HIGHMEM, buf);
	
