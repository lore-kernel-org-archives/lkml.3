Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbaGAR55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:57:57 -0400
Received: from one.firstfloor.org ([193.170.194.197]:40752 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743AbaGAR54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:57:56 -0400
Date: Tue, 1 Jul 2014 19:57:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        tony.luck@intel.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, dave.hansen@linux.intel.com,
        Chen Yucong <slaoub@gmail.com>
Subject: Re: [PATCH] hwpoison: Fix race with changing page during offlining
Message-ID: <20140701175753.GL5714@two.firstfloor.org>
References: <1403806972-14267-1-git-send-email-andi@firstfloor.org>
 <20140626195036.GA5311@nhori.redhat.com>
 <20140626125657.f1830a0b399cbe5a97071206@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626125657.f1830a0b399cbe5a97071206@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andi, can you please check that and test?  If the patch is good I'll
> bump it into 3.16 with an enhanced changelog..

I think the original problem was a race, so it is not easy to reproduce.
I ran this patch in a loop over night with some stress plus 
the mcelog test suite running in a loop. I cannot guarantee it hit it,
but it should have given it a good beating.

The kernel survived with no messages, although the mcelog test suite
got killed at some point because it couldn't fork anymore. Probably
some unrelated problem.

So the patch is ok for me for .16.

-Andi
