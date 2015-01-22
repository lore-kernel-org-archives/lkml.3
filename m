Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbbAVUt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:49:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbbAVUt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:49:57 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@fb.com>
Cc: Huang Ying <ying.huang@intel.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [block] 34b48db66e0: +3291.6% iostat.sde.wrqm/s
References: <1421889689.6126.45.camel@intel.com> <54C08CA6.8050101@fb.com>
	<x49zj9a9073.fsf@segfault.boston.devel.redhat.com>
	<54C1494D.5050507@fb.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 22 Jan 2015 15:49:49 -0500
In-Reply-To: <54C1494D.5050507@fb.com> (Jens Axboe's message of "Thu, 22 Jan
	2015 12:02:37 -0700")
Message-ID: <x49fvb28rrm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@fb.com> writes:

>> Agreed on all above, but are the actual benchmark numbers included
>> somewhere in all this mess?  I'd like to see if the benchmark numbers
>> improved first, before digging into the guts of which functions are
>> called more or which stats changed.
>
> I deleted the original email, but the latter tables had drive throughput
> rates and it looked higher for the ones I checked on the newer kernel.
> Which the above math would indicate as well, multiplying reqs-per-sec
> and req-size.

Looking back at the original[1], I think I see the throughput numbers for
iozone.  The part that confused me was that each table mixes different
types of data.  I'd much prefer if different data were put in different
tables, along with column headers that stated what was being reported
and the units for the measurements.

Anyway, I find the increased service time troubling, especially this
one:

testbox/testcase/testparams: ivb44/fsmark/performance-1x-1t-1HDD-xfs-4M-60G-NoSync

       544 ?  0%   +1268.9%       7460 ?  0%  iostat.sda.w_await
       544 ?  0%   +1268.5%       7457 ?  0%  iostat.sda.await

I'll add this to my queue of things to look into.

Cheers,
Jeff

[1] https://lkml.org/lkml/2015/1/21/846
