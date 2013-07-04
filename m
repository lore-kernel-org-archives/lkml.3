Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab3GDKW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 06:22:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:17777 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3GDKW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 06:22:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,994,1363158000"; 
   d="scan'208";a="365228313"
Message-ID: <51D54CBD.1010400@intel.com>
Date: Thu, 04 Jul 2013 18:21:49 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [PATCH 1/3] clocksource: clean up clocksource_select
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com> <1372916056-24301-2-git-send-email-alex.shi@intel.com> <alpine.DEB.2.02.1307041151170.11637@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307041151170.11637@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> We need this check and it is completely unrelated to the problem
> you're trying to solve.
> 
> Assume the following:
> 
>        System boots with clocksource A and switches into highres mode.
>        Now clocksource B gets registered and B is not highres capable.
> 
>        clocksource_find_best() selects again A, but we have
>        clocksource=B on the kernel command line to override the kernel
>        decision.
> 
> By removing the check, you install he non highres capable clocksource
> B and kill the machine.
> 

You'r right. my bad, Sorry!

BTW, why we allow user override a second best clocksource? I mean user
can override the tsc with hpet. because undetected unstable tsc?



-- 
Thanks
    Alex
