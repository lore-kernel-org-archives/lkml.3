Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab3ARI51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 03:57:27 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:45595 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab3ARI5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 03:57:25 -0500
Date: Fri, 18 Jan 2013 09:57:23 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/xfrm/xfrm_replay: avoid division by zero
Message-ID: <20130118085723.GG24987@secunet.com>
References: <1358449108-67839-1-git-send-email-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358449108-67839-1-git-send-email-nickolai@csail.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 18 Jan 2013 08:57:23.0504 (UTC) FILETIME=[D4D20300:01CDF559]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 01:58:28PM -0500, Nickolai Zeldovich wrote:
> All of the xfrm_replay->advance functions in xfrm_replay.c check if
> x->replay_esn->replay_window is zero (and return if so).  However,
> one of them, xfrm_replay_advance_bmp(), divides by that value (in the
> '%' operator) before doing the check, which can potentially trigger
> a divide-by-zero exception.  Some compilers will also assume that the
> earlier division means the value cannot be zero later, and thus will
> eliminate the subsequent zero check as dead code.
> 
> This patch moves the division to after the check.
> 
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>

Applied, thanks!
