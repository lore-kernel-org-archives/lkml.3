Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaCKQdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:33:32 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48544 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaCKQda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:33:30 -0400
Message-ID: <1394553778.31499.180.camel@bobble.lax.corp.google.com>
Subject: Re: [PATCH] block:  Force sector and nr_sects to device alignment
 and granularity.
From: Frank Mayhar <fmayhar@google.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 11 Mar 2014 09:02:58 -0700
In-Reply-To: <x49wqg0bwb4.fsf@segfault.boston.devel.redhat.com>
References: <1394474492.31499.177.camel@bobble.lax.corp.google.com>
	 <x49wqg0bwb4.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 11:15 -0400, Jeff Moyer wrote:
> Frank Mayhar <fmayhar@google.com> writes:
> 
> > block:  Force sector and nr_sects to device alignment and granularity.
> >
> > In blkdev_issue_discard(), rather than sending an improperly-
> > aligned discard to the device (where it may get an error),
> > adjust the start and length to the block device alignment and
> > granularity.  Don't fail if this leaves nothing to discard.
> >
> > Without this change, certain flash drivers can report invalid
> > trim parameters (and will fail the command).  Per tytso, "given
> > that discards are advisory, any part of the storage stack is
> > free to drop discard requests silently."
> 
> And how do you get here with misaligned discards?

I don't understand the question.

The case that we were seeing was with an SSD that required TRIM on 8k
boundaries and with an 8k granularity.  Since the file system was trying
to do discards based on 4k alignment the driver complained mightily.
-- 
Frank Mayhar
310-460-4042

