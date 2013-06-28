Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3F1Uqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:46:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab3F1Uqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:46:34 -0400
Date: Fri, 28 Jun 2013 22:46:31 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Reserve only one queue tag for sync IO if only 3
 tags are available
Message-ID: <20130628204631.GB15288@quack.suse.cz>
References: <1372432127-9716-1-git-send-email-jack@suse.cz>
 <20130628193152.GF24293@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628193152.GF24293@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 28-06-13 21:31:52, Jens Axboe wrote:
> On Fri, Jun 28 2013, Jan Kara wrote:
> > In case a device has three tags available we still reserve two of them
> > for sync IO. That leaves only a single tag for async IO such as
> > writeback from flusher thread which results in poor performance.
> > 
> > Allow async IO to consume two tags in case queue has three tag availabe
> > to get a decent async write performance.
> > 
> > This patch improves streaming write performance on a machine with such disk
> > from ~21 MB/s to ~52 MB/s. Also postmark throughput in presence of
> > streaming writer improves from 8 to 12 transactions per second so sync
> > IO doesn't seem to be harmed in presence of heavy async writer.
> 
> That's pretty crazy! Never seen a device like that. But yes, it
> obviously exists, and the 2 reserved tags doesn't work well for that. So
> it's an improvement.
  Yeah, I agree it's a weird hardware. It's a ppc64 machine where storage
identifies as:
scsi2 : IBM 573E Storage Adapter
scsi 2:0:4:0: Direct-Access     IBM      ST373453LC       C51C PQ: 0 ANSI: 3
scsi 2:0:5:0: Direct-Access     IBM   H0 ST373207LC       C70D PQ: 0 ANSI: 4
scsi 2:0:8:0: Direct-Access     IBM   H0 ST373207LC       C70D PQ: 0 ANSI: 4

  It took me a while to figure out why this machine observes performance
characteristics noone else sees.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
