Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab3GVP0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:26:05 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:43075 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab3GVP0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:26:02 -0400
Message-ID: <51ED4E2D.5020908@linux.vnet.ibm.com>
Date: Mon, 22 Jul 2013 20:52:21 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Kiko Piris <kernel@pirispons.net>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: 3.10.1 cpufreq suspend/resume regression still present in 3.10.2
References: <20130722151653.GA7213@sacarino.pirispons.net>
In-Reply-To: <20130722151653.GA7213@sacarino.pirispons.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072215-5564-0000-0000-000008E8AC4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 08:46 PM, Kiko Piris wrote:
> Hi,
> 
> linux-3.10.1 introduced a regression in cpufreq breaking suspend/resume
> cycle for some people [1].
> 
> There were also some other threads about it in lkml.
> 
> I see 3.10.2-stable was released some days ago. I couldn’t see anything
> about fixing this regression reported in the changelog.
> 
> And to be 110% certain, I compiled it and tried suspending/resuming;
> it’s still broken.
> 
> Is this going to be fixed in 3.10 stable branch?
> 

The patches that fix that regression went into mainline just a few days
ago as these commits: 

commit aae760ed21cd690fe8a6db9f3a177ad55d7e12ab
Author: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Date:   Fri Jul 12 03:45:37 2013 +0530

    cpufreq: Revert commit a66b2e to fix suspend/resume regression


commit e8d05276f236ee6435e78411f62be9714e0b9377
Author: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Date:   Tue Jul 16 22:46:48 2013 +0200

    cpufreq: Revert commit 2f7021a8 to fix CPU hotplug regression


And both of them have been CC'ed to -stable. So they should be hitting
the stable tree soon.

Hmm, that reminds me.. whenever a patch cc'ed to stable hit the mainline,
the patch signers used to receive an automatic email from Greg. I didn't
get that for the above two patches.. Did the process change due to the
recent discussions around -stable tree maintenance?


Regards,
Srivatsa S. Bhat

