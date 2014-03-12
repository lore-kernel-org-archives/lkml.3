Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbaCLSUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:20:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbaCLSUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:20:40 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block:  Force sector and nr_sects to device alignment and granularity.
References: <1394474492.31499.177.camel@bobble.lax.corp.google.com>
	<x49wqg0bwb4.fsf@segfault.boston.devel.redhat.com>
	<1394553778.31499.180.camel@bobble.lax.corp.google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 12 Mar 2014 14:20:30 -0400
In-Reply-To: <1394553778.31499.180.camel@bobble.lax.corp.google.com> (Frank
	Mayhar's message of "Tue, 11 Mar 2014 09:02:58 -0700")
Message-ID: <x491ty71dox.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Mayhar <fmayhar@google.com> writes:

> On Tue, 2014-03-11 at 11:15 -0400, Jeff Moyer wrote:
>> Frank Mayhar <fmayhar@google.com> writes:
>> 
>> > block:  Force sector and nr_sects to device alignment and granularity.
>> >
>> > In blkdev_issue_discard(), rather than sending an improperly-
>> > aligned discard to the device (where it may get an error),
>> > adjust the start and length to the block device alignment and
>> > granularity.  Don't fail if this leaves nothing to discard.
>> >
>> > Without this change, certain flash drivers can report invalid
>> > trim parameters (and will fail the command).  Per tytso, "given
>> > that discards are advisory, any part of the storage stack is
>> > free to drop discard requests silently."
>> 
>> And how do you get here with misaligned discards?
>
> I don't understand the question.

Sorry if it wasn't clear...

> The case that we were seeing was with an SSD that required TRIM on 8k
> boundaries and with an 8k granularity.  Since the file system was trying
> to do discards based on 4k alignment the driver complained mightily.

but you managed to read my mind well enough.  The question is how high
up the stack do you put the logic for this?  Is it worth it to duplicate
the checks in the OS that are already done on the device?  I don't
know.  Martin, do you have an opinion on this?

-Jeff
