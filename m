Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab3BFLCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:02:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36407 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315Ab3BFLBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:01:55 -0500
Date: Wed, 6 Feb 2013 12:00:46 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, stable@vger.kernel.org
Subject: Re: [PATCH 06/62] block: fix synchronization and limit check in
 blk_alloc_devt()
Message-ID: <20130206110046.GG15092@kernel.dk>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359854463-2538-7-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02 2013, Tejun Heo wrote:
> idr allocation in blk_alloc_devt() wasn't synchronized against lookup
> and removal, and its limit check was off by one - 1 << MINORBITS is
> the number of minors allowed, not the maximum allowed minor.
> 
> Add locking and rename MAX_EXT_DEVT to NR_EXT_DEVT and fix limit
> checking.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: stable@vger.kernel.org

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

