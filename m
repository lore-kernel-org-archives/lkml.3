Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab3IKTDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:03:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57834 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3IKTDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:03:21 -0400
Message-ID: <5230BE75.7040307@wwwdotorg.org>
Date: Wed, 11 Sep 2013 13:03:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: cpufreq_stats NULL deref on second system suspend
References: <522E1FEF.6080803@wwwdotorg.org> <1775778.MeiRhuYy7o@vostro.rjw.lan> <522F86AD.6010603@wwwdotorg.org> <2521560.SfeNbV74nj@vostro.rjw.lan> <52304439.3030301@linux.vnet.ibm.com> <523094CD.3000506@wwwdotorg.org> <5230B078.3070306@linux.vnet.ibm.com> <5230B991.3040702@linux.vnet.ibm.com>
In-Reply-To: <5230B991.3040702@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 12:42 PM, Srivatsa S. Bhat wrote:
...
> OK, I took a second look at the code, and I suspect that applying the
> second patch might help. So can you try by applying both the patches
> please[1][2]?
> 
...
> [1]. http://marc.info/?l=linux-kernel&m=137889516210816&w=2
> [2]. http://marc.info/?l=linux-kernel&m=137889800511940&w=2

Yes, with both of those patches applies, the problem is solved:-)

I was going to test the second patch originally, but it sounded like it
was more of a cleanup rather than a fix for my issue, so I didn't bother
when I found the problem wasn't solved by patch 1. Sorry!

For the record, I'm testing on a 2-CPU system, so I'm not sure whether
your explanation applies; it talks about CPUs 2 and 3 whereas I only
have CPUs 0 and 1, but perhaps your explanation applies equally to any
pair of CPUs?

For the record, here's the information you requested in the other email:

# cat /sys/devices/system/cpu/cpu*/cpufreq/related_cpus
0 1
0 1

