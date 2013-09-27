Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3I0Sf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:35:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab3I0Sf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:35:26 -0400
Date: Fri, 27 Sep 2013 14:35:07 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, cesarb@cesarb.net,
        joe@perches.com, akpm@linux-foundation.org, agk@redhat.com,
        m.chehab@samsung.com, ejt@redhat.com, dan.carpenter@oracle.com
Subject: Re: Reworking dm-writeboost [was: Re: staging: Add dm-writeboost]
Message-ID: <20130927183507.GA16553@redhat.com>
References: <5223208D.4000008@gmail.com>
 <20130916215357.GA5015@redhat.com>
 <52384E66.6050101@gmail.com>
 <20130917205936.GB12001@redhat.com>
 <523E3522.2060607@gmail.com>
 <524183A2.9050301@gmail.com>
 <20130925173757.GA24076@redhat.com>
 <5243922B.6070705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5243922B.6070705@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25 2013 at  9:47pm -0400,
Akira Hayakawa <ruby.wktk@gmail.com> wrote:

> Hi, Mike
> 
> The monolithic source code (3.2k)
> is nicely splitted into almost 20 *.c files
> according to the functionality and
> data strucutures in OOP style.
> 
> The aim of this posting
> is to share how the splitting looks like.
> 
> I believe that
> at least reading the *.h files
> can convince you the splitting is clear.
> 
> The code is now tainted with
> almost 20 version switch macros
> and WB* debug macros
> but I will clean them up
> for sending patch.
> 
> Again,
> the latest code can be cloned by
> git clone https://github.com/akiradeveloper/dm-writeboost.git
> 
> I will make few updates to the source codes on this weekend
> so please track it to follow the latest version.
> Below is only the snapshot.
> 
> Akira
> 
> ---------- Summary ----------
> 33 Makefile
> 10 bigarray.h
> 19 cache-alloc.h
> 10 defer-barrier.h
> 8 dirty-sync.h
> 8 flush-daemon.h
> 10 format-cache.h
> 24 handle-io.h
> 16 hashtable.h
> 18 migrate-daemon.h
> 7 migrate-modulator.h
> 12 queue-flush-job.h
> 8 rambuf.h
> 13 recover.h
> 18 segment.h
> 8 superblock-recorder.h
> 9 target.h
> 30 util.h
> 384 writeboost.h
> 99 bigarray.c
> 192 cache-alloc.c
> 36 defer-barrier.c
> 33 dirty-sync.c
> 85 flush-daemon.c
> 234 format-cache.c
> 553 handle-io.c
> 109 hashtable.c
> 345 migrate-daemon.c
> 41 migrate-modulator.c
> 169 queue-flush-job.c
> 52 rambuf.c
> 308 recover.c
> 118 segment.c
> 61 superblock-recorder.c
> 376 target.c
> 126 util.c

Unfortunately I think you went too far with all these different small
files, I was hoping to see 2 or 3 .c files and a couple .h files.

Maybe fold all the daemon code into a 1 .c and 1 .h ?

The core of the writeboost target in dm-writeboost-target.c ?

And fold all the other data structures into a 1 .c and 1 .h ?

When folding these files together feel free to use dividers in the code
like dm-thin.c and dm-cache-target.c do, e.g.:

/*-----------------------------------------------------------------*/

Mike
