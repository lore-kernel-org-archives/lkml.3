Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab3EOIK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:10:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55100 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab3EOIKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:10:24 -0400
Date: Wed, 15 May 2013 10:09:39 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Sam Bradshaw <sbradshaw@micron.com>
Cc: linux-kernel@vger.kernel.org, asamymuthupa@micron.com
Subject: Re: [PATCH] mtip32xx: Correctly handle bio->bi_idx != 0 conditions
Message-ID: <20130515080939.GD3276@kernel.dk>
References: <5192BB62.7090509@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5192BB62.7090509@micron.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14 2013, Sam Bradshaw wrote:
> 
> Stacking drivers may append bvecs to existing bio's, resulting
> in non-zero bi_idx conditions.  This patch counts the loops of
> bio_for_each_segment() rather than inheriting the bi_idx value
> to pass as a segment count to the hardware submission routine.

Yup, that's a plain bug. Iteration always starts at current index and
forward, so nents wont necessarily start at 0. Applied.

-- 
Jens Axboe

