Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab3HUW1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:27:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40393 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3HUW1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:27:19 -0400
Message-ID: <52153EC3.1030204@wwwdotorg.org>
Date: Wed, 21 Aug 2013 16:27:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, swarren@nvidia.com, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Tegra: remove target_cpu_speed[] array
References: <896370a3ad0db9e85f8776d923fcd5129d4e4d56.1377080903.git.viresh.kumar@linaro.org>
In-Reply-To: <896370a3ad0db9e85f8776d923fcd5129d4e4d56.1377080903.git.viresh.kumar@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 04:31 AM, Viresh Kumar wrote:
> Tegra's cpufreq driver was maintaining requested target frequencies in an array:
> target_cpu_speed. And then finally setting the highest requested freq in the
> core. This was probably done because both cores share clock line and logically
> we want to set both cores to the max frequency requested..
> 
> But this wasn't required to be done in individual CPUFreq drivers, its already
> taken care of by CPUFreq governors. They evaluate load for all CPUs and finally
> call target only for the frequency corresponding to max load.
> 
> So, get rid of this stuff from Tegra's cpufreq driver.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Hi Stephen,
> 
> Its only build tested and depends on lots of stuff that I have already sent for
> cpufreq core and its drivers. All of that is pushed here:
> https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-v3.13
> 
> And only Tegra+cpufreq-core patches are pushed here (only 13 patches):
> https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-next-tegra
> 
> You can probably try cpufreq-next-tegra branch for testing on some real
> hardware.

Acked-by: Stephen Warren <swarren@nvidia.com>

I did test your branch on a Tegra20 and Tegra30 board without issues.
But recall that our cpufreq driver doesn't actually get initialized
since the conversion of Tegra to the common clock framework, so I
haven't really tested the cpufreq changes, except to ensure that nothing
in those branches breaks other basic functionality.
