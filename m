Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaHORJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:09:48 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:43665 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaHORJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:09:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140814150425.dfbb6c7eb7ab250e985dac28@linux-foundation.org>
References: <1407249514-20465-1-git-send-email-akinobu.mita@gmail.com>
	<20140814150425.dfbb6c7eb7ab250e985dac28@linux-foundation.org>
Date: Sat, 16 Aug 2014 02:09:44 +0900
Message-ID: <CAC5umygJozyMs5ybyDjCeZLrPnJOAYoNnjsvAFkYFRfVZiivKQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] implement readpages() for block device to optimize
 sequential read
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-15 7:04 GMT+09:00 Andrew Morton <akpm@linux-foundation.org>:
> On Tue,  5 Aug 2014 23:38:31 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> This patchset implements readpages() operation for block device by
>> using mpage_readpages() which can create multipage BIOs instead of
>> BIOs for each page and reduce system CPU time consumption.
>
> Patchset is simple and straightforward enough.  But who the
> heck cares about the performance of buffered reads from /dev/XXX?

I tend to consider the block device as a baseline when I measure the
performance of the storage device.  So I was a bit surprised when I saw
the performance of buffered reads from filesystem is better than the one
from block device.  That is the reason about this patch for me.
