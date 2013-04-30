Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab3D3SqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:46:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821Ab3D3SqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:46:17 -0400
Date: Tue, 30 Apr 2013 14:46:12 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: paul.mckenney@linaro.org
Subject: Re: rcu: Provide compile-time control for no-CBs CPUs
Message-ID: <20130430184612.GA14568@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	paul.mckenney@linaro.org
References: <20130430152126.0C564660906@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430152126.0C564660906@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 03:21:26PM +0000, Linux Kernel wrote:

 > +choice
 > +	prompt "Build-forced no-CBs CPUs"
 > +	default RCU_NOCB_CPU_NONE
 > +	help
 > +	  This option allows no-CBs CPUs to be specified at build time.
 > +	  Additional no-CBs CPUs may be specified by the rcu_nocbs=
 > +	  boot parameter.
 > +
 > +config RCU_NOCB_CPU_NONE
 > +	bool "No build_forced no-CBs CPUs"
 > +	depends on RCU_NOCB_CPU
 > +	help
 > +	  This option does not force any of the CPUs to be no-CBs CPUs.
 > +	  Only CPUs designated by the rcu_nocbs= boot parameter will be
 > +	  no-CBs CPUs.
 > +
 > +config RCU_NOCB_CPU_ZERO
 > +	bool "CPU 0 is a build_forced no-CBs CPU"
 > +	depends on RCU_NOCB_CPU
 > +	help
 > +	  This option forces CPU 0 to be a no-CBs CPU.  Additional CPUs
 > +	  may be designated as no-CBs CPUs using the rcu_nocbs= boot
 > +	  parameter will be no-CBs CPUs.
 > +
 > +	  Select this if CPU 0 needs to be a no-CBs CPU for real-time
 > +	  or energy-efficiency reasons.
 > +
 > +config RCU_NOCB_CPU_ALL
 > +	bool "All CPUs are build_forced no-CBs CPUs"
 > +	depends on RCU_NOCB_CPU
 > +	help
 > +	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
 > +	  boot parameter will be ignored.
 > +
 > +	  Select this if all CPUs need to be no-CBs CPUs for real-time
 > +	  or energy-efficiency reasons.

Note that entering '?' when prompted in oldconfig only outputs the help
parameter from the choice section.

Additionally, nowhere in any of this text does it say what a "no-CB CPU" is,
or why I would care, or even what the downsides are for each option.

I nominate this changeset for an award for most obtuse kconfig text in 3.10 (so far)

	Dave

