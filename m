Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaDPFHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:07:35 -0400
Received: from imap.thunk.org ([74.207.234.97]:54949 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbaDPFHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:07:33 -0400
Date: Wed, 16 Apr 2014 01:07:29 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Jan Kara <jack@suse.cz>, darrick.wong@oracle.com,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: Ext4: deadlock occurs when running fsstress and ENOSPC errors
 are seen.
Message-ID: <20140416050729.GD21807@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Amit Sahrawat <amit.sahrawat83@gmail.com>, Jan Kara <jack@suse.cz>,
	darrick.wong@oracle.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Namjae Jeon <linkinjeon@gmail.com>
References: <CADDb1s2RvN_S+abFXCe4ZhZPKZgP_PiocJdpiLzRC_Se5sgVVg@mail.gmail.com>
 <20140415124743.GD3403@thunk.org>
 <CADDb1s3HYDvb51Ngrwk82gkpbUWg1bRo7kaUmbGRmb0g_9JKgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADDb1s3HYDvb51Ngrwk82gkpbUWg1bRo7kaUmbGRmb0g_9JKgw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 10:30:10AM +0530, Amit Sahrawat wrote:
> 4)	Corrupt the block group ‘1’  by writing all ‘1’, we had one file
> with all 1’s, so using ‘dd’ –
> dd if=i_file of=/dev/sdb1 bs=4096 seek=17 count=1
> After this mount the partition – create few random size files and then
> ran ‘fsstress,

Um, sigh.  You didn't say that you were deliberately corrupting the
file system.  That wasn't in the subject line, or anywhere else in the
original message.

So the question isn't how the file system got corrupted, but that
you'd prefer that the system recovers without hanging after this
corruption.

I wish you had *said* that.  It would have saved me a lot of time,
since I was trying to figure out how the system had gotten so
corrupted (not realizing you had deliberately corrupted the file
system).

So I think if you run "tune2fs -e remount-ro /dev/sdb1" before you
started the fsstress, the file system would have remounted the
filesystem read-only at the first EXT4-fs error message.  This would
avoid the hang that you saw, since the file system would hopefully
"failed fast", before th euser had the opportunity to put data into
the page cache that would be lost when the system discovered there was
no place to put the data.

Regards,

						- Ted
