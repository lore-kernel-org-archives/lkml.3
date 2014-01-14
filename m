Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaANN4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:56:49 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57546 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaANN4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:56:47 -0500
Date: Tue, 14 Jan 2014 16:53:55 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] zram: rework reported to end-user zram statistics
Message-ID: <20140114135355.GC2226@swordfish.minsk.epam.com>
References: <1389692260-4421-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389692260-4421-4-git-send-email-sergey.senozhatsky@gmail.com>
 <52D513BD.7000800@redhat.com>
 <20140114111012.GC2180@swordfish.minsk.epam.com>
 <52D53F11.3090005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D53F11.3090005@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/14/14 14:43), Jerome Marchand wrote:
[..]
> >>
> >> That's weird: good/bad_compress are accounted, but it seems to me that
> >> they are to never used in any way. If so, there is indeed no reason to
> >> keep them.
> >>
> >>
> >>> Account each sub-request
> >>> compression size so we can calculate real device compression ratio.
> >>
> >> Your patch doesn't change the way pages_stored and compr[essed]_size
> >> are accounted. What does your patch change that allow us to calculate
> >> the "real" compression ratio?
> >>
> >>>
> >>> 4) reported zram stats:
> >>>   - num_writes  -- number of writes
> >>>   - num_reads  -- number of reads
> >>>   - pages_stored -- number of pages currently stored
> >>>   - compressed_size -- compressed size of pages stored
> >>
> >> Wouldn't it be more practical to report the original and compressed
> >> data sizes using the same units as it is currently done?
> >>
> > 
> > hm, do we really need pages_stored stats? what kind of unseful information it
> > shows to end user?.. perhaps, it's better to replace it with accounted passed
> > bvec->bv_len (as uncompressed_size).
> > 
> 
> That's really going to complicates things. We would need to keep track
> of which sectors of a particular page has been written to. It's much
> easier to keep current page granularity and consider any partial I/O
> as an whole page I/O.
> 

fair enough. thank you.

2/3 and 3/3 were changed according to your comments:
- 2/3 drop READA check
- 3/3 update commit message.

ready to re-publish. may I add your ACK to all 3 patches or just to 1/3?

	-ss

> > 
> >> Jerome
> >>
> >>>   - pages_zero  -- number of zero filled pages
> >>>   - failed_read -- number of failed reads
> >>>   - failed_writes -- can happen when memory is too low
> >>>   - invalid_io   -- non-page-aligned I/O requests
> >>>   - notify_free  -- number of swap slot free notifications
> >>>   - memory_used -- zs pool zs_get_total_size_bytes()
> >>>
> >>> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> 
