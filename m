Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab3CYMeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:34:17 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57567
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757010Ab3CYMeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:34:15 -0400
Date: Mon, 25 Mar 2013 06:34:10 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Alex.Lemberg@sandisk.com, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] block: Add support for reinsert a dispatched req
Message-ID: <20130325123410.GG22327@kernel.dk>
References: <1364202150-8776-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364202150-8776-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25 2013, Tanya Brokhman wrote:
> From: Tatyana Brokhman <tlinder@codeaurora.org>
> 
> Add support for reinserting a dispatched request back to the
> scheduler's internal data structures.
> This capability is used by the device driver when it chooses to
> interrupt the current request transmission and execute another (more
> urgent) pending request. For example: interrupting long write in order
> to handle pending read. The device driver re-inserts the
> remaining write request back to the scheduler, to be rescheduled
> for transmission later on.
> 
> Add API for verifying whether the current scheduler
> supports reinserting requests mechanism. If reinsert mechanism isn't
> supported by the scheduler, this code path will never be activated.

This is practically the exact same operation as a requeue. So why this
duplication? I also don't quite understand why an IO scheduler would
have to opt-in for this, seems like a pretty basic operation.

-- 
Jens Axboe

