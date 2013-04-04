Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371Ab3DDODe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:03:34 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:52890 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760670Ab3DDODc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:03:32 -0400
Date: Thu, 4 Apr 2013 07:03:27 -0700
From: Tejun Heo <tj@kernel.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] blk: start bypass mode in blk_unregister_queue
Message-ID: <20130404140327.GC9425@htj.dyndns.org>
References: <1364308501-1640-1-git-send-email-aaron.lu@intel.com>
 <515D87AA.4050604@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515D87AA.4050604@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 10:01:14PM +0800, Aaron Lu wrote:
> In blk_register_queue, we will end bypass mode for the queue; but in
> blk_unregister_queue, we didn't start bypass mode for it. This would
> cause the WARN_ON_ONCE(q->bypass_depth < 0) to trigger if the queue gets
> registered, unregistered and then again registered, e.g. unload scsi
> cdrom module driver sr_mod and then reload it will trigger such a
> warning.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Is this something which actually happens?  Why would an unregistered
queue registered again?  Do we even support that?

Starting a bypass mode can be very expensive and some drivers create
and destroy a lot of queues during probing.  We don't want a call to
blk_queue_bypass_start() on every queue creation / destruction cycle.

Thanks.

-- 
tejun
