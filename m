Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaATWSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:18:51 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:20245 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbaATWSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:18:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj4IAFGg3VJ5LKVw/2dsb2JhbABZgwuDObNZhVKBFRd0giUBAQEDATocIxAIAw4KCRoLDwUlAyETh30HxAgXFo4gSQeEOASYIYpPh0qBb4FSKIEt
Date: Tue, 21 Jan 2014 09:18:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Sergey Meirovich <rathamahata@gmail.com>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gluk <git.user@gmail.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Message-ID: <20140120221843.GJ18112@dastard>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz>
 <20140107155830.GA28395@infradead.org>
 <CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com>
 <20140108140307.GA588@infradead.org>
 <CA+QCeVRuvNtZ8+9D-NtMOD=B9UEA5HMvKaGdXOQCjO-KTnZdbw@mail.gmail.com>
 <20140115220721.GY3469@dastard>
 <20140120135855.GA26280@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120135855.GA26280@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 05:58:55AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 16, 2014 at 09:07:21AM +1100, Dave Chinner wrote:
> > Yes, I think it can be done relatively simply. We'd have to change
> > the code in xfs_file_aio_write_checks() to check whether EOF zeroing
> > was required rather than always taking an exclusive lock (for block
> > aligned IO at EOF sub-block zeroing isn't required),
> 
> That's not even required for supporting aio appends, just a further
> optimization for it.

Oh, right, I got an off-by-one when reading the code - the EOF
zeroing only occurs when the offset is beyond EOF, not at or beyond
EOF...

> > and then we'd
> > have to modify the direct IO code to set the is_async flag
> > appropriately. We'd probably need a new flag to say tell the DIO
> > code that AIO beyond EOF is OK, but that isn't hard to do....
> 
> Yep, need a flag to allow appending writes and then defer them.
> 
> > Christoph, are you going to get any time to look at doing this in
> > the next few days?
> 
> I'll probably need at least another week before I can get to it.  If you
> wanna pick it up before than feel free.

I'm probably not going to get to it before then, either, so check
back in a week?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
