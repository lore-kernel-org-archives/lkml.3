Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab3HATL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:11:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50909 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248Ab3HATLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:11:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH] cpufreq: Do not hold driver module references for additional policy CPUs
Date: Thu, 01 Aug 2013 21:21:35 +0200
Message-ID: <7752148.JjTSgAt1Xy@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51FAB083.5050900@linux.vnet.ibm.com>
References: <2362640.pUofnXyzOi@vostro.rjw.lan> <1656801.jLHjvytfNU@vostro.rjw.lan> <51FAB083.5050900@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 02, 2013 12:31:23 AM Srivatsa S. Bhat wrote:
> On 08/02/2013 12:31 AM, Rafael J. Wysocki wrote:
> > On Thursday, August 01, 2013 11:36:49 PM Srivatsa S. Bhat wrote:
> >> Its the cpufreq_cpu_get() hidden away in cpufreq_add_dev_symlink(). With
> >> that taken care of, everything should be OK. Then we can change the
> >> synchronization part to avoid using refcounts.
> > 
> > So I actually don't see why cpufreq_add_dev_symlink() needs to call
> > cpufreq_cpu_get() at all, since the policy refcount is already 1 at the
> > point it is called and the bumping up of the driver module refcount is
> > pointless.
> > 
> 
> Hmm, yes, it seems so.
> 
> > However, if I change that I also need to change the piece of code that
> > calls the complementary cpufreq_cpu_put() and I kind of cannot find it.
> > 
> 
> ... I guess that's because you are looking at the code with your patch
> applied (and your patch removed that _put()) ;-)

No, it's not that one.  That one was complementary to the cpufreq_cpu_get()
done by cpufreq_add_policy_cpu() before my patch.  Since my patch changes
cpufreq_add_policy_cpu() to call cpufreq_cpu_put() before returning and
bump up the policy refcount with kobject_get(), the one in
__cpufreq_remove_dev() is changed into kobject_put() (correctly, IMO).

What gives?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
