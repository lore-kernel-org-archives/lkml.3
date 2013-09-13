Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3IMQV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:21:27 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:53178 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab3IMQV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:21:26 -0400
Date: Fri, 13 Sep 2013 18:18:20 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 195/228] cpufreq: kirkwood: remove calls to
 cpufreq_notify_transition()
Message-ID: <20130913161820.GM19363@lunn.ch>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
 <0a512914fd48b2d6db685446f88b9a096eff79a1.1379063063.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a512914fd48b2d6db685446f88b9a096eff79a1.1379063063.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 06:32:21PM +0530, Viresh Kumar wrote:

> -	if (freqs.old != freqs.new) {
> -		local_irq_disable();
> -
> -		/* Disable interrupts to the CPU */
> -		reg = readl_relaxed(priv.base);
> -		reg |= CPU_SW_INT_BLK;
> -		writel_relaxed(reg, priv.base);
> -
> -		switch (state) {
> -		case STATE_CPU_FREQ:
> -			clk_disable(priv.powersave_clk);
> -			break;
> -		case STATE_DDR_FREQ:
> -			clk_enable(priv.powersave_clk);
> -			break;
> -		}

Hi Viresh

I see you removed the test that the old and the new frequency are
different. Is this guaranteed by the core? Because if not, you can
lockup the CPU. The call to cpu_do_idle() will never return.

	Thanks
		Andrew
