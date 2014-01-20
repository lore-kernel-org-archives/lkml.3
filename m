Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaATN7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:59:10 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40071 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbaATN66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:58:58 -0500
Date: Mon, 20 Jan 2014 05:58:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Sergey Meirovich <rathamahata@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gluk <git.user@gmail.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Message-ID: <20140120135855.GA26280@infradead.org>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz>
 <20140107155830.GA28395@infradead.org>
 <CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com>
 <20140108140307.GA588@infradead.org>
 <CA+QCeVRuvNtZ8+9D-NtMOD=B9UEA5HMvKaGdXOQCjO-KTnZdbw@mail.gmail.com>
 <20140115220721.GY3469@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115220721.GY3469@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 09:07:21AM +1100, Dave Chinner wrote:
> Yes, I think it can be done relatively simply. We'd have to change
> the code in xfs_file_aio_write_checks() to check whether EOF zeroing
> was required rather than always taking an exclusive lock (for block
> aligned IO at EOF sub-block zeroing isn't required),

That's not even required for supporting aio appends, just a further
optimization for it.

> and then we'd
> have to modify the direct IO code to set the is_async flag
> appropriately. We'd probably need a new flag to say tell the DIO
> code that AIO beyond EOF is OK, but that isn't hard to do....

Yep, need a flag to allow appending writes and then defer them.

> Christoph, are you going to get any time to look at doing this in
> the next few days?

I'll probably need at least another week before I can get to it.  If you
wanna pick it up before than feel free.

