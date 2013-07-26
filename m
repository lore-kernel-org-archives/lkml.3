Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab3GZSNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:13:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab3GZSNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:13:13 -0400
Message-ID: <51F2BC31.7000407@redhat.com>
Date: Fri, 26 Jul 2013 14:13:05 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jeremy Eder <jeder@redhat.com>
CC: linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        youquan.song@intel.com, paulmck@linux.vnet.ibm.com,
        daniel.lezcano@linaro.org, arjan@linux.intel.com, len.brown@intel.com
Subject: Re: RFC:  revert request for cpuidle patches e11538d1 and 69a37bea
References: <20130726173306.GB17985@jeder.rdu.redhat.com>
In-Reply-To: <20130726173306.GB17985@jeder.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 01:33 PM, Jeremy Eder wrote:
> Hello,
>
> We believe we've identified a particular commit to the cpuidle code that
> seems to be impacting performance of variety of workloads.  The simplest way to
> reproduce is using netperf TCP_RR test, so we're using that, on a pair of
> Sandy Bridge based servers.  We also have data from a large database setup
> where performance is also measurably/positively impacted, though that test
> data isn't easily share-able.
>
> Included below are test results from 3 test kernels:
>
> kernel       reverts
> -----------------------------------------------------------
> 1) vanilla   upstream (no reverts)
>
> 2) perfteam2 reverts e11538d1f03914eb92af5a1a378375c05ae8520c
>
> 3) test      reverts 69a37beabf1f0a6705c08e879bdd5d82ff6486c4
>                       e11538d1f03914eb92af5a1a378375c05ae8520c
>
> In summary, netperf TCP_RR numbers improve by approximately 4% after
> reverting 69a37beabf1f0a6705c08e879bdd5d82ff6486c4.  When
> 69a37beabf1f0a6705c08e879bdd5d82ff6486c4 is included, C0 residency never
> seems to get above 40%.  Taking that patch out gets C0 near 100% quite
> often, and performance increases.

Could you try running the tests with just the repeat mode
stuff from commit 69a37bea excluded, but leaving the common
infrastructure and commit e11538?

-- 
All rights reversed
