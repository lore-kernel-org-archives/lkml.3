Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab3AWRgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:36:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606Ab3AWRg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:36:29 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>, Shaohua Li <shli@kernel.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Read starvation by sync writes
References: <20121210221222.GA25700@quack.suse.cz>
	<CANejiEW2+iUVnyV0EV2n=vi_+bjX42SkeT9F6EUV5LkwXH4e0g@mail.gmail.com>
	<20121212101108.GC18885@quack.suse.cz> <50C8A07B.6040508@kernel.dk>
	<x49vcc7kyza.fsf@segfault.boston.devel.redhat.com>
	<x49obhzkqhy.fsf@segfault.boston.devel.redhat.com>
	<50C9D882.7000808@kernel.dk> <20121213150255.GA21592@quack.suse.cz>
	<50CA1884.6050408@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 23 Jan 2013 12:35:43 -0500
In-Reply-To: <50CA1884.6050408@kernel.dk> (Jens Axboe's message of "Thu, 13
	Dec 2012 19:03:48 +0100")
Message-ID: <x49y5fjx0nk.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

>>> The problem is really that the WRITE_SYNC is (for Jan's case) behaving
>>> like buffered writes, so it eats up a queue of requests very easily. On
>>> the allocation side, the assumption is that WRITE_SYNC behaves like
>>> dependent reads. Similar to a dd with oflag=direct, not like a flood of
>>> requests. For dependent sync writes, our current behaviour is fine, we
>>> treat them like reads. For commits of WRITE_SYNC, they should be treated
>>> like async WRITE instead.
>>   Yeah. But it's similar to what happens when you run fsync() on a large
>> dirty file. That will also submit a lot of WRITE_SYNC requests... kjournald
>> could probably use WRITE instead of WRITE_SYNC for large commits. It's just
>> that we don't really want to give e.g. DIO a preference over kjournald
>> because transaction commit can effectively block any metadata changes on
>> the filesystem.
>
> Sure, I'm not advocating against changing WRITE_SYNC, we just need to be
> able to handle it a bit better. I've got a test patch, will post it
> later.

Jens, did you ever post your test patch?

-Jeff
