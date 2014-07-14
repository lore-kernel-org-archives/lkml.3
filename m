Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbaGNV0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:26:34 -0400
Received: from imap.thunk.org ([74.207.234.97]:34687 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545AbaGNV0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:26:31 -0400
Date: Mon, 14 Jul 2014 17:25:39 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Namjae Jeon <namjae.jeon@samsung.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Dave Chinner'" <david@fromorbit.com>,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Luk?? Czerner'" <lczerner@redhat.com>,
        "'Brian Foster'" <bfoster@redhat.com>,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>, xfs@oss.sgi.com
Subject: Re: [PATCH 2/3] xfs: Add support IOC_MOV_DATA ioctl
Message-ID: <20140714212539.GH8935@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	'Christoph Hellwig' <hch@infradead.org>,
	'Dave Chinner' <david@fromorbit.com>,
	'linux-ext4' <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	'Luk?? Czerner' <lczerner@redhat.com>,
	'Brian Foster' <bfoster@redhat.com>,
	'Ashish Sangwan' <a.sangwan@samsung.com>, xfs@oss.sgi.com
References: <003f01cf9aa4$1e9e5240$5bdaf6c0$@samsung.com>
 <20140708121500.GA518@infradead.org>
 <001801cf9b3f$ad786ff0$08694fd0$@samsung.com>
 <87ha2jsy6p.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ha2jsy6p.fsf@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 08:27:26PM +0400, Dmitry Monakhov wrote:
> Actually they are differ. EXT4_IOC_MOVE_EXT copy data inside kernel,
> but XFS_IOC_SWAPEXT live this job to userpsace see:
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=blob;f=fsr/xfs_fsr.c packfile
> And I'll vote to make EXT4_IOC_MOVE_EXT deprecated, and implement EXT4_IOC_SWAPEXT
> as XFS does that.
> Ted, Lukas what do you think about that?

The reason why EXT4_IOC_MOVE_EXT moves the data via the cache is to
avoid being subject to races if the file happens to mmap'ed and being
actively modified at the time of the defrag operation.  

I'm not sure how XFS handles that case, but if it's not somehow
locking the file against mmap's before it starts the userspace copy,
it would seem to me to be fairly dangerous in terms of prevent
potential data loss in this scenario.  Unless they are doing some
especially clever?

Regards,

						- Ted
