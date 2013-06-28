Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3F1Tb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:31:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58969 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3F1Tbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:31:55 -0400
Date: Fri, 28 Jun 2013 21:31:52 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Reserve only one queue tag for sync IO if only 3
 tags are available
Message-ID: <20130628193152.GF24293@kernel.dk>
References: <1372432127-9716-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372432127-9716-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28 2013, Jan Kara wrote:
> In case a device has three tags available we still reserve two of them
> for sync IO. That leaves only a single tag for async IO such as
> writeback from flusher thread which results in poor performance.
> 
> Allow async IO to consume two tags in case queue has three tag availabe
> to get a decent async write performance.
> 
> This patch improves streaming write performance on a machine with such disk
> from ~21 MB/s to ~52 MB/s. Also postmark throughput in presence of
> streaming writer improves from 8 to 12 transactions per second so sync
> IO doesn't seem to be harmed in presence of heavy async writer.

That's pretty crazy! Never seen a device like that. But yes, it
obviously exists, and the 2 reserved tags doesn't work well for that. So
it's an improvement.

Thanks, will queue up for 3.11.

-- 
Jens Axboe

