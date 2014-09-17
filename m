Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbaIQQ7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:59:55 -0400
Received: from imap.thunk.org ([74.207.234.97]:34110 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbaIQQ7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:59:54 -0400
Date: Wed, 17 Sep 2014 12:59:30 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Milosz Tanski <milosz@adfin.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/7] Define new syscalls readv2,preadv2,writev2,pwritev2
Message-ID: <20140917165930.GA24887@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Milosz Tanski <milosz@adfin.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
	Volker Lendecke <Volker.Lendecke@sernet.de>,
	Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>
References: <cover.1410810247.git.milosz@adfin.com>
 <057d758976db2fcce58e394abaa0d55e48cdeec1.1410810247.git.milosz@adfin.com>
 <20140917154327.GA12190@thunk.org>
 <CANP1eJFQv51E7yfXw70ONxkjhOVatV6ERwgaY6Srv9-6VcDrjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANP1eJFQv51E7yfXw70ONxkjhOVatV6ERwgaY6Srv9-6VcDrjQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 12:05:23PM -0400, Milosz Tanski wrote:
> Theodore,
> 
> I might be missing understanding something, but... I already omitted
> read2 and write2 which can be implemented in userspace by libc (as you
> pointed out). In the case of readv vs. preadv there's an extra
> positional argument (file offset) and preadv version doesn't change
> the file location. I didn't want to overload the meaning of preadv2 to
> take a special negative offset value that uses the current file
> position but also changes the file position.

off_t has to be signed, so having a magic negative value doesn't
bother me that much.  Or you could use a flag bitvalue which means to
use the fd's offset and to ignore the positional value.  (More
bike-shedding :-)

The main reason why I mention it is we have a huge number of
read/write syscalls already, and if we add yet another to support
scatter-gather lists on the memory side, we'll be adding another
factor of two more read/write system calls.  So the suggestion was one
of trying to (probably fruitlessly) trying to stem the expnoential
increase in read/write system calls.  :-)

Cheers,


					- Ted
