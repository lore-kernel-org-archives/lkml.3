Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaGHLIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 07:08:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbaGHLIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 07:08:20 -0400
Date: Tue, 8 Jul 2014 13:08:16 +0200
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 0/3] timekeeping: Improved NOHZ frequency steering (v2)
Message-ID: <20140708110816.GB23173@localhost>
References: <1400288204-414-1-git-send-email-john.stultz@linaro.org>
 <20140519101439.GE4060@localhost>
 <CALAqxLUyCGJeYDwzXKN0zCBdmYuapo1iYJX4nvR7Sru+ySkesQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLUyCGJeYDwzXKN0zCBdmYuapo1iYJX4nvR7Sru+ySkesQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 10:57:29AM -0700, John Stultz wrote:
> Another area we have to be careful with is there are still
> architectures (powerpc and ia64) which haven't switched from the old
> vsyscall rounding logic (CONFIG_GENERIC_TIME_VSYSCALL_OLD). In these
> cases we add up to 1ns of error each tick/update as we round up the
> sub-nanoseconds to ensure we don't see inconsistencies.  If the
> adjustment logic can't handle this, I don't want to regress those
> arches.

I spent some time trying to figure out a workaround for the nanosecond
rounding, but I didn't find anything that wouldn't complicate the mult
adjustment logic and bring back the problems which the direct division
approach is supposed to solve.

It seems it may be a while before the old vsyscalls are fixed. How
about including only the first two patches from this set for now?

Thanks,

-- 
Miroslav Lichvar
