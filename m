Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab3IMVrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 17:47:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57253 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab3IMVrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 17:47:13 -0400
Date: Fri, 13 Sep 2013 17:47:11 -0400 (EDT)
Message-Id: <20130913.174711.268706749518726971.davem@davemloft.net>
To: viresh.kumar@linaro.org
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 012/228] cpufreq: sparc: call
 cpufreq_frequency_table_get_attr()
From: David Miller <davem@davemloft.net>
In-Reply-To: <56edbe14da9944ad026497bc1a0dc4aaa283d506.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<cover.1379063063.git.viresh.kumar@linaro.org>
	<56edbe14da9944ad026497bc1a0dc4aaa283d506.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 13 Sep 2013 14:47:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Fri, 13 Sep 2013 18:29:18 +0530

> This exposes frequency table of driver to cpufreq core and is required for core
> to guess what the index for a target frequency is, when it calls
> cpufreq_frequency_table_target(). And so this driver needs to expose it.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: sparclinux@vger.kernel.org
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Wait a second, later in this series you add the put_attr() call claiming
it's a fix.

But you're the one adding the "bug" here.

So if you are going to add a get_attr() call you should be adding the
necessary put_attr() call in the same patch.  Otherwise this patch
introduces a bug.
