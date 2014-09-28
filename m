Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaI1MLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 08:11:24 -0400
Received: from mga03.intel.com ([134.134.136.65]:61588 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbaI1MLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 08:11:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,614,1406617200"; 
   d="scan'208";a="580231241"
Message-ID: <1411906276.11836.21.camel@karhu>
Subject: Re: [RFC/PATCH 1/5] mtd: ubi: Read disturb infrastructure
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: dedeking1@gmail.com, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 28 Sep 2014 15:11:16 +0300
In-Reply-To: <1411886220-8208-1-git-send-email-tlinder@codeaurora.org>
References: <1411886220-8208-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-09-28 at 09:37 +0300, Tanya Brokhman wrote:
> The need for performing read disturb is determined according to new
> statistics collected per eraseblock:
> - read counter: incremented at each read operation
>                 reset at each erase
> - last erase time stamp: updated at each erase
> 
> This patch adds the infrastructure for the above statistics

Would you please provide some kind of high level description for this
stuff. What is the problem at hand, how is it solved. Right off-the top
of my head I have the following comment.

Adding more fields to 'struct ubi_wl_entry' should be well-justified.
These objects are per-PEB, so there may be really a lot of them, and
they may consume a lot of memory. Increasing the size of the object may
be affect the memory consumption a lot.

So I wonder if these read counters solve a big enough problem, so that
they are worth having in this data structure.

So I am really missing the bigger picture here.

-- 
Best Regards,
Artem Bityutskiy

