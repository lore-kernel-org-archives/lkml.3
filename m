Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaDAUu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:50:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaDAUuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:50:25 -0400
Date: Tue, 1 Apr 2014 13:50:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Pen <r.peniaev@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 1/1] fs/mpage.c: forgotten WRITE_SYNC in case of
 WB_SYNC_ALL
Message-Id: <20140401135023.9ca9e1e4d15bb54981443346@linux-foundation.org>
In-Reply-To: <1394811268-10731-1-git-send-email-r.peniaev@gmail.com>
References: <1394811268-10731-1-git-send-email-r.peniaev@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Mar 2014 00:34:28 +0900 Roman Pen <r.peniaev@gmail.com> wrote:

> When data integrity operation happens (sync, fsync, fdatasync calls)
> writeback control is set to WB_SYNC_ALL. In that case all write
> requests are marked with WRITE_SYNC (WRITE | REQ_SYNC | REQ_NOIDLE)
> indicating that caller is waiting for completion and block layer or
> block device should prioritize the IO avoiding any possible delays.
> 
> But mpage writeback path ignores marking requests as WRITE_SYNC.
> 
> This patch fixes this.

Sorry, but it would be unwise to merge this without a good
understanding of its runtime effects.

