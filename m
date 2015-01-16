Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbbAPWcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 17:32:32 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49236 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbbAPWca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 17:32:30 -0500
MIME-Version: 1.0
In-Reply-To: <54AD59DC.4020703@plexistor.com>
References: <54AD5893.9040701@plexistor.com>
	<54AD59DC.4020703@plexistor.com>
Date: Fri, 16 Jan 2015 14:32:29 -0800
Message-ID: <CA+8MBbJbKwyJJoFy2uyNvR5La3hFac-pSh8mZBV=BnNJzKQMhg@mail.gmail.com>
Subject: Re: [PATCH 3/4 v4] brd: Fix all partitions BUGs
From: Tony Luck <tony.luck@gmail.com>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 8:07 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
> From: Boaz Harrosh <boaz@plexistor.com>
>
> This patch fixes up brd's partitions scheme, now enjoying all worlds.

linux-next-20150116 includes this as commit
937af5ecd0591e84ee54180fa97dcbe9bbe5fed6

On ia64 I'm seeing:
ram0: unknown partition table
ram1: unknown partition table
...
ram15: unknown partition table

At first I blamed c8fa31730fc7 "brd: Request from fdisk 4k alignment" because it
has all sorts of comments about PAGE_SIZE and 4k ... and my page size isn't
4k.  But, reverting that one didn't help.

reverting 937af5ecd0 does make the message go away.

-Tony
