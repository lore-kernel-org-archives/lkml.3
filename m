Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab3DAPir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:38:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758119Ab3DAPiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:38:46 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>,
        Tejun Heo <tj@kernel.org>, Mike Snitzer <msnitzer@redhat.com>,
        Christoph Hellwig <chellwig@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Track block device users that created dirty pages
References: <Pine.LNX.4.64.1303291042100.23238@file.rdu.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 01 Apr 2013 11:38:36 -0400
In-Reply-To: <Pine.LNX.4.64.1303291042100.23238@file.rdu.redhat.com> (Mikulas
	Patocka's message of "Fri, 29 Mar 2013 12:08:34 -0400 (EDT)")
Message-ID: <x491uau1csj.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> The new semantics is: if a process did some buffered writes to the block
> device (with write or mmap), the cache is flushed when the process
> closes the block device. Processes that didn't do any buffered writes to
> the device don't cause cache flush. It has these advantages:
> * processes that don't do buffered writes (such as "lvm") don't flush
>   other process's data.
> * if the user runs "dd" on a block device, it is actually guaranteed
>   that the data is flushed when "dd" exits.

Why don't applications that want data to go to disk just call fsync
instead of relying on being the last process to have had the device
open?

Cheers,
Jeff
