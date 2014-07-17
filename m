Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbaGQXOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:14:08 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39837 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870AbaGQXOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:14:06 -0400
MIME-Version: 1.0
In-Reply-To: <x49pph325wj.fsf@segfault.boston.devel.redhat.com>
References: <1405606659-3802-1-git-send-email-akinobu.mita@gmail.com>
	<x49pph325wj.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 18 Jul 2014 08:14:03 +0900
Message-ID: <CAC5umygiEpKBsHQ+OvKvw8pRD1DO0fCPA29qs=kNRho35xkt_g@mail.gmail.com>
Subject: Re: [PATCH] block_dev: implement readpages() to optimize sequential read
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-18 3:31 GMT+09:00 Jeff Moyer <jmoyer@redhat.com>:
> Akinobu Mita <akinobu.mita@gmail.com> writes:
>
>> Sequential read from a block device is expected to be equal or faster
>> than from the file on a filesystem.  But it is not correct due to the
>> lack of effective readpages() in the address space operations for
>> block device.
>
> Ah, a trip down memory lane.  ;-)  Here's a thread showing issues with
> the last time this was proposed (by me, incidentally):
>
> https://lkml.org/lkml/2009/6/2/480
>
> At the very least, we need to see numbers on a real device, and see it
> booted on something with >4k page size before taking this back in.

Thanks for the information.  First, I'll try to reproduce the >4k page
size issue with qemu with the architecture which can support 64k page.
