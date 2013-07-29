Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab3G2QFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:05:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:1153 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab3G2QFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:05:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,770,1367996400"; 
   d="scan'208";a="274856544"
Message-ID: <51F69293.1060308@linux.intel.com>
Date: Mon, 29 Jul 2013 09:04:35 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>, Rik van Riel <riel@redhat.com>,
        Jeremy Eder <jeder@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "youquan.song@intel.com" <youquan.song@intel.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: RFC:  revert request for cpuidle patches e11538d1 and 69a37bea
References: <20130726173306.GB17985@jeder.rdu.redhat.com> <51F2BC31.7000407@redhat.com> <51F2BF8C.7010308@linux.intel.com> <51F2C014.90102@redhat.com> <51F37290.5050101@linaro.org> <51F66A5A.9060901@linux.intel.com> <20130729141455.GA9590@e102568-lin.cambridge.arm.com> <51F67C40.60701@linux.intel.com> <20130729160106.GA13311@e102568-lin.cambridge.arm.com>
In-Reply-To: <20130729160106.GA13311@e102568-lin.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/2013 9:01 AM, Lorenzo Pieralisi wrote:
>
>> Coupled C states on this level are a PAIN in many ways, and tend to totally suck for power
>> due to this and the general "too much is active" reasons.
>
> I think the trend is moving towards core gating, which resembles a lot to what
> x86 world does today. Still, the interaction between menu governor and
> cluster states has to be characterized and that's we are doing at the
> moment.

I suspect that we (Linux) need a different governor than menu for the coupled case.
Fundamentally you're going to need different algorithms that are much closer tied
to the behavior of the specific hardware; the current menu governor uses an abstract
and simple hardware model (fully independent).
For specific hardware that deviates from the model, something different is clearly needed.

It's an open question for me if just the predictor is the part that
you split out, or if the whole governor needs to be split out.
(but frankly, if you take the predictor out of the menu governor, not a whole lot is left)

