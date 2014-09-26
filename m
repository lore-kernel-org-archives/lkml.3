Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaIZKkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:40:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:54798 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120AbaIZKku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:40:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="391951088"
Message-ID: <1411728032.23429.63.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/3] UBI: Fix possible deadlock in erase_worker()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 26 Sep 2014 13:40:32 +0300
In-Reply-To: <1411375536-20067-3-git-send-email-richard@nod.at>
References: <1411375536-20067-1-git-send-email-richard@nod.at>
	 <1411375536-20067-3-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-22 at 10:45 +0200, Richard Weinberger wrote:
> If sync_erase() fails with EINTR, ENOMEM, EAGAIN or
> EBUSY erase_worker() re-schedules the failed work.
> This will lead to a deadlock because erase_worker() is called
> with work_sem held in read mode. And schedule_erase() will take
> this lock again.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Did you manage to test it?

Why no -stable this time? Not that important, or just something
theoretical and you never actually hit this bug?

Thanks!

-- 
Best Regards,
Artem Bityutskiy

