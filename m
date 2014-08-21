Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbaHUVoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:44:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbaHUVoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:44:14 -0400
Date: Thu, 21 Aug 2014 14:44:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/3] implement readpages() for block device to optimize
 sequential read
Message-Id: <20140821144412.2a97f2a7400590097f3926de@linux-foundation.org>
In-Reply-To: <CAC5umygJozyMs5ybyDjCeZLrPnJOAYoNnjsvAFkYFRfVZiivKQ@mail.gmail.com>
References: <1407249514-20465-1-git-send-email-akinobu.mita@gmail.com>
	<20140814150425.dfbb6c7eb7ab250e985dac28@linux-foundation.org>
	<CAC5umygJozyMs5ybyDjCeZLrPnJOAYoNnjsvAFkYFRfVZiivKQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2014 02:09:44 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> 2014-08-15 7:04 GMT+09:00 Andrew Morton <akpm@linux-foundation.org>:
> > On Tue,  5 Aug 2014 23:38:31 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:
> >
> >> This patchset implements readpages() operation for block device by
> >> using mpage_readpages() which can create multipage BIOs instead of
> >> BIOs for each page and reduce system CPU time consumption.
> >
> > Patchset is simple and straightforward enough.  But who the
> > heck cares about the performance of buffered reads from /dev/XXX?
> 
> I tend to consider the block device as a baseline when I measure the
> performance of the storage device.  So I was a bit surprised when I saw
> the performance of buffered reads from filesystem is better than the one
> from block device.  That is the reason about this patch for me.

OK.  The lack of readpages for blockdevs has been an outstanding oddity
for a decade or longer - I think it's just that nobody was motivated to
do it because the workload isn't important.

But the implementation looks pretty simple so why not clean it up.

I grabbed the patches.
