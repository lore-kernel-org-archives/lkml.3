Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaERFFG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 01:05:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:45035 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbaERFFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 01:05:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,860,1392192000"; 
   d="scan'208";a="533655351"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: dan.carpenter@oracle.com, kernel-janitors@vger.kernel.org,
        kernelnewbies@kernelnewbies.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] Remove useless return variables
References: <1400379310-10214-1-git-send-email-peter.senna@gmail.com>
Date: Sat, 17 May 2014 22:04:35 -0700
In-Reply-To: <1400379310-10214-1-git-send-email-peter.senna@gmail.com> (Peter
	Senna Tschudin's message of "Sun, 18 May 2014 04:15:10 +0200")
Message-ID: <87y4xzpti4.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Senna Tschudin <peter.senna@gmail.com> writes:

> This patch remove variables that are initialized with a constant,
> are never updated, and are only used as parameter of return.
> Return the constant instead of using a variable.

This ret variable pattern is pretty standard in Linux, as it makes it 
easier to add new code that may trigger new errors
(using the usual "goto forest" error handling pattern)

I don't see any benefit in whole-sale removing it. The compiler
doesn't care about it and will generate the same code in any 
case.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
