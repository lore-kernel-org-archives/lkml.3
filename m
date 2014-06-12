Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248AbaFLW4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:56:17 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56349 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750811AbaFLW4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:56:16 -0400
Date: Thu, 12 Jun 2014 23:55:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/3] Use Tegra's microsecond counter for udelay()
Message-ID: <20140612225553.GO23430@n2100.arm.linux.org.uk>
References: <1402588713-18766-1-git-send-email-pdeschrijver@nvidia.com> <539A01B4.3050503@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539A01B4.3050503@wwwdotorg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 01:38:28PM -0600, Stephen Warren wrote:
> On 06/12/2014 09:58 AM, Peter De Schrijver wrote:
> > This patchset introduces support for Tegra's microsecond counter as the
> > udelay() timer. This is useful on Tegra SoCs which do not have an arch timer
> > such as Tegra20 and Tegra30. Using the microsecond counter instead of a delay
> > based loop avoids potential problems during cpu frequency changes.
> > 
> > The set consists of 3 patches:
> > 
> > Patch 1 introduces a new call which is used by the ARM architecture delay
> > timer code to prevent changing the delay timer after calibration is finished
> > and thus can be in use.
> > 
> > Patch 2 adds logic to choose the delay timer with the highest resolution. This
> > allows the same registration code to be used on all Tegra SoCs and yet use the
> > higher resolution arch timer when available (eg on Tegra114 or Tegra124).
> > 
> > Patch 3 adds the actual delay timer code.
> > 
> > Patch set has been verified on ventana (Tegra20), beaver (Tegra30),
> > dalmore (Tegra114) and jetson TK1 (Tegra124).
> 
> Russell, Paul, do patches 1 and 2 look good to you? If so, if you can
> ack them, I'd be happy to queue this series in the Tegra git tree. If
> that doesn't work for you, please let me know who will apply these
> patches. Thanks.

When I saw them, I did have a question in the back of my mind about
the interlocking - whether we should just mandate that these are
always registered before delay calibration.  Then I remember the
mess that platforms made of the sched_clock() stuff.

So, I don't see any other way to ensure that platforms do the right
thing other than providing that kind of stick...  so I guess we'll
have to have them.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
