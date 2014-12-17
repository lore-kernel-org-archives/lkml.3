Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaLQPtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:49:14 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:34741 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaLQPtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:49:13 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 17 Dec 2014 10:49:11 -0500
To: Tero Kristo <t-kristo@ti.com>
Cc: Nishanth Menon <nm@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 2/2] ARM: omap5/dra7xx: Fix counter frequency drift for
 AM572x errata i856.
Message-ID: <20141217154911.GU24110@csclub.uwaterloo.ca>
References: <cover.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <358281a880ccd89873efeea75edaa6c953eac2bd.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <20141214044517.GD24110@csclub.uwaterloo.ca>
 <549018EC.8020207@ti.com>
 <20141216145856.GA23358@kahuna>
 <54918357.8060801@ti.com>
 <20141217145533.GS24110@csclub.uwaterloo.ca>
 <20141217152225.GA737@kahuna>
 <20141217152710.GT24110@csclub.uwaterloo.ca>
 <5491A501.100@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5491A501.100@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 05:45:05PM +0200, Tero Kristo wrote:
> Yea clock mux can be used. However, we don't have support for DRA7
> control module clocks in the DT yet. I have posted patches with
> support towards this a couple of weeks back, but they need some
> revising.
> 
> Thus, we maybe need to apply the timer patches as is for now, and
> fix the clock tree a bit later.

Certainly the patches so far fix the system time issue.  I don't think
anything else in the clock tree using this clock is that picky about
the clock being of by 0.05% (when using 20MHz SYSCLK1, which I believe
all boards so far do, other than the one board on my desk with a 19.2MHz
clock because we wanted to see what happened).  Certainly if someone
does build a baord using either 19.2 or 27MHz as supported in the
documentation, then it becomes more relevant potentially.

But I certainly don't consider fixing the clock tree urgent.  I think
we can start shipping products with the clock tree in the current state
(but we couldn't with the system time being that bad, which the patches
so far fix).

-- 
Len Sorensen
