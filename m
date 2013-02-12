Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab3BLQwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:52:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:62337 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758579Ab3BLQwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:52:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="290147149"
Date: Tue, 12 Feb 2013 08:28:02 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: djbw@fb.com, maciej.patelczyk@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ioatdma: fix race between updating ioat->head and
 IOAT_COMPLETION_PENDING
Message-ID: <20130212162802.GQ3789@intel.com>
References: <20130207213832.13721.36522.stgit@djiang5-linux2.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207213832.13721.36522.stgit@djiang5-linux2.ch.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 02:38:32PM -0700, Dave Jiang wrote:
> There is a race that can hit during __cleanup() when the ioat->head pointer is
> incremented during descriptor submission. The __cleanup() can clear the
> PENDING flag when it does not see any active descriptors. This causes new
> submitted descriptors to be ignored because the COMPLETION_PENDING flag is
> cleared. This was introduced when code was adapted from ioatdma v1 to ioatdma
> v2. For v2 and v3, IOAT_COMPLETION_PENDING flag will be abandoned and a new
> flag IOAT_CHAN_ACTIVE will be utilized. This flag will also be protected under
> the prep_lock when being modified in order to avoid the race.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Dan Williams <djbw@fb.com>
Applied, thanks

--
~Vinod
