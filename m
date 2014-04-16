Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaDPG5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:57:35 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58510 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaDPG5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:57:34 -0400
Date: Tue, 15 Apr 2014 23:57:29 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Roman Pen <r.peniaev@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 1/1] mtd: mtd_blkdevs: handle REQ_FLUSH request and do
 explicit flush of writeback buffer
Message-ID: <20140416065729.GP3131@norris-Latitude-E6410>
References: <1394283554-27423-1-git-send-email-r.peniaev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394283554-27423-1-git-send-email-r.peniaev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 09:59:14PM +0900, Roman Pen wrote:
> From: Roman Peniaev <r.peniaev@gmail.com>
> 
> mtd_blkdevs is device with volatile cache (writeback buffer), so it should support
> REQ_FLUSH to do explicit flush.
> 
> Without this patch 'sync' does not guarantee that writeback buffer will be flushed
> on disk in case of power off, e.g.:
> 
>   $ cp some_file /mnt
>   $ sync
> 
>   ### POWER OFF
> 
> In case of this sequence writeback buffer will not be flushed on disk.
> 
> This patch fixes this behaviour and explicitly reports to block layer that flush
> requests are being supported.
> 
> Signed-off-by: Roman Peniaev <r.peniaev@gmail.com>
> CC: David Woodhouse <dwmw2@infradead.org>
> CC: Brian Norris <computersforpeace@gmail.com>
> CC: linux-mtd@lists.infradead.org
> CC: linux-kernel@vger.kernel.org

Pushed to l2-mtd.git. Thanks!

Brian
