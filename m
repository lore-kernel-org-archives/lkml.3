Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaDCMt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 08:49:26 -0400
Received: from linux-libre.fsfla.org ([208.118.235.54]:53182 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaDCMtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 08:49:22 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2014 08:49:22 EDT
From: Alexandre Oliva <oliva@gnu.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: loongson2_cpufreq: don't declare local variable as static
Organization: Free thinker, not speaking for the GNU Project
References: <254471b8cee296f860d24368cc467c00b5a07336.1396413826.git.viresh.kumar@linaro.org>
Date: Thu, 03 Apr 2014 09:40:57 -0300
In-Reply-To: <254471b8cee296f860d24368cc467c00b5a07336.1396413826.git.viresh.kumar@linaro.org>
	(Viresh Kumar's message of "Wed, 2 Apr 2014 10:14:24 +0530")
Message-ID: <or61mqio12.fsf@livre.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr  2, 2014, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> did some changes to driver and by mistake made cpuclk as a 'static' local
> variable, which wasn't actually required. Fix it.

FWIW, the same mistake is present in at32.

I've just finished bisecting the cpufreq regression on loongson2.
Indeed, this s/static// patch does not fix it, but it was 652ed95d5fa,
the patch that moved cpuclk into loongson2_cpufreq_cpu_init, that caused
the regression.

Reverting all the changes to loongson2_cpufreq.c in 652ed95d5fa makes
cpufreq work again, as opposed to printing nan% in all cpufreq stats in
cpufreq-info's output, and freezing shortly thereafter.

> -	static struct clk *cpuclk;
> +	struct clk *cpuclk;

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist|Red Hat Brasil GNU Toolchain Engineer
