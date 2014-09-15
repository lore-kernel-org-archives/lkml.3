Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbaIOVop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:44:45 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:55841 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaIOVon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:44:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140915211523.GA5481@infradead.org>
References: <cover.1410810247.git.milosz@adfin.com>
	<e434e839351324641e10cc0a309a5c5f86e196c5.1410810247.git.milosz@adfin.com>
	<20140915202828.GV7996@ZenIV.linux.org.uk>
	<20140915211523.GA5481@infradead.org>
Date: Mon, 15 Sep 2014 17:44:41 -0400
Message-ID: <CANP1eJFgKOnW7p3fhNAqHQT4gd0AbeFWWDmaKCkiOkB8_U4c_A@mail.gmail.com>
Subject: Re: [PATCH 1/7] Prepare for adding a new readv/writev with user flags.
From: Milosz Tanski <milosz@adfin.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll redo with the flag inside of kiocb for the next submission.

On Mon, Sep 15, 2014 at 5:15 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Sep 15, 2014 at 09:28:28PM +0100, Al Viro wrote:
>> On Mon, Sep 15, 2014 at 04:20:17PM -0400, Milosz Tanski wrote:
>> > Plumbing the flags argument through the vfs code so they can be passed down to
>> > __generic_file_(read/write)_iter function that do the acctual work.
>>
>> NAK.  Put these flags into iocb, it'll be less noisy that way.
>
> Fine with me.  My initial prototype had it in the iov_iter type field
> which is another possibility.
>
> But if we get rid of the explicit flags field and make it more invisible
> I'd really like to add a features field struct file_operations where
> instances can advertize that they support it (and other things like
> actual AIO support in the future) so that we won't have a situation
> like with AIO where we can submit I/O but it might actually still block
> anyway because lots of operations don't support it.



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
