Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaL3V3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 16:29:19 -0500
Received: from one.firstfloor.org ([193.170.194.197]:42767 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaL3V3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 16:29:18 -0500
Date: Tue, 30 Dec 2014 22:29:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andreas Mohr <andi@lisas.de>
Cc: Andrzej Hajda <a.hajda@samsung.com>, Andi Kleen <andi@firstfloor.org>,
        linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kstrdup optimization
Message-ID: <20141230212915.GN2915@two.firstfloor.org>
References: <54A25135.5030103@samsung.com>
 <20141230083230.GA17639@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141230083230.GA17639@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This symmetry issue probably could be cleanly avoided only
> by having kfree() itself contain such an identifying check, as you suggest
> (thereby slowing down kfree() performance).

It actually shouldn't slow it down. kfree already complains if you free
a non slab page, this could be just in front of the error check.

The bigger concern is that it may hide some programing errors elsewhere
though. So it's probably better to keep it a separate function.

-Andi
