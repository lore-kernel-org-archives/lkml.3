Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbaGJGCC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:02:02 -0400
Received: from verein.lst.de ([213.95.11.211]:55599 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaGJGCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:02:00 -0400
Date: Thu, 10 Jul 2014 08:01:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/14] scsi: convert device_busy to atomic_t
Message-ID: <20140710060155.GA7675@lst.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-9-git-send-email-hch@lst.de> <1404924596.2006.6.camel@jarvis.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404924596.2006.6.camel@jarvis.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 09:49:56AM -0700, James Bottomley wrote:
> As far as I can tell from the block MQ, we get one CPU thread per LUN.

No, that's entirely incorrect.  IFF a device supports multiple hardware
queues we only submit I/O from CPUs (there might be more than one) this
queue is bound to.  With the single hardware queue supported by most
hardware submissions can and will happen from any CPU.  Note that
this patchset doesn't even support multiple hardware queues yet, although
it should be fairly simple to add once the low level driver support is
ready.

