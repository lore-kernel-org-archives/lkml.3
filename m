Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3JCP2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:28:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:59263 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab3JCP2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:28:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1026,1371106800"; 
   d="scan'208";a="404844426"
Message-ID: <1380814071.27358.444.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/7] UBI: fix refill_wl_user_pool()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: richard.genoud@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 03 Oct 2013 18:27:51 +0300
In-Reply-To: <524D8879.1030203@nod.at>
References: <1380376516-30144-1-git-send-email-richard@nod.at>
	  <1380376516-30144-2-git-send-email-richard@nod.at>
	 <1380812414.27358.440.camel@sauron.fi.intel.com> <524D8879.1030203@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-03 at 17:08 +0200, Richard Weinberger wrote:
> Am 03.10.2013 17:00, schrieb Artem Bityutskiy:
> > On Sat, 2013-09-28 at 15:55 +0200, Richard Weinberger wrote:
> >> If no free PEBs are available refill_wl_user_pool() must not
> >> return with -ENOSPC immediately.
> >> It has to block till produce_free_peb() produced a free PEB.
> >>
> >> Reported-and-Tested-by: Richard Genoud <richard.genoud@gmail.com>
> >> Signed-off-by: Richard Weinberger <richard@nod.at>
> > 
> > What is pool size, I wonder?
> 
> Currently it's 25 (UBI_FM_WL_POOL_SIZE).
> If experience shows that 25 is too low/big we can change this constant.
> Maybe it's also worth making them configurable...

I if it is a possible scenario that this function will not return until
25 (or even 10) PEBs are erased? 

-- 
Best Regards,
Artem Bityutskiy

