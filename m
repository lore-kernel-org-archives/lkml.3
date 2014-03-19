Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726AbaCSKBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:01:07 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:35089 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933254AbaCSKBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:01:05 -0400
Message-ID: <53296AD0.5090908@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 15:30:48 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>
Subject: Re: [PATCH 0/2] Add exit_prepare callback to the cpufreq_driver interface.
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com> <CAKohponGN4JNwLKLjvFOPkru0=6JajOKKH=oJneDkKp=PyAmRA@mail.gmail.com> <53234A70.70506@gmail.com>	<53656551.Rzgh2mDLCG@vostro.rjw.lan> <53283913.1070003@linux.vnet.ibm.com> <CAKohpomLW17B=Sk42tczzDF+VGwn7hT521osWPi5TcgqpCPZ_w@mail.gmail.com>
In-Reply-To: <CAKohpomLW17B=Sk42tczzDF+VGwn7hT521osWPi5TcgqpCPZ_w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031910-9264-0000-0000-000005AB37B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 10:33 AM, Viresh Kumar wrote:
> On 18 March 2014 17:46, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> Agreed. As far as I understand, for ->target drivers, today we use GOV_STOP
>> to stop managing the CPU going offline. And for ->setpolicy drivers, we will
>> use this new callback to achieve the same goal.
> 
> So a better question would be: What's the purpose of ->stop() call for a policy?

Ideally, it should remove the outgoing CPU from the policy and "stop managing
that CPU", whatever that means to the driver (for intel_pstate, it means
setting it to min P state and destroying the timer).

> Stop managing CPUs of that policy?

Stop managing only the particular CPU going offline. IOW, we should somehow
communicate to the ->stop() callback that we are taking CPU 'x' offline.

If adding a ->stop() callback in the cpufreq_driver is not the best way to
achieve it, then lets think of an alternative. The way I look at it, this
new mechanism what we want, should allow ->setpolicy drivers to do what the
GOV_STOP will do for regular drivers. That is, allow it to "shutdown the
CPU from a cpufreq perspective", whatever that means to the driver.
We can think of a completely different way of achieving it, if ->stop()
is not suitable for that purpose.

> Or even do something on CPUs of a policy
> before CPUs are offlined?
> 
> Probably in the current solution Dirk is doing both these things..
> 
> And so I thought maybe its better not to restrict ->stop() to just
> setpolicy() drivers.


Regards,
Srivatsa S. Bhat

