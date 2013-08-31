Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3HaEUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 00:20:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52406 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab3HaEUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 00:20:21 -0400
Date: Fri, 30 Aug 2013 22:20:18 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Kent Overstreet <kmo@daterainc.com>
Cc: kernel neophyte <neophyte.hacker001@gmail.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: [PATCH] bcache: Fix a shrinker deadlock
Message-ID: <20130831042018.GP21481@kernel.dk>
References: <CAFkUHxd6xN3On4DTC7VnUgVuy8M57k=8eKYr47bKKnpQWS+p8A@mail.gmail.com>
 <20130830211510.GA20307@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830211510.GA20307@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30 2013, Kent Overstreet wrote:
> GFP_NOIO means we could be getting called recursively - mca_alloc() ->
> mca_data_alloc() - definitely can't use mutex_lock(bucket_lock) then.
> Whoops.

Kent, can you provide and updated repo with the pending patches? There's
been some churn here lately (and good fixes), would like to ensure I
don't miss anything.

-- 
Jens Axboe

