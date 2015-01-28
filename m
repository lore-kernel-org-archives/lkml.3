Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934781AbbA1E7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:59:05 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52782 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933440AbbA1E7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:59:03 -0500
Date: Wed, 28 Jan 2015 13:58:55 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 1/2] zram: free meta out of init_lock
Message-ID: <20150128045855.GD32712@blaptop>
References: <20150127021704.GA665@swordfish>
 <20150127031823.GA16797@blaptop>
 <20150127040305.GB665@swordfish>
 <20150128001526.GA25828@blaptop>
 <20150128002203.GB25828@blaptop>
 <20150128020759.GA343@swordfish>
 <20150128025707.GB32712@blaptop>
 <20150128035354.GA7790@swordfish>
 <20150128040757.GA577@swordfish>
 <20150128045028.GB577@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128045028.GB577@swordfish>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 01:50:28PM +0900, Sergey Senozhatsky wrote:
> On (01/28/15 13:07), Sergey Senozhatsky wrote:
> > On (01/28/15 12:53), Sergey Senozhatsky wrote:
> > > > So, I want to go with srcu. Do you agree? or another suggestion?
> > > 
> > > yes, I think we need to take a second look on srcu approach.
> > > 
> > 
> > ... or we can ask lockdep to stop false alarming us and leave it as is.
> > I wouldn't say that ->init_lock is so hard to understand.
> > just as an option.
> > 
> 
> so... returning back to barriers performance implications.
> 
> x86_64, lzo, 4 comp streams, 2G zram, ext4, mount -o rw,relatime,data=ordered
> 
>  ./iozone -t 3 -R -r 16K -s 60M -I +Z
> 
>        test           base          srcu
> "  Initial write " 1299639.75   1277621.03
> "        Rewrite " 2139387.50   2004663.94
> "           Read " 6193415.00   5091000.00
> "        Re-read " 6199050.38   4814297.88
> "   Reverse Read " 4693868.88   4367201.75
> "    Stride read " 4470633.75   4247550.00
> "    Random read " 5115339.50   4517352.75
> " Mixed workload " 4340747.06   3880517.31
> "   Random write " 1982369.75   1892456.25
> "         Pwrite " 1352550.22   1248667.78
> "          Pread " 2853150.06   2445154.41
> "         Fwrite " 2367397.81   2262384.56
> "          Fread " 8100746.50   7578071.75
> 
> not good.
> 

Oops, I never thought it could make mesurable performance.
I will investigate it.

Thanks a lot, Sergey!

> 	-ss

-- 
Kind regards,
Minchan Kim
