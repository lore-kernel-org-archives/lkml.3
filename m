Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbaDYOSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:18:55 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:65461 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbaDYOSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:18:50 -0400
Message-ID: <535A6EC7.10305@kernel.dk>
Date: Fri, 25 Apr 2014 08:18:47 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/1] random vs blk-mq
References: <20140425073610.GA2143@infradead.org>
In-Reply-To: <20140425073610.GA2143@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 01:36 AM, Christoph Hellwig wrote:
> A tester found out that we need add_disk_randomness for my scsi-mq
> branch.  The patch applied exports add_disk_randomness so that modular
> scsi still works with a driver that either uses the low-level I/O
> completion routines for the old block layer, or blk-mq, and I'd love
> to get this in through Jens' tree which has all the other block work
> scsi-mq requires.
> 
> But this also brings up an interesting question:  blk-mq currently
> does not set QUEUE_FLAG_ADD_RANDOM in the default queue flags, so
> simply converting a driver to blk-mq will mean it stops contributing
> to the random pool.  Do we need a more fine grained way to control
> this, especially for SCSI?

Or, we could just fix the horribly slow pool mix and have it always be
on if it's "free", or almost free. Perhaps just default to on for
rotating devices, that'd lessen the impact.

-- 
Jens Axboe

