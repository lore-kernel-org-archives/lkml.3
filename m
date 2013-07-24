Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab3GXKts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:49:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35573 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3GXKts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:49:48 -0400
Date: Wed, 24 Jul 2013 12:49:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched: update_top_cache_domain only at the times of
 building sched domain.
Message-ID: <20130724104931.GF27075@twins.programming.kicks-ass.net>
References: <1374601332.9192.0.camel@localhost.localdomain>
 <51EF4969.4050807@linux.vnet.ibm.com>
 <CADZ9YHiJ4MYFkWqikKu0qHOsBYGEPYvC2JL5wE3iCUH6vTMKcA@mail.gmail.com>
 <51EF919F.2000706@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EF919F.2000706@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 04:34:39PM +0800, Michael Wang wrote:
> But your patch will run the risk to get a freed sd, since you make
> 'sd_llc' wrong for a period of time (between destroy and rebuild) IMO.
> 
> I guess I get you point, you are trying to save one time update since
> you think this will be done twice, but actually the result of this two
> time update was different, it's not redo and it's in order to sync
> 'sd_llc' with 'rq->sd'.

Michael is right, you cannot skip update_top_cache_domain() when
destroying things.
