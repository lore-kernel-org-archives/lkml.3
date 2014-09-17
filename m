Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbaIQQFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:05:30 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:54266 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbaIQQFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:05:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140917154327.GA12190@thunk.org>
References: <cover.1410810247.git.milosz@adfin.com>
	<057d758976db2fcce58e394abaa0d55e48cdeec1.1410810247.git.milosz@adfin.com>
	<20140917154327.GA12190@thunk.org>
Date: Wed, 17 Sep 2014 12:05:23 -0400
Message-ID: <CANP1eJFQv51E7yfXw70ONxkjhOVatV6ERwgaY6Srv9-6VcDrjQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] Define new syscalls readv2,preadv2,writev2,pwritev2
From: Milosz Tanski <milosz@adfin.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Milosz Tanski <milosz@adfin.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore,

I might be missing understanding something, but... I already omitted
read2 and write2 which can be implemented in userspace by libc (as you
pointed out). In the case of readv vs. preadv there's an extra
positional argument (file offset) and preadv version doesn't change
the file location. I didn't want to overload the meaning of preadv2 to
take a special negative offset value that uses the current file
position but also changes the file position.

As a counter point to my view point, Christop also brought the same
thing as you did.

- Milosz

On Wed, Sep 17, 2014 at 11:43 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Sep 15, 2014 at 04:20:37PM -0400, Milosz Tanski wrote:
>> New syscalls with an extra flag argument. For now all flags except for 0 are
>> not supported.
>
> This may fall in the category of bike-shedding, and so I apologize in
> advance, but I wonder if we really need readv2 and writev2 as new
> syscalls.  What if we just added preadv2 and pwritev2, and implemented
> readv2 and writev2 as libc wrappers where which had the vector
> allocated as an automatic stack variable?  Is the extra user memory
> access really going to be that noticeable?
>
> Cheers,
>
>                                        - Ted



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
