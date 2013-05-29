Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab3E2RA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 13:00:59 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:18408 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3E2RAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 13:00:52 -0400
Message-ID: <1369846845.6121.6.camel@j-VirtualBox>
Subject: Re: [patch v6 8/8] sched: remove blocked_load_avg in tg
From: Jason Low <jason.low2@hp.com>
To: Alex Shi <alex.shi@intel.com>, jason.low2@hp.com
Cc: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, wangyun@linux.vnet.ibm.com
Date: Wed, 29 May 2013 10:00:45 -0700
In-Reply-To: <1368199049-2798-9-git-send-email-alex.shi@intel.com>
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
	 <1368199049-2798-9-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-10 at 23:17 +0800, Alex Shi wrote:
> blocked_load_avg sometime is too heavy and far bigger than runnable load
> avg. that make balance make wrong decision. So better don't consider it.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>

Hi Alex,

I have been testing these patches with a Java server workload on an 8
socket (80 core) box with Hyperthreading enabled, and I have been seeing
good results with these patches.

When using a 3.10-rc2 tip kernel with patches 1-8, there was about a 40%
improvement in performance of the workload compared to when using the
vanilla 3.10-rc2 tip kernel with no patches. When using a 3.10-rc2 tip
kernel with just patches 1-7, the performance improvement of the
workload over the vanilla 3.10-rc2 tip kernel was about 25%.

Tested-by: Jason Low <jason.low2@hp.com>

Thanks,
Jason

