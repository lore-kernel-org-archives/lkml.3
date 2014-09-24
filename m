Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaIXMgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:36:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:45443 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbaIXMgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:36:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="390921743"
Message-ID: <1411562205.23429.40.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Fix livelock in produce_free_peb()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 24 Sep 2014 15:36:45 +0300
In-Reply-To: <1411141076-21489-1-git-send-email-richard@nod.at>
References: <1411141076-21489-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-19 at 17:37 +0200, Richard Weinberger wrote:
> The while loop in produce_free_peb() assumes that each work will produce a
> free PEB. This is not true.
> If ubi->works_count is 1 and the only scheduled work is the
> wear_leveling_worker() produce_free_peb() can loop forever in case
> nobody schedules an erase work.
> Fix this issue by checking in the while loop whether work is scheduled.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Pushed, thanks!

-- 
Best Regards,
Artem Bityutskiy

