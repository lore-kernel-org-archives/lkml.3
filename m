Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab3HTHAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:00:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab3HTHAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:00:36 -0400
Date: Tue, 20 Aug 2013 09:00:46 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] Revert "Revert "math64: New div64_u64_rem helper""
Message-ID: <20130820070045.GA1665@redhat.com>
References: <1376078164-23147-1-git-send-email-snitzer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376078164-23147-1-git-send-email-snitzer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 03:56:03PM -0400, Mike Snitzer wrote:
> This reverts commit f3002134158092178be81339ec5a22ff80e6c308.
> 
> div64_u64_rem was removed because there were no other users.
> 
> But Device Mapper's I/O statistics support has a need for
> div64_u64_rem; reintroduce this helper.

This slows down div64_u64 operation, especially on 32-bit systems.

Since dm statistic code is possibly not performance critical
perhaps you could use something like below instead to calculate
remainder:

res = div64_u64(a, b);
rem = a - b*res;

Stanislaw

