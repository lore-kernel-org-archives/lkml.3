Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbaFIKwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:52:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45845 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbaFIKwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:52:51 -0400
Date: Mon, 9 Jun 2014 12:52:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        arvind.chauhan@arm.com, srivatsa.bhat@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, ego@linux.vnet.ibm.com
Subject: Re: [PATCH] cpufreq: governor: remove copy_prev_load from 'struct
 cpu_dbs_common_info'
Message-ID: <20140609105248.GA25705@amd.pavel.ucw.cz>
References: <d4241c6ef57c901dde270380cce74e24effa4852.1402291351.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4241c6ef57c901dde270380cce74e24effa4852.1402291351.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-06-09 10:54:17, Viresh Kumar wrote:
> 'copy_prev_load' was recently added by commit: 18b46ab (cpufreq: governor: Be
> friendly towards latency-sensitive bursty workloads).
> 
> It actually is a bit redundant as we also have 'prev_load' which can store any
> integer value and can be used instead of 'copy_prev_load' by setting it to zero
> when we don't want to use previous load.
> 
> So, drop 'copy_prev_load' and use 'prev_load' instead.
> 
> Update comments as well to make it more clear.
> 
> There is another change here which was probably missed by Srivatsa during the
> last version of updates he made. The unlikely in the 'if' statement was covering
> only half of the condition and the whole line should actually come under it.
> 
> Also checkpatch is made more silent as it was reporting this (--strict option):
> 
> CHECK: Alignment should match open parenthesis
> +		if (unlikely(wall_time > (2 * sampling_rate) &&
> +						j_cdbs->prev_load)) {
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
