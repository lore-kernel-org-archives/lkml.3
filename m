Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab3IMPya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:54:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54643 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab3IMPy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:54:28 -0400
Date: Fri, 13 Sep 2013 16:53:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 181/228] cpufreq: move freq change notifications to
	cpufreq core
Message-ID: <20130913155313.GA12758@n2100.arm.linux.org.uk>
References: <cover.1379063063.git.viresh.kumar@linaro.org> <fd43341751c7a00d2f4eedf48d6338f866b26a52.1379063063.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd43341751c7a00d2f4eedf48d6338f866b26a52.1379063063.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 06:32:07PM +0530, Viresh Kumar wrote:
> +		read_lock_irqsave(&cpufreq_driver_lock, flags);
> +		notify = !(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION);
> +		read_unlock_irqrestore(&cpufreq_driver_lock, flags);

I don't think this needs to be read under a lock - if this bit changes
dynamically, then there's something very wrong.
